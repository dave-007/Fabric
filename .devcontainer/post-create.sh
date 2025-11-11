#!/usr/bin/env bash
set -euo pipefail

echo "Running post-create step scripts from .devcontainer/post-create.d ..."

if [ ! -d ".devcontainer/post-create.d" ]; then
  echo "No .devcontainer/post-create.d directory found; skipping post-create steps."
  exit 0
fi

for script in .devcontainer/post-create.d/*.sh; do
  [ -e "$script" ] || continue
  echo
  echo "------------------------------------------------------------"
  echo "Running $(basename "$script")"
  echo "------------------------------------------------------------"
  bash "$script" || {
    echo "Script $script exited with non-zero status; continuing with next script."
  }
done

echo
echo "All post-create scripts finished."