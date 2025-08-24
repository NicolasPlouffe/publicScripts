#!/usr/bin/env bash
set -euo pipefail

# 25 – Installations manuelles (non disponibles via APT/Flatpak)

echo "=== Installations manuelles ==="

# Dossier temporaire pour les téléchargements
TEMP_DIR="/tmp/manual-installs"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# === VS Code (Microsoft officiel) ===
echo "--- Installation de Visual Studio Code ---"
if ! command -v code &> /dev/null; then
  echo "Ajout du dépôt Microsoft..."
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  
  sudo apt update
  sudo apt install -y code
  echo "✅ VS Code installé via dépôt Microsoft"
else
  echo "✅ VS Code déjà installé"
fi

# === MEGAsync (MEGA officiel) ===
echo "--- Installation de MEGAsync ---"
if ! command -v megasync &> /dev/null; then
  echo "Téléchargement de MEGAsync..."
  wget -O megasync.deb "https://mega.nz/linux/repo/xUbuntu_24.04/amd64/megasync_5.5.0-1.1_amd64.deb"
  sudo dpkg -i megasync.deb || sudo apt-get install -f -y
  echo "✅ MEGAsync installé"
else
  echo "✅ MEGAsync déjà installé"
fi

# === JetBrains Toolbox ===
echo "--- Installation de JetBrains Toolbox ---"
if [ ! -f "$HOME/.local/share/JetBrains/Toolbox/bin/jetbrains-toolbox" ]; then
  echo "Téléchargement de JetBrains Toolbox..."
  TOOLBOX_VERSION=$(curl -s 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' | grep -Po '"version":"\K[^"]*' | head -1)
  wget -O jetbrains-toolbox.tar.gz "https://download.jetbrains.com/toolbox/jetbrains-toolbox-${TOOLBOX_VERSION}.tar.gz"
  
  tar -xzf jetbrains-toolbox.tar.gz
  TOOLBOX_DIR=$(find . -maxdepth 1 -type d -name "jetbrains-toolbox-*" | head -1)
  
  # Installation dans le home de l'utilisateur
  mkdir -p "$HOME/.local/share/JetBrains/Toolbox/bin"
  cp "$TOOLBOX_DIR/jetbrains-toolbox" "$HOME/.local/share/JetBrains/Toolbox/bin/"
  chmod +x "$HOME/.local/share/JetBrains/Toolbox/bin/jetbrains-toolbox"
  
  # Ajout au PATH si pas déjà fait
  if ! grep -q "JetBrains/Toolbox/bin" "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/.local/share/JetBrains/Toolbox/bin:$PATH"' >> "$HOME/.bashrc"
  fi
  
  echo "✅ JetBrains Toolbox installé"
else
  echo "✅ JetBrains Toolbox déjà installé"
fi

# === Alacritty (Terminal GPU-accéléré) ===
echo "--- Installation d'Alacritty ---"
if ! command -v alacritty &> /dev/null; then
  echo "Installation d'Alacritty via Cargo..."
  # Vérifier que Rust est installé
  if ! command -v cargo &> /dev/null; then
    echo "Installation de Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
  fi
  
  # Dépendances pour Alacritty
  sudo apt install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
  
  # Installation via cargo
  cargo install alacritty
  echo "✅ Alacritty installé via Cargo"
else
  echo "✅ Alacritty déjà installé"
fi

# === Docker (script officiel) ===
echo "--- Installation de Docker ---"
if ! command -v docker &> /dev/null; then
  echo "Installation de Docker via script officiel..."
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  
  # Ajout de l'utilisateur au groupe docker
  sudo usermod -aG docker "$USER"
  echo "✅ Docker installé - Redémarrage requis pour utiliser sans sudo"
else
  echo "✅ Docker déjà installé"
fi

# === Timeshift (sauvegarde système) ===
echo "--- Installation de Timeshift ---"
if ! command -v timeshift &> /dev/null; then
  sudo apt install -y timeshift
  echo "✅ Timeshift installé via APT"
else
  echo "✅ Timeshift déjà installé"
fi

# === Oh My Zsh ===
echo "--- Installation d'Oh My Zsh ---"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installation d'Oh My Zsh..."
  RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "✅ Oh My Zsh installé"
else
  echo "✅ Oh My Zsh déjà installé"
fi

# Nettoyage
echo "--- Nettoyage ---"
cd /
rm -rf "$TEMP_DIR"

echo
echo "=== Vérification des installations manuelles ==="
echo -n "VS Code    : " && (code --version | head -1 || echo "Non installé")
echo -n "MEGAsync   : " && (megasync --version 2>/dev/null || echo "Non installé")
echo -n "Toolbox    : " && (ls "$HOME/.local/share/JetBrains/Toolbox/bin/jetbrains-toolbox" &>/dev/null && echo "Installé" || echo "Non installé")
echo -n "Alacritty  : " && (alacritty --version || echo "Non installé")
echo -n "Docker     : " && (docker --version || echo "Non installé")
echo -n "Timeshift  : " && (timeshift --version || echo "Non installé")
echo -n "Oh My Zsh  : " && ([ -d "$HOME/.oh-my-zsh" ] && echo "Installé" || echo "Non installé")

echo
echo "=== Installations manuelles terminées ==="
echo "⚠️  Pour Docker : Redémarrez votre session pour utiliser sans sudo"
echo "⚠️  Pour JetBrains Toolbox : Rechargez votre terminal ou : source ~/.bashrc"
