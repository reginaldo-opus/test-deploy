#!/usr/bin/env bash
# ===========================================================================
# generate-and-commit.sh
#
# Runs Terraform to generate kong.yml, then commits and pushes the result
# so ArgoCD can detect the change and sync.
#
# Usage:
#   ./scripts/generate-and-commit.sh [--auto-push]
# ===========================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
OUTPUT_DIR="${PROJECT_DIR}/output"

cd "${PROJECT_DIR}"

echo "==> Running Terraform init..."
terraform init -input=false

echo "==> Running Terraform apply to generate kong.yml..."
terraform apply -auto-approve -input=false

if [ ! -f "${OUTPUT_DIR}/kong.yml" ]; then
  echo "ERROR: kong.yml was not generated at ${OUTPUT_DIR}/kong.yml"
  exit 1
fi

echo "==> Validating generated kong.yml with deck..."
if command -v deck &> /dev/null; then
  deck validate -s "${OUTPUT_DIR}/kong.yml"
  echo "    Validation passed."
else
  echo "    WARN: deck CLI not found, skipping validation."
fi

echo "==> kong.yml generated at: ${OUTPUT_DIR}/kong.yml"

if [ "${1:-}" = "--auto-push" ]; then
  cd "${PROJECT_DIR}"
  git add output/kong.yml deploy/
  if git diff --cached --quiet; then
    echo "==> No changes detected. Nothing to commit."
  else
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    git commit -m "chore(kong): update kong.yml declarative config [${TIMESTAMP}]"
    git push
    echo "==> Changes pushed. ArgoCD will detect and sync automatically."
  fi
else
  echo ""
  echo "To commit and push (triggering ArgoCD sync), run:"
  echo "  git add output/kong.yml deploy/ && git commit -m 'update kong config' && git push"
fi
