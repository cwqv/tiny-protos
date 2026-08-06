#!/usr/bin/env bash
# Check proto breaking changes against main branch.
# Usage: ./scripts/check-breaking.sh [ref]
#   ref defaults to ".git#branch=main"
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROTO_DIR="$SCRIPT_DIR/../protos"
REF="${1:-.git#branch=main}"

if ! command -v buf &>/dev/null; then
  echo "❌ buf is not installed. See https://buf.build/docs/installation"
  exit 1
fi

echo "🔍 Checking breaking changes against $REF ..."
cd "$PROTO_DIR"

if buf breaking --against "$REF"; then
  echo "✅ No breaking changes detected."
else
  echo "❌ Breaking changes detected! Review the output above."
  exit 1
fi
