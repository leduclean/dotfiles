#!/usr/bin/env bash
# -------------------------------------------------------------------------
# setup.sh — Deploy modules via GNU Stow
# -------------------------------------------------------------------------
set -euo pipefail
# Ensure ~/.config exists
mkdir -p "$HOME/.config"
# Install Stow if missing
if ! command -v stow &> /dev/null; then
  echo "[INFO] Installing GNU Stow..."
  if [[ "$OSTYPE" == linux* ]]; then
    sudo apt-get update -y
    sudo apt-get install -y stow
  elif [[ "$OSTYPE" == darwin* ]]; then
    echo "[INFO] Installing via Homebrew"
    brew install stow
  else
    echo "[ERROR] Unsupported OS for automatic installation"
    exit 1
  fi
fi
echo "[INFO] GNU Stow is available at: $(command -v stow)"
stow .
echo "Stow matching down"
