#!/bin/bash
set -e

NAMESPACE_KONG="kong"
NAMESPACE_ARGOCD="argocd"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CERTS_DIR="$SCRIPT_DIR/certs"

add_helm_repos() {
    echo "=== Adicionando repositórios Helm ==="
    helm repo add bitnami https://charts.bitnami.com/bitnami 2>/dev/null || true
    helm repo add kong https://charts.konghq.com 2>/dev/null || true
    helm repo add argo https://argoproj.github.io/argo-helm 2>/dev/null || true
    helm repo update bitnami kong argo
}

install_kong() {
    echo "=== Instalando Kong via Helm (modo híbrido) ==="

    # 1. Namespace
    kubectl create ns "$NAMESPACE_KONG" 2>/dev/null || true

    # 2. Certificados para o modo híbrido
    if [ ! -f "$CERTS_DIR/cluster.key" ]; then
        echo "Gerando certificados do cluster..."
        mkdir -p "$CERTS_DIR"
        openssl req -new -x509 -nodes -newkey rsa:2048 \
          -keyout "$CERTS_DIR/cluster.key" -out "$CERTS_DIR/cluster.crt" \
          -days 1095 -subj "/CN=kong_clustering"
        chmod 644 "$CERTS_DIR/cluster.key"
    fi

    # 3. Secret TLS no Kubernetes
    if ! kubectl get secret kong-cluster-cert -n "$NAMESPACE_KONG" &>/dev/null; then
        echo "Criando secret TLS..."
        kubectl create secret tls kong-cluster-cert -n "$NAMESPACE_KONG" \
          --cert="$CERTS_DIR/cluster.crt" \
          --key="$CERTS_DIR/cluster.key"
    fi

    # 4. PostgreSQL
    echo "Instalando PostgreSQL..."
    helm upgrade --install postgres-kong bitnami/postgresql -n "$NAMESPACE_KONG" \
      -f "$SCRIPT_DIR/values-pg.yaml" \
      --wait --timeout 300s

    # 5. Kong Control Plane
    echo "Instalando Kong Control Plane..."
    helm upgrade --install kong-cp kong/kong -n "$NAMESPACE_KONG" \
      -f "$SCRIPT_DIR/values-cp.yaml" \
      --wait --timeout 120s

    # 6. Kong Data Plane
    echo "Instalando Kong Data Plane..."
    helm upgrade --install kong-dp kong/kong -n "$NAMESPACE_KONG" \
      -f "$SCRIPT_DIR/values-dp.yaml" \
      --wait --timeout 120s

    echo ""
    echo "=== Kong instalado com sucesso! ==="
    echo ""
    kubectl get pods -n "$NAMESPACE_KONG"
}

install_argocd() {
    echo "=== Instalando ArgoCD via Helm ==="

    # 1. Namespace
    kubectl create ns "$NAMESPACE_ARGOCD" 2>/dev/null || true

    # 2. ArgoCD
    echo "Instalando ArgoCD..."
    helm upgrade --install argocd argo/argo-cd -n "$NAMESPACE_ARGOCD" \
      -f "$SCRIPT_DIR/values-argocd.yaml" \
      --wait --timeout 300s

    echo ""
    echo "=== ArgoCD instalado com sucesso! ==="
    echo ""
    kubectl get pods -n "$NAMESPACE_ARGOCD"

    echo ""
    echo "Para obter a senha inicial do admin:"
    echo "  kubectl -n $NAMESPACE_ARGOCD get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo"
}

install() {
    add_helm_repos
    install_kong
    install_argocd

    echo ""
    echo "=========================================="
    echo "  Todos os serviços instalados!"
    echo "=========================================="
    echo ""
    echo "  Kong:"
    echo "    Admin API:    kubectl port-forward -n $NAMESPACE_KONG svc/kong-cp-kong-admin 9001:8001"
    echo "    Manager GUI:  kubectl port-forward -n $NAMESPACE_KONG svc/kong-cp-kong-manager 8002:8002"
    echo "    Proxy:        kubectl port-forward -n $NAMESPACE_KONG svc/kong-dp-kong-proxy 9000:80"
    echo ""
    echo "  ArgoCD:"
    echo "    UI:           kubectl port-forward -n $NAMESPACE_ARGOCD svc/argocd-server 8080:80"
    echo "    Senha admin:  kubectl -n $NAMESPACE_ARGOCD get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo"
    echo ""
}

uninstall_kong() {
    echo "=== Removendo Kong do Kubernetes ==="

    helm uninstall kong-dp -n "$NAMESPACE_KONG" 2>/dev/null && echo "Kong DP removido" || true
    helm uninstall kong-cp -n "$NAMESPACE_KONG" 2>/dev/null && echo "Kong CP removido" || true
    helm uninstall postgres-kong -n "$NAMESPACE_KONG" 2>/dev/null && echo "PostgreSQL removido" || true

    kubectl delete secret kong-cluster-cert -n "$NAMESPACE_KONG" 2>/dev/null || true
    kubectl delete pvc --all -n "$NAMESPACE_KONG" 2>/dev/null || true
    kubectl delete ns "$NAMESPACE_KONG" 2>/dev/null && echo "Namespace $NAMESPACE_KONG removido" || true

    echo "=== Kong removido com sucesso! ==="
}

uninstall_argocd() {
    echo "=== Removendo ArgoCD do Kubernetes ==="

    helm uninstall argocd -n "$NAMESPACE_ARGOCD" 2>/dev/null && echo "ArgoCD removido" || true

    kubectl delete pvc --all -n "$NAMESPACE_ARGOCD" 2>/dev/null || true
    kubectl delete ns "$NAMESPACE_ARGOCD" 2>/dev/null && echo "Namespace $NAMESPACE_ARGOCD removido" || true

    echo "=== ArgoCD removido com sucesso! ==="
}

uninstall() {
    uninstall_argocd
    uninstall_kong

    echo ""
    echo "=== Todos os serviços removidos com sucesso! ==="
}

if [ -z "${1:-}" ]; then
    echo "=========================================="
    echo "  Kong + ArgoCD - Gerenciador Helm"
    echo "=========================================="
    echo ""
    echo "  Uso: ./start.sh <comando>"
    echo ""
    echo "  Comandos:"
    echo "    install           Instalar tudo (Kong + ArgoCD)"
    echo "    install-kong      Instalar apenas Kong"
    echo "    install-argocd    Instalar apenas ArgoCD"
    echo "    uninstall         Remover tudo (Kong + ArgoCD)"
    echo "    uninstall-kong    Remover apenas Kong"
    echo "    uninstall-argocd  Remover apenas ArgoCD"
    echo "    status            Ver status dos pods"
    echo ""
    echo "=========================================="
    exit 1
fi

status() {
    echo "=== Status dos Pods ==="
    echo ""
    echo "--- Kong (namespace: $NAMESPACE_KONG) ---"
    kubectl get pods -n "$NAMESPACE_KONG" 2>/dev/null || echo "Namespace $NAMESPACE_KONG não encontrado."
    echo ""
    echo "--- ArgoCD (namespace: $NAMESPACE_ARGOCD) ---"
    kubectl get pods -n "$NAMESPACE_ARGOCD" 2>/dev/null || echo "Namespace $NAMESPACE_ARGOCD não encontrado."
    echo ""
}

case "$1" in
    install)            install ;;
    install-kong)       add_helm_repos && install_kong ;;
    install-argocd)     add_helm_repos && install_argocd ;;
    uninstall)          uninstall ;;
    uninstall-kong)     uninstall_kong ;;
    uninstall-argocd)   uninstall_argocd ;;
    status)             status ;;
    *)
        echo "Comando inválido: $1"
        echo "Use: ./start.sh install | uninstall | status"
        exit 1
        ;;
esac
