#!/usr/bin/env bash
# ===========================================================================
# generate-and-commit.sh
#
# Runs Terraform to generate kong.yaml + kong.yaml.gz, copies the gzip to
# the GitOps deck folder, and optionally commits and pushes so ArgoCD can
# detect the change and sync.
#
# Usage:
#   ./scripts/generate-and-commit.sh [--auto-push]
# ===========================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
OUTPUT_DIR="${PROJECT_DIR}/output"
GITOPS_DECK_DIR="${PROJECT_DIR}/poc/kong/kong-gitops/environments/hml/deck"

cd "${PROJECT_DIR}"

echo "==> Running Terraform init..."
terraform init -input=false

echo "==> Running Terraform apply to generate kong.yaml + kong.yaml.gz..."
terraform apply -auto-approve -input=false

if [ ! -f "${OUTPUT_DIR}/kong.yaml" ]; then
  echo "ERROR: kong.yaml was not generated at ${OUTPUT_DIR}/kong.yaml"
  exit 1
fi

if [ ! -f "${OUTPUT_DIR}/kong.yaml.gz" ]; then
  echo "WARN: kong.yaml.gz not found, generating manually..."
  gzip -9 -k -f "${OUTPUT_DIR}/kong.yaml"
fi

echo "==> Validating generated kong.yaml with deck..."
if command -v deck &> /dev/null; then
  deck validate -s "${OUTPUT_DIR}/kong.yaml"
  echo "    Validation passed."
else
  echo "    WARN: deck CLI not found, skipping validation."
fi

YAML_SIZE=$(wc -c < "${OUTPUT_DIR}/kong.yaml")
GZ_SIZE=$(wc -c < "${OUTPUT_DIR}/kong.yaml.gz")
RATIO=$(( (GZ_SIZE * 100) / YAML_SIZE ))
echo "==> kong.yaml: ${YAML_SIZE} bytes → kong.yaml.gz: ${GZ_SIZE} bytes (${RATIO}% of original)"

echo "==> Copying kong.yaml.gz to GitOps deck folder..."
cp "${OUTPUT_DIR}/kong.yaml.gz" "${GITOPS_DECK_DIR}/kong.yaml.gz"
echo "    Copied to ${GITOPS_DECK_DIR}/kong.yaml.gz"

if [ "${1:-}" = "--auto-push" ]; then
  cd "${PROJECT_DIR}"
  git add output/kong.yaml output/kong.yaml.gz poc/kong/kong-gitops/environments/hml/deck/kong.yaml.gz
  if git diff --cached --quiet; then
    echo "==> No changes detected. Nothing to commit."
  else
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    git commit -m "chore(kong): update kong.yaml.gz declarative config [${TIMESTAMP}]"
    git push
    echo "==> Changes pushed. ArgoCD will detect and sync automatically."
  fi
else
  echo ""
  echo "To commit and push (triggering ArgoCD sync), run:"
  echo "  git add output/kong.yaml.gz poc/kong/kong-gitops/environments/hml/deck/kong.yaml.gz && git commit -m 'update kong config' && git push"
fi
