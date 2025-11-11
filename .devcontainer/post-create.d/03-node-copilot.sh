#!/usr/bin/env bash
set -euo pipefail

echo "Installing Node/global npm tools (Copilot client)..."

if command -v npm >/dev/null 2>&1; then
  npm install -g @github/copilot || true
else
  echo "npm not found; @github/copilot installation skipped"
fi

echo "Done: Node/npm tools."