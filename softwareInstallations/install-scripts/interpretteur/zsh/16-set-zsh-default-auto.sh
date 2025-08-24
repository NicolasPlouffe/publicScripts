#!/usr/bin/env bash
set -euo pipefail

# 16-auto – Configuration automatique de Zsh comme shell par défaut

echo "=== Configuration automatique de Zsh comme shell par défaut ==="

if ! command -v zsh &> /dev/null; then
  echo "❌ Zsh non installé"
  exit 1
fi

ZSH_PATH=$(which zsh)

# Ajout à /etc/shells si nécessaire
if ! grep -q "$ZSH_PATH" /etc/shells; then
  echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
fi

# Changement du shell si nécessaire
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
  chsh -s "$ZSH_PATH"
  echo "✅ Shell changé vers zsh"
  echo "📝 Reconnectez-vous pour activer"
else
  echo "✅ Zsh déjà configuré comme shell par défaut"
fi

