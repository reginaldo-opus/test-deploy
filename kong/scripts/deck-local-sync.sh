#!/usr/bin/env bash
# ===========================================================================
# deck-local-sync.sh — Sync Local via decK (sem Kubernetes/ArgoCD)
#
# Aplica configuração declarativa do Kong na Admin API usando decK.
# Útil para:
#   - Testes locais (Kong via Docker Compose ou port-forward)
#   - Debug de configuração antes de push para GitOps
#   - Comparar estado atual vs desejado (--diff-only)
#
# O deck computa um DIFF e aplica apenas mudanças — sem downtime.
#
# Uso:
#   ./scripts/deck-local-sync.sh                      # Sync interativo
#   ./scripts/deck-local-sync.sh --diff-only           # Apenas mostra diff
#   ./scripts/deck-local-sync.sh --yes                 # Sync sem confirmação
#   KONG_ADMIN_URL=http://host:8001 ./scripts/deck-local-sync.sh
#
# Variáveis de ambiente:
#   KONG_ADMIN_URL  — URL da Kong Admin API (default: http://localhost:8001)
# ===========================================================================
set -euo pipefail

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log_info()  { echo -e "${BLUE}==>${NC} $*"; }
log_ok()    { echo -e "${GREEN}==>${NC} $*"; }
log_warn()  { echo -e "${YELLOW}==>${NC} $*"; }
log_error() { echo -e "${RED}==>${NC} $*" >&2; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
KONG_YAML="${PROJECT_DIR}/output/kong.yaml"
KONG_ADMIN_URL="${KONG_ADMIN_URL:-http://localhost:8001}"
DIFF_ONLY=false
AUTO_YES=false

# Parse argumentos
for arg in "$@"; do
  case "$arg" in
    --diff-only) DIFF_ONLY=true ;;
    --yes|-y)    AUTO_YES=true ;;
    --help|-h)
      echo "Uso: $0 [--diff-only] [--yes]"
      echo "  --diff-only  Mostra diff sem aplicar"
      echo "  --yes        Aplica sem confirmação"
      exit 0
      ;;
  esac
done

# Verifica dependência
if ! command -v deck &>/dev/null; then
  log_error "deck CLI não encontrado. Instale: https://docs.konghq.com/deck/latest/installation/"
  exit 1
fi

# Verifica se kong.yaml existe
if [ ! -f "${KONG_YAML}" ]; then
  log_error "kong.yaml não encontrado. Execute Terraform primeiro:"
  echo "  cd ${PROJECT_DIR} && terraform apply"
  exit 1
fi

# --- Passo 1: Validação offline ---
log_info "Validando kong.yaml (offline)..."
deck file validate -s "${KONG_YAML}"
log_ok "Validação OK"

# --- Passo 2: Verifica conectividade com Kong ---
log_info "Testando conexão com Kong Admin API: ${KONG_ADMIN_URL}..."
if ! deck gateway ping --kong-addr "${KONG_ADMIN_URL}" 2>/dev/null; then
  # Fallback: testa com curl/wget
  if command -v curl &>/dev/null; then
    curl -sf "${KONG_ADMIN_URL}/status" >/dev/null 2>&1 || {
      log_error "Kong Admin API não acessível em ${KONG_ADMIN_URL}"
      exit 1
    }
  fi
fi
log_ok "Kong Admin API acessível"

# --- Modo diff-only: mostra diferenças sem aplicar ---
if [ "${DIFF_ONLY}" = true ]; then
  echo ""
  log_info "Calculando diff entre estado atual e kong.yaml..."
  deck gateway diff "${KONG_YAML}" --kong-addr "${KONG_ADMIN_URL}" || true
  exit 0
fi

# --- Modo sync: aplica configuração ---
echo ""
log_info "Target: ${KONG_ADMIN_URL}"

# Mostra diff antes de aplicar
log_info "Diff preview:"
deck gateway diff "${KONG_YAML}" --kong-addr "${KONG_ADMIN_URL}" || true

if [ "${AUTO_YES}" != true ]; then
  echo ""
  read -rp "Aplicar mudanças? [y/N] " confirm
  if [[ ! "${confirm}" =~ ^[yY]$ ]]; then
    log_warn "Abortado pelo usuário."
    exit 0
  fi
fi

echo ""
SECONDS=0
log_info "Executando deck gateway sync..."
deck gateway sync "${KONG_YAML}" --kong-addr "${KONG_ADMIN_URL}" --parallelism 50
log_ok "Sync concluído em ${SECONDS}s — services, routes e plugins aplicados."
