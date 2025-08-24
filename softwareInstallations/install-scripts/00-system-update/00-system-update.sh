#!/usr/bin/env bash
set -euo pipefail

# 00 – Mise à jour du système et installation des prérequis

echo "=== Apt update ==="
sudo apt update

echo "=== Apt full-upgrade ==="
sudo apt full-upgrade -y

echo "=== Installation des prérequis ==="
echo "Les paquets suivants vont être installés ou mis à jour :"
echo "  • software-properties-common"
echo "  • ca-certificates"
echo "  • curl"
echo "  • wget"
echo "  • gnupg"
echo "  • lsb-release"

sudo apt install -y \
  software-properties-common \
  ca-certificates \
  curl \
  wget \
  gnupg \
  lsb-release

echo
echo "=== Vérification des versions installées ==="
echo -n "curl  : " && curl --version | head -n1
echo -n "wget  : " && wget --version | head -n1
echo -n "gnupg : " && gpg --version | head -n1
echo -n "lsb   : " && lsb_release -d | cut -f2-
echo -n "apt   : " && apt --version | head -n1
echo
echo "Prérequis installés et versions vérifiées avec succès."
