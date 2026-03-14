#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CERTS_DIR="$SCRIPT_DIR/../certs"
NAMESPACE_KONG="kong"

echo "=== Instalando Kong Stack via ArgoCD ==="

# 1. Criar namespace
echo "[1/5] Criando namespace kong..."
kubectl create ns "$NAMESPACE_KONG" 2>/dev/null || echo "Namespace $NAMESPACE_KONG já existe"

# 2. Gerar certificados se não existirem
if [ ! -f "$CERTS_DIR/cluster.key" ]; then
    echo "[2/5] Gerando certificados do cluster..."
    mkdir -p "$CERTS_DIR"
    openssl req -new -x509 -nodes -newkey rsa:2048 \
      -keyout "$CERTS_DIR/cluster.key" -out "$CERTS_DIR/cluster.crt" \
      -days 1095 -subj "/CN=kong_clustering"
    chmod 644 "$CERTS_DIR/cluster.key"
else
    echo "[2/5] Certificados já existem, pulando..."
fi

# 3. Criar secret TLS no Kubernetes
if ! kubectl get secret kong-cluster-cert -n "$NAMESPACE_KONG" &>/dev/null; then
    echo "[3/5] Criando secret TLS kong-cluster-cert..."
    kubectl create secret tls kong-cluster-cert -n "$NAMESPACE_KONG" \
      --cert="$CERTS_DIR/cluster.crt" \
      --key="$CERTS_DIR/cluster.key"
else
    echo "[3/5] Secret kong-cluster-cert já existe, pulando..."
fi

# 4. Adicionar Helm repos ao ArgoCD (caso não use o ConfigMap de repos)
echo "[4/5] Aplicando ArgoCD Applications..."

# Aplicar PostgreSQL primeiro
echo "  -> PostgreSQL..."
kubectl apply -f "$SCRIPT_DIR/postgres.yaml"

# Aguardar PostgreSQL ficar Healthy
echo "  Aguardando PostgreSQL ficar Healthy no ArgoCD..."
for i in $(seq 1 60); do
    STATUS=$(kubectl get application postgres-kong -n argocd -o jsonpath='{.status.health.status}' 2>/dev/null || echo "Unknown")
    if [ "$STATUS" = "Healthy" ]; then
        echo "  PostgreSQL está Healthy!"
        break
    fi
    if [ "$i" -eq 60 ]; then
        echo "  AVISO: Timeout aguardando PostgreSQL. Continuando mesmo assim..."
    fi
    sleep 5
done

# Aplicar Kong Control Plane
echo "  -> Kong Control Plane..."
kubectl apply -f "$SCRIPT_DIR/kong-cp.yaml"

# Aguardar Kong CP ficar Healthy
echo "  Aguardando Kong CP ficar Healthy no ArgoCD..."
for i in $(seq 1 60); do
    STATUS=$(kubectl get application kong-cp -n argocd -o jsonpath='{.status.health.status}' 2>/dev/null || echo "Unknown")
    if [ "$STATUS" = "Healthy" ]; then
        echo "  Kong CP está Healthy!"
        break
    fi
    if [ "$i" -eq 60 ]; then
        echo "  AVISO: Timeout aguardando Kong CP. Continuando mesmo assim..."
    fi
    sleep 5
done

# Aplicar Kong Data Plane
echo "  -> Kong Data Plane..."
kubectl apply -f "$SCRIPT_DIR/kong-dp.yaml"

echo ""
echo "[5/5] Todas as Applications foram criadas!"
echo ""
echo "=== Verificar status ==="
echo "  kubectl get applications -n argocd"
echo ""
echo "=== Acessar serviços ==="
echo "  Admin API:   kubectl port-forward -n kong svc/kong-cp-kong-admin 8001:8001"
echo "  Proxy:       kubectl port-forward -n kong svc/kong-dp-kong-proxy 9000:80"
echo "  ArgoCD UI:   kubectl port-forward -n argocd svc/argocd-server 8080:80"
