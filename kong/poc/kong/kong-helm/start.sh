#!/bin/bash
set -euo pipefail

############################################
# CONFIGURAÇÕES
############################################

NAMESPACE_KONG="kong"
NAMESPACE_ARGOCD="argocd"

AWS_REGION="sa-east-1"
AWS_ACCOUNT_ID="618430153747"
AWS_PROFILE="opus-labs"

ECR_REPO="opus-open-banking-release/oob-kong"
IMAGE_TAG="2.35.0.17618d5-kong-3.10"

FULL_ECR_IMAGE="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}"

KIND_CLUSTER_NAME="kind"
KIND_NODE="${KIND_CLUSTER_NAME}-control-plane"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CERTS_DIR="$SCRIPT_DIR/certs"

############################################
# VALIDAÇÕES
############################################

check_dependencies() {
    for cmd in aws docker kubectl helm kind openssl; do
        command -v "$cmd" >/dev/null 2>&1 || {
            echo "Erro: comando '$cmd' não encontrado."
            exit 1
        }
    done
}

############################################
# AWS LOGIN + AUTO RENEW SSO
############################################

check_aws_login() {
    if ! aws sts get-caller-identity --profile "${AWS_PROFILE}" >/dev/null 2>&1; then
        echo "Sessão AWS expirada ou inválida. Executando aws sso login..."
        aws sso login --profile "${AWS_PROFILE}"
    fi
}

login_ecr() {
    check_aws_login

    echo "Realizando login no ECR..."
    aws ecr get-login-password \
        --region "${AWS_REGION}" \
        --profile "${AWS_PROFILE}" \
    | docker login --username AWS --password-stdin \
        "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
}

############################################
# IMPORTAR IMAGEM PARA O KIND
############################################

import_kong_image() {

    echo "=== Importando imagem do Kong para o KIND ==="

    if ! kind get clusters | grep -q "^${KIND_CLUSTER_NAME}$"; then
        echo "Cluster kind '${KIND_CLUSTER_NAME}' não encontrado."
        exit 1
    fi

    login_ecr

    echo "Pull da imagem original..."
    docker pull --platform=linux/amd64 "${FULL_ECR_IMAGE}"

    echo "Carregando imagem no KIND (mantendo nome original)..."
    kind load docker-image "${FULL_ECR_IMAGE}" \
        --name "${KIND_CLUSTER_NAME}"

    echo "Validando importação no containerd..."
    docker exec "${KIND_NODE}" \
        ctr -n k8s.io images ls | grep "${ECR_REPO##*/}" >/dev/null || {
        echo "Falha ao validar imagem importada."
        exit 1
    }

    echo "✅ Imagem importada com sucesso no KIND."
}

############################################
# HELM REPOS
############################################

add_helm_repos() {
    echo "=== Atualizando repositórios Helm ==="
    helm repo add bitnami https://charts.bitnami.com/bitnami 2>/dev/null || true
    helm repo add kong https://charts.konghq.com 2>/dev/null || true
    helm repo add argo https://argoproj.github.io/argo-helm 2>/dev/null || true
    helm repo update
}

############################################
# INSTALAR KONG
############################################

install_kong() {

    echo "=== Instalando Kong (modo híbrido) ==="

    import_kong_image

    kubectl create ns "$NAMESPACE_KONG" 2>/dev/null || true

    # Certificados TLS cluster
    if [ ! -f "$CERTS_DIR/cluster.key" ]; then
        echo "Gerando certificados do cluster..."
        mkdir -p "$CERTS_DIR"
        openssl req -new -x509 -nodes -newkey rsa:2048 \
          -keyout "$CERTS_DIR/cluster.key" \
          -out "$CERTS_DIR/cluster.crt" \
          -days 1095 -subj "/CN=kong_clustering"
        chmod 600 "$CERTS_DIR/cluster.key"
    fi

    # Secret TLS
    if ! kubectl get secret kong-cluster-cert -n "$NAMESPACE_KONG" &>/dev/null; then
        kubectl create secret tls kong-cluster-cert -n "$NAMESPACE_KONG" \
          --cert="$CERTS_DIR/cluster.crt" \
          --key="$CERTS_DIR/cluster.key"
    fi

    echo "Instalando PostgreSQL..."
    helm upgrade --install postgres-kong bitnami/postgresql \
      -n "$NAMESPACE_KONG" \
      -f "$SCRIPT_DIR/values-pg.yaml" \
      --wait --timeout 5m

    echo "Instalando Kong Control Plane..."
    helm upgrade --install kong-cp kong/kong \
      -n "$NAMESPACE_KONG" \
      -f "$SCRIPT_DIR/values-cp.yaml" \
      --wait --timeout 5m

    echo "Instalando Kong Data Plane..."
    helm upgrade --install kong-dp kong/kong \
      -n "$NAMESPACE_KONG" \
      -f "$SCRIPT_DIR/values-dp.yaml" \
      --wait --timeout 5m

    echo ""
    echo "✅ Kong instalado com sucesso!"
    kubectl get pods -n "$NAMESPACE_KONG"
}

