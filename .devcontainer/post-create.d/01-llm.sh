#!/usr/bin/env bash
set -euo pipefail

echo "Installing 'uv' helper and simonw's 'llm' tool..."

python3 -m pip install --upgrade pip setuptools wheel || true
python3 -m pip install --upgrade uv || true

if command -v uv >/dev/null 2>&1; then
  uv tool install llm || true
else
  echo "uv not found after install; skipping uv tool install for llm"
fi

if command -v llm >/dev/null 2>&1; then
  llm install llm-github-models || true
  llm models default github/gpt-4.1 || true
else
  echo "llm CLI not found; llm plugin installation skipped"
fi

echo "Done: llm-related setup."