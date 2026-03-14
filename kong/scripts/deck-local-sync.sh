#!/usr/bin/env bash
# ===========================================================================
# deck-local-sync.sh
#
# Applies the declarative Kong config via decK against a Kong Admin API.
# Uses `deck gateway sync` which computes a diff and applies only the
# changes needed — no downtime, no full reset.
#
# Usage:
#   KONG_ADMIN_URL=http://localhost:8001 ./scripts/deck-local-sync.sh
#   KONG_ADMIN_URL=http://localhost:8001 ./scripts/deck-local-sync.sh --diff-only
# ===========================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
KONG_YML="${PROJECT_DIR}/output/kong.yml"
KONG_ADMIN_URL="${KONG_ADMIN_URL:-http://localhost:8001}"
DIFF_ONLY=false

for arg in "$@"; do
  case "$arg" in
    --diff-only) DIFF_ONLY=true ;;
  esac
done

if [ ! -f "${KONG_YML}" ]; then
  echo "ERROR: kong.yml not found. Run Terraform first:"
  echo "  cd ${PROJECT_DIR} && terraform apply"
  exit 1
fi

# Validate YAML structure offline
echo "==> Validating kong.yml (offline)..."
command deck file validate "${KONG_YML}"
echo "    OK"

if [ "${DIFF_ONLY}" = true ]; then
  echo ""
  echo "==> Dumping current Kong state for comparison..."
  command deck gateway dump --kong-addr "${KONG_ADMIN_URL}" -o /tmp/kong-current.yml 2>/dev/null || true
  echo "    Current state saved to /tmp/kong-current.yml"
  echo "    Compare with: diff /tmp/kong-current.yml ${KONG_YML}"
  exit 0
fi

echo ""
echo "==> This will sync Kong configuration with kong.yml (diff & apply)."
echo "    Target: ${KONG_ADMIN_URL}"
read -rp "    Continue? [y/N] " confirm
if [[ ! "${confirm}" =~ ^[yY]$ ]]; then
  echo "==> Aborted."
  exit 0
fi

echo ""
echo "==> Syncing kong.yml (diff & apply)..."
command deck gateway sync "${KONG_YML}" --kong-addr "${KONG_ADMIN_URL}"
echo ""
echo "==> Done. All services, routes, and plugins applied successfully."
