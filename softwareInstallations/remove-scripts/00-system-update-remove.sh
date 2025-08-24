#!/usr/bin/env bash
set -euo pipefail

# 00 – Nettoyage système interactif

read -p "Exécuter un apt autoremove et purge des paquets orphelins ? [y/N] " ans
if [[ "$ans" =~ ^[Yy]$ ]]; then
  echo "=== Apt autoremove & purge ==="
  sudo apt autoremove --purge -y
fi
