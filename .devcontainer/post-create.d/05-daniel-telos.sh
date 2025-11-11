#!/usr/bin/env bash
set -euo pipefail

echo "Installing Daniel Miessler's Telos (best-effort with fallbacks)..."

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
  if _try npm install -g danielmiessler/telos; then
    installed=true
  else
    _try npm install -g git+https://github.com/danielmiessler/Telos.git && installed=true || true
  fi
else
  echo "npm not available; skipping npm-based installs."
fi

if [ "$installed" = false ] && command -v python3 >/dev/null 2>&1; then
  PY=python3
  if _try "$PY" -m pip install --upgrade pip setuptools wheel; then
    if _try "$PY" -m pip install git+https://github.com/danielmiessler/Telos.git; then
      installed=true
    fi
  fi
fi

if [ "$installed" = false ] && command -v git >/dev/null 2>&1; then
  tmpdir="$(mktemp -d)"
  echo "Cloning Telos to $tmpdir and attempting local install..."
  if _try git clone --depth 1 https://github.com/danielmiessler/Telos.git "$tmpdir"; then
    if [ -f "$tmpdir/package.json" ] && command -v npm >/dev/null 2>&1; then
      (
        cd "$tmpdir"
        _try npm ci || _try npm install
        _try npm link || true
      )
      installed=true
    elif [ -f "$tmpdir/setup.py" ] || [ -f "$tmpdir/pyproject.toml" ]; then
      (
        cd "$tmpdir"
        _try python3 -m pip install . || true
      )
      installed=true
    else
      echo "No obvious installer file detected; please inspect $tmpdir to determine the correct installation method."
    fi
  fi
  rm -rf "$tmpdir" || true
fi

if [ "$installed" = true ]; then
  echo "Telos installation attempted and an installer succeeded."
else
  echo "Telos was not installed by any automated method. Please edit .devcontainer/post-create.d/05-daniel-telos.sh to add the authoritative installation command."i

echo "Done: Telos step."