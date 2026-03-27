#!/bin/bash
# ===========================================================================
# start.sh — Gerenciador do ambiente Kong + ArgoCD no Kind
#
# Script unificado para instalar, desinstalar e verificar status
# de todo o stack: PostgreSQL + Kong CP/DP + ArgoCD.
#
# Uso:
#   ./start.sh install           # Instala tudo (Kong + ArgoCD)
#   ./start.sh install-kong      # Apenas Kong (PG + CP + DP)
#   ./start.sh install-argocd    # Apenas ArgoCD
#   ./start.sh uninstall         # Remove tudo
#   ./start.sh uninstall-kong    # Remove apenas Kong
#   ./start.sh uninstall-argocd  # Remove apenas ArgoCD
#   ./start.sh status            # Mostra pods, services e credenciais
#
# Pré-requisitos: aws, docker, kubectl, helm, kind, openssl
# ===========================================================================
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

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info()  { echo -e "${BLUE}[INFO]${NC}  $*"; }
log_ok()    { echo -e "${GREEN}[OK]${NC}    $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }

# Timer — mede duração de cada operação
timer_start() { SECONDS=0; }
timer_show()  { echo -e "${BLUE}[TIME]${NC}  $1: ${SECONDS}s"; }

############################################
# VALIDAÇÕES
############################################

check_dependencies() {
    local missing=()
    for cmd in aws docker kubectl helm kind openssl; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing+=("$cmd")
        fi
    done

    if [ ${#missing[@]} -gt 0 ]; then
        log_error "Comandos não encontrados: ${missing[*]}"
        log_error "Instale antes de continuar."
        exit 1
    fi
    log_ok "Todas as dependências encontradas."
}

############################################
# AWS LOGIN + AUTO RENEW SSO
############################################

check_aws_login() {
    if ! aws sts get-caller-identity --profile "${AWS_PROFILE}" >/dev/null 2>&1; then
        log_warn "Sessão AWS expirada. Executando aws sso login..."
        aws sso login --profile "${AWS_PROFILE}"
    fi
}

login_ecr() {
    check_aws_login

    log_info "Realizando login no ECR..."
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
    timer_start
    log_info "=== Importando imagem do Kong para o KIND ==="

    if ! kind get clusters | grep -q "^${KIND_CLUSTER_NAME}$"; then
        log_error "Cluster Kind '${KIND_CLUSTER_NAME}' não encontrado."
        log_info "Crie com: kind create cluster --config kind-config.yaml"
        exit 1
    fi

    # Verifica se imagem já existe no Kind (evita re-import desnecessário)
    if docker exec "${KIND_NODE}" ctr -n k8s.io images ls 2>/dev/null | grep -q "${IMAGE_TAG}" ; then
        log_ok "Imagem já existe no Kind. Pulando import."
        return 0
    fi

    login_ecr

    log_info "Pull da imagem original..."
    docker pull --platform=linux/amd64 "${FULL_ECR_IMAGE}"

    # Contorna bug containerd v2: "no unpack platforms defined"
    log_info "Carregando imagem no KIND..."
    docker save "${FULL_ECR_IMAGE}" | docker exec -i "${KIND_NODE}" ctr -n k8s.io images import -

    # Valida importação
    docker exec "${KIND_NODE}" \
        ctr -n k8s.io images ls | grep "${ECR_REPO##*/}" >/dev/null || {
        log_error "Falha ao validar imagem importada."
        exit 1
    }

    timer_show "Import de imagem"
    log_ok "Imagem importada com sucesso no KIND."
}

############################################
# HELM REPOS
############################################

add_helm_repos() {
    log_info "=== Atualizando repositórios Helm ==="
    helm repo add bitnami https://charts.bitnami.com/bitnami 2>/dev/null || true
    helm repo add kong https://charts.konghq.com 2>/dev/null || true
    helm repo add argo https://argoproj.github.io/argo-helm 2>/dev/null || true
    helm repo update
}

############################################
# INSTALAR KONG
############################################

install_kong() {
    timer_start
    log_info "=== Instalando Kong (modo híbrido) ==="

    import_kong_image

    kubectl create ns "$NAMESPACE_KONG" 2>/dev/null || true

    # Gera certificados TLS para comunicação CP ↔ DP
    if [ ! -f "$CERTS_DIR/cluster.key" ]; then
        log_info "Gerando certificados do cluster..."
        mkdir -p "$CERTS_DIR"
        openssl req -new -x509 -nodes -newkey rsa:2048 \
          -keyout "$CERTS_DIR/cluster.key" \
          -out "$CERTS_DIR/cluster.crt" \
          -days 1095 -subj "/CN=kong_clustering"
        chmod 600 "$CERTS_DIR/cluster.key"
    fi

    # Cria Secret TLS (idempotente)
    if ! kubectl get secret kong-cluster-cert -n "$NAMESPACE_KONG" &>/dev/null; then
        kubectl create secret tls kong-cluster-cert -n "$NAMESPACE_KONG" \
          --cert="$CERTS_DIR/cluster.crt" \
          --key="$CERTS_DIR/cluster.key"
    fi

    log_info "Instalando PostgreSQL..."
    helm upgrade --install postgres-kong bitnami/postgresql \
      -n "$NAMESPACE_KONG" \
      -f "$SCRIPT_DIR/values-pg.yaml" \
      --wait --timeout 5m

    log_info "Instalando Kong Control Plane..."
    helm upgrade --install kong-cp kong/kong \
      -n "$NAMESPACE_KONG" \
      -f "$SCRIPT_DIR/values-cp.yaml" \
      --wait --timeout 5m

    log_info "Instalando Kong Data Plane..."
    helm upgrade --install kong-dp kong/kong \
      -n "$NAMESPACE_KONG" \
      -f "$SCRIPT_DIR/values-dp.yaml" \
      --wait --timeout 5m

    timer_show "Instalação Kong"
    log_ok "Kong instalado com sucesso!"
    echo ""
    kubectl get pods -n "$NAMESPACE_KONG"
}

############################################
# INSTALAR ARGOCD
############################################

install_argocd() {
    timer_start
    log_info "=== Instalando ArgoCD ==="

    kubectl create ns "$NAMESPACE_ARGOCD" 2>/dev/null || true

    helm upgrade --install argocd argo/argo-cd \
      -n "$NAMESPACE_ARGOCD" \
      -f "$SCRIPT_DIR/values-argocd.yaml" \
      --wait --timeout 5m

    timer_show "Instalação ArgoCD"
    log_ok "ArgoCD instalado com sucesso!"
    kubectl get pods -n "$NAMESPACE_ARGOCD"

    echo ""
    log_info "Senha inicial do admin:"
    echo "  kubectl -n $NAMESPACE_ARGOCD get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo"
    echo ""
    log_info "UI: http://localhost:30080 (NodePort)"
}

############################################
# UNINSTALL KONG
############################################

uninstall_kong() {
    log_info "=== Removendo Kong ==="

    helm uninstall kong-dp -n "$NAMESPACE_KONG" 2>/dev/null || true
    helm uninstall kong-cp -n "$NAMESPACE_KONG" 2>/dev/null || true
    helm uninstall postgres-kong -n "$NAMESPACE_KONG" 2>/dev/null || true

    kubectl delete secret kong-cluster-cert -n "$NAMESPACE_KONG" 2>/dev/null || true
    kubectl delete pvc --all -n "$NAMESPACE_KONG" 2>/dev/null || true
    kubectl delete ns "$NAMESPACE_KONG" 2>/dev/null || true

    log_ok "Kong removido."
}

############################################
# UNINSTALL ARGOCD
############################################

uninstall_argocd() {
    log_info "=== Removendo ArgoCD ==="

    helm uninstall argocd -n "$NAMESPACE_ARGOCD" 2>/dev/null || true
    kubectl delete pvc --all -n "$NAMESPACE_ARGOCD" 2>/dev/null || true
    kubectl delete ns "$NAMESPACE_ARGOCD" 2>/dev/null || true

    log_ok "ArgoCD removido."
}

############################################
# STATUS
############################################

status() {
    echo ""
    echo -e "${BLUE}━━━ Kong (namespace: $NAMESPACE_KONG) ━━━${NC}"
    kubectl get pods,svc -n "$NAMESPACE_KONG" 2>/dev/null || log_warn "Namespace não encontrado."

    echo ""
    echo -e "${BLUE}━━━ ArgoCD (namespace: $NAMESPACE_ARGOCD) ━━━${NC}"
    kubectl get pods,svc -n "$NAMESPACE_ARGOCD" 2>/dev/null || log_warn "Namespace não encontrado."

    # Mostra senha do ArgoCD se disponível
    echo ""
    local pwd
    pwd=$(kubectl -n "$NAMESPACE_ARGOCD" get secret argocd-initial-admin-secret \
      -o jsonpath='{.data.password}' 2>/dev/null | base64 -d 2>/dev/null) || true
    if [ -n "$pwd" ]; then
        echo -e "${GREEN}ArgoCD admin password:${NC} $pwd"
    fi
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
    log_ok "=========================================="
    log_ok "  Todos os serviços instalados!"
    log_ok "=========================================="
    echo ""
    status
}

############################################
# DESINSTALAÇÃO COMPLETA
############################################

uninstall() {
    uninstall_argocd
    uninstall_kong
    log_ok "Ambiente totalmente limpo."
}

############################################
# MENU
############################################

if [ -z "${1:-}" ]; then
    echo -e "${BLUE}==========================================${NC}"
    echo -e "${BLUE}  Kong + ArgoCD - Gerenciador Helm${NC}"
    echo -e "${BLUE}==========================================${NC}"
    echo ""
    echo "Uso: ./start.sh <comando>"
    echo ""
    echo "Comandos:"
    echo "  install           Instalar tudo (Kong + ArgoCD)"
    echo "  install-kong      Instalar apenas Kong (PG + CP + DP)"
    echo "  install-argocd    Instalar apenas ArgoCD"
    echo "  uninstall         Remover tudo"
    echo "  uninstall-kong    Remover apenas Kong"
    echo "  uninstall-argocd  Remover apenas ArgoCD"
    echo "  status            Ver pods, services e credenciais"
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
        log_error "Comando inválido: $1"
        exit 1
        ;;
esac
