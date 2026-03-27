#!/usr/bin/env bash
# ===========================================================================
# generate-and-commit.sh — Pipeline de Geração e Deploy da Config Kong
#
# Fluxo completo CI/CD:
#   1. terraform init + apply  → Gera output/kong.yaml + kong.yaml.gz
#   2. deck file validate      → Valida estrutura offline
#   3. Stats de compressão     → Mostra tamanho YAML vs GZ
#   4. Copia kong.yaml.gz      → Diretório GitOps do ArgoCD
#   5. (Opcional) commit + push → Dispara sync no ArgoCD
#
# Uso:
#   ./scripts/generate-and-commit.sh              # Gerar apenas
#   ./scripts/generate-and-commit.sh --auto-push  # Gerar + commit + push
#   ./scripts/generate-and-commit.sh --dry-run    # Terraform plan apenas
#
# Pré-requisitos: terraform >= 1.3, deck CLI (opcional), git (se --auto-push)
# ===========================================================================
set -euo pipefail

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info()  { echo -e "${BLUE}==>${NC} $*"; }
log_ok()    { echo -e "${GREEN}==>${NC} $*"; }
log_warn()  { echo -e "${YELLOW}==>${NC} $*"; }
log_error() { echo -e "${RED}==>${NC} $*" >&2; }

# Resolve caminhos relativos ao diretório do script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
OUTPUT_DIR="${PROJECT_DIR}/output"
GITOPS_DECK_DIR="${PROJECT_DIR}/poc/kong/kong-gitops/environments/hml/deck"

DRY_RUN=false
AUTO_PUSH=false

# Parse argumentos
for arg in "$@"; do
  case "$arg" in
    --auto-push) AUTO_PUSH=true ;;
    --dry-run)   DRY_RUN=true ;;
    --help|-h)
      echo "Uso: $0 [--auto-push] [--dry-run]"
      echo "  --auto-push  Gerar, commitar e fazer push (dispara ArgoCD)"
      echo "  --dry-run    Apenas terraform plan (sem aplicar)"
      exit 0
      ;;
  esac
done

cd "${PROJECT_DIR}"

# --- Passo 1: Terraform init + apply ---
log_info "Terraform init..."
terraform init -input=false -no-color

if [ "${DRY_RUN}" = true ]; then
  log_info "Terraform plan (dry-run)..."
  terraform plan -input=false
  log_ok "Dry-run concluído. Nenhuma mudança aplicada."
  exit 0
fi

log_info "Terraform apply → kong.yaml + kong.yaml.gz..."
SECONDS=0
terraform apply -auto-approve -input=false -no-color
log_ok "Terraform apply concluído em ${SECONDS}s"

# Verifica se YAML foi gerado
if [ ! -f "${OUTPUT_DIR}/kong.yaml" ]; then
  log_error "kong.yaml não foi gerado em ${OUTPUT_DIR}/kong.yaml"
  exit 1
fi

# Fallback: gera .gz manualmente se Terraform não gerou
if [ ! -f "${OUTPUT_DIR}/kong.yaml.gz" ]; then
  log_warn "kong.yaml.gz não encontrado, gerando manualmente..."
  gzip -9 -k -f "${OUTPUT_DIR}/kong.yaml"
fi

# --- Passo 2: Validação offline com deck ---
log_info "Validando kong.yaml..."
if command -v deck &> /dev/null; then
  if deck file validate -s "${OUTPUT_DIR}/kong.yaml"; then
    log_ok "Validação deck OK"
  else
    log_error "Validação deck FALHOU. Corrija antes de continuar."
    exit 1
  fi
else
  log_warn "deck CLI não encontrado — pulando validação."
fi

# --- Passo 3: Stats de compressão ---
YAML_SIZE=$(wc -c < "${OUTPUT_DIR}/kong.yaml")
GZ_SIZE=$(wc -c < "${OUTPUT_DIR}/kong.yaml.gz")
if [ "${YAML_SIZE}" -gt 0 ]; then
  RATIO=$(( (GZ_SIZE * 100) / YAML_SIZE ))
else
  RATIO=0
fi
YAML_HR=$(numfmt --to=iec "${YAML_SIZE}" 2>/dev/null || echo "${YAML_SIZE}B")
GZ_HR=$(numfmt --to=iec "${GZ_SIZE}" 2>/dev/null || echo "${GZ_SIZE}B")
log_info "kong.yaml: ${YAML_HR} → kong.yaml.gz: ${GZ_HR} (${RATIO}% do original)"

# --- Passo 4: Copiar .gz para diretório GitOps ---
log_info "Copiando kong.yaml.gz para GitOps deck/..."
mkdir -p "${GITOPS_DECK_DIR}"
cp "${OUTPUT_DIR}/kong.yaml.gz" "${GITOPS_DECK_DIR}/kong.yaml.gz"
log_ok "Copiado para ${GITOPS_DECK_DIR}/kong.yaml.gz"

# --- Passo 5: (Opcional) Commit e push ---
if [ "${AUTO_PUSH}" = true ]; then
  cd "${PROJECT_DIR}"
  # Adiciona apenas os artefatos comprimidos (não o YAML grande)
  git add output/kong.yaml.gz poc/kong/kong-gitops/environments/hml/deck/kong.yaml.gz

  if git diff --cached --quiet; then
    log_ok "Sem mudanças detectadas. Nada para commitar."
  else
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    git commit -m "chore(kong): update kong.yaml.gz declarative config [${TIMESTAMP}]"
    git push
    log_ok "Push realizado. ArgoCD irá detectar e sincronizar automaticamente."
  fi
else
  echo ""
  log_info "Para disparar o ArgoCD, execute:"
  echo "  $0 --auto-push"
fi