############################################
# INSTALAR ARGOCD
############################################

install_argocd() {

    echo "=== Instalando ArgoCD ==="

    kubectl create ns "$NAMESPACE_ARGOCD" 2>/dev/null || true

    helm upgrade --install argocd argo/argo-cd \
      -n "$NAMESPACE_ARGOCD" \
      -f "$SCRIPT_DIR/values-argocd.yaml" \
      --wait --timeout 5m

    echo ""
    echo "✅ ArgoCD instalado com sucesso!"
    kubectl get pods -n "$NAMESPACE_ARGOCD"

    echo ""
    echo "Senha inicial do admin:"
    echo "kubectl -n $NAMESPACE_ARGOCD get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo"
}

############################################
# UNINSTALL KONG
############################################

uninstall_kong() {

    echo "=== Removendo Kong ==="

    helm uninstall kong-dp -n "$NAMESPACE_KONG" 2>/dev/null || true
    helm uninstall kong-cp -n "$NAMESPACE_KONG" 2>/dev/null || true
    helm uninstall postgres-kong -n "$NAMESPACE_KONG" 2>/dev/null || true

    kubectl delete secret kong-cluster-cert -n "$NAMESPACE_KONG" 2>/dev/null || true
    kubectl delete pvc --all -n "$NAMESPACE_KONG" 2>/dev/null || true
    kubectl delete ns "$NAMESPACE_KONG" 2>/dev/null || true

    echo "✅ Kong removido."
}

############################################
# UNINSTALL ARGOCD
############################################

uninstall_argocd() {

    echo "=== Removendo ArgoCD ==="

    helm uninstall argocd -n "$NAMESPACE_ARGOCD" 2>/dev/null || true
    kubectl delete pvc --all -n "$NAMESPACE_ARGOCD" 2>/dev/null || true
    kubectl delete ns "$NAMESPACE_ARGOCD" 2>/dev/null || true

    echo "✅ ArgoCD removido."
}

############################################
# STATUS
############################################

status() {

    echo ""
    echo "--- Kong (namespace: $NAMESPACE_KONG) ---"
    kubectl get pods -n "$NAMESPACE_KONG" 2>/dev/null || echo "Namespace não encontrado."

    echo ""
    echo "--- ArgoCD (namespace: $NAMESPACE_ARGOCD) ---"
    kubectl get pods -n "$NAMESPACE_ARGOCD" 2>/dev/null || echo "Namespace não encontrado."
}

############################################
# INSTALAÇÃO COMPLETA
############################################

install() {
    check_dependencies
    add_helm_repos
    install_kong
    install_argocd

    echo ""
    echo "=========================================="
    echo "  Todos os serviços instalados!"
    echo "=========================================="
}

############################################
# DESINSTALAÇÃO COMPLETA
############################################

uninstall() {
    uninstall_argocd
    uninstall_kong
    echo "✅ Ambiente totalmente limpo."
}

############################################
# MENU
############################################

if [ -z "${1:-}" ]; then
    echo "=========================================="
    echo "  Kong + ArgoCD - Gerenciador Helm"
    echo "=========================================="
    echo ""
    echo "Uso: ./start.sh <comando>"
    echo ""
    echo "Comandos:"
    echo "  install           Instalar tudo"
    echo "  install-kong      Instalar apenas Kong"
    echo "  install-argocd    Instalar apenas ArgoCD"
    echo "  uninstall         Remover tudo"
    echo "  uninstall-kong    Remover apenas Kong"
    echo "  uninstall-argocd  Remover apenas ArgoCD"
    echo "  status            Ver status"
    echo ""
    exit 1
fi

case "$1" in
    install)            install ;;
    install-kong)       check_dependencies && add_helm_repos && install_kong ;;
    install-argocd)     check_dependencies && add_helm_repos && install_argocd ;;
    uninstall)          uninstall ;;
    uninstall-kong)     uninstall_kong ;;
    uninstall-argocd)   uninstall_argocd ;;
    status)             status ;;
    *)
        echo "Comando inválido: $1"
        exit 1
        ;;
esac
