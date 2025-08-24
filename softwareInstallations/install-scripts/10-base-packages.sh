#!/usr/bin/env bash
set -euo pipefail

# 10 – Installation des paquets de base

echo "=== Activation du dépôt universe ==="
sudo add-apt-repository -y universe

echo "=== Mise à jour des listes de paquets ==="
sudo apt update

echo "=== Installation des paquets de base via apt ==="
sudo apt install -y \
  python3 python3-pip \
  nodejs \
  openssh-client openssh-server \
  lsd tree \
  zsh bash-completion \
  fd-find \
  ripgrep \
  git curl wget

echo
echo "=== Vérification des versions installées ==="
echo -n "python3 : " && python3 --version
echo -n "pip3    : " && pip3 --version
echo -n "node    : " && node --version
echo -n "npm     : " && npm --version
echo -n "ssh     : " && ssh -V 2>&1
echo -n "lsd     : " && lsd --version
echo -n "tree    : " && tree --version
echo -n "zsh     : " && zsh --version
echo -n "fd      : " && fdfind --version
echo -n "rg      : " && rg --version
echo -n "git     : " && git --version
echo
echo "Paquets de base installés et versions vérifiées avec succès."

