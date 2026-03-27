#!/usr/bin/env bash
# ===========================================================================
# generate-and-commit.sh
#
# Runs Terraform to generate kong.yaml, then copies it to the GitOps deck
# folder and optionally commits and pushes so ArgoCD can detect the change.
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

echo "==> Running Terraform apply to generate kong.yaml..."
terraform apply -auto-approve -input=false

if [ ! -f "${OUTPUT_DIR}/kong.yaml" ]; then
  echo "ERROR: kong.yaml was not generated at ${OUTPUT_DIR}/kong.yaml"
  exit 1
fi

echo "==> Validating generated kong.yaml with deck..."
if command -v deck &> /dev/null; then
  deck validate -s "${OUTPUT_DIR}/kong.yaml"
  echo "    Validation passed."
else
  echo "    WARN: deck CLI not found, skipping validation."
fi

echo "==> Copying kong.yaml to GitOps deck folder..."
cp "${OUTPUT_DIR}/kong.yaml" "${GITOPS_DECK_DIR}/kong.yaml"
echo "    Copied to ${GITOPS_DECK_DIR}/kong.yaml"

echo "==> kong.yaml generated at: ${OUTPUT_DIR}/kong.yaml"

if [ "${1:-}" = "--auto-push" ]; then
  cd "${PROJECT_DIR}"
  git add output/kong.yaml poc/kong/kong-gitops/environments/hml/deck/kong.yaml
  if git diff --cached --quiet; then
    echo "==> No changes detected. Nothing to commit."
  else
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    git commit -m "chore(kong): update kong.yaml declarative config [${TIMESTAMP}]"
    git push
    echo "==> Changes pushed. ArgoCD will detect and sync automatically."
  fi
else
  echo ""
  echo "To commit and push (triggering ArgoCD sync), run:"
  echo "  git add output/kong.yaml poc/kong/kong-gitops/environments/hml/deck/kong.yaml && git commit -m 'update kong config' && git push"
fi
