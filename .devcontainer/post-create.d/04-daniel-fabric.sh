#!/usr/bin/env bash
set -euo pipefail

echo "Installing Daniel Miessler's Fabric (best-effort with fallbacks)..."

_try() {
  echo "+ $*"
  if "$@"; then
    echo "  -> success"
    return 0
  else
    echo "  -> failed"
    return 1
  fi
}

installed=false

if command -v npm >/dev/null 2>&1; then
  if _try npm install -g danielmiessler/fabric; then
    installed=true
  else
    _try npm install -g git+https://github.com/danielmiessler/Fabric.git && installed=true || true
  fi
else
  echo "npm not available; skipping npm-based installs."
fi

if [ "$installed" = false ] && command -v python3 >/dev/null 2>&1; then
  PY=python3
  if _try "$PY" -m pip install --upgrade pip setuptools wheel; then
    if _try "$PY" -m pip install git+https://github.com/danielmiessler/Fabric.git; then
      installed=true
    fi
  fi
fi

if [ "$installed" = false ] && command -v git >/dev/null 2>&1; then
  tmpdir="$(mktemp -d)"
  echo "Cloning Fabric to $tmpdir and attempting local install..."
  if _try git clone --depth 1 https://github.com/danielmiessler/Fabric.git "$tmpdir"; then
    if [ -f "$tmpdir/package.json" ] && command -v npm >/dev/null 2>&1; then
      (
        cd "$tmpdir"
        _try npm ci || _try npm install
        _try npm link || true
      )
      installed=true
    else
      echo "No package.json detected or npm not available; skipping npm local install."
    fi
  fi
  rm -rf "$tmpdir" || true
fi

if [ "$installed" = true ]; then
  echo "Fabric installation attempted and an installer succeeded."
else
  echo "Fabric was not installed by any automated method. Please edit .devcontainer/post-create.d/04-daniel-fabric.sh to add the authoritative installation command."
fi

echo "Done: Fabric step."