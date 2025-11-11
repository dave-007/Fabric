#!/usr/bin/env bash
set -euo pipefail

echo "Installing/configuring GitHub CLI extensions..."

if command -v gh >/dev/null 2>&1; then
  gh extension install github/copilot-cli || true
else
  echo "gh CLI not found; GitHub CLI extension installation skipped"
fi

echo "Done: GitHub CLI steps."