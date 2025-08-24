#!/usr/bin/env bash
set -euo pipefail

# 50 – Installation des outils de développement IoT/ESP32

echo "=== Installation des outils de développement IoT/ESP32 ==="

echo "--- Installation d'Arduino CLI ---"
if ! command -v arduino-cli &> /dev/null; then
  # Création du dossier bin dans le home
  mkdir -p "$HOME/bin"
  
  # Téléchargement et installation d'Arduino CLI
  cd /tmp
  curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR="$HOME/bin" sh
  
  # Ajout au PATH si pas déjà fait
  if ! grep -q '$HOME/bin' "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
  fi
  
  # Rafraîchir le PATH pour cette session
  export PATH="$HOME/bin:$PATH"
  
  # Vérification de l'installation
  if [ -f "$HOME/bin/arduino-cli" ]; then
    # Configuration initiale
    "$HOME/bin/arduino-cli" config init
    "$HOME/bin/arduino-cli" core update-index
    echo "✅ Arduino CLI installé"
  else
    echo "❌ Erreur installation Arduino CLI"
  fi
else
  echo "✅ Arduino CLI déjà installé"
fi

echo "--- Installation de PlatformIO Core ---"
if ! command -v pio &> /dev/null && [ ! -f "$HOME/.platformio-venv/bin/pio" ]; then
  # Installation via pip avec gestion de l'environnement virtuel
  python3 -m venv ~/.platformio-venv
  source ~/.platformio-venv/bin/activate
  pip install --upgrade pip
  pip install platformio
  
  # Création d'un alias permanent
  if ! grep -q "platformio" "$HOME/.bashrc"; then
    echo 'alias pio="~/.platformio-venv/bin/pio"' >> "$HOME/.bashrc"
    echo 'export PATH="$HOME/.platformio-venv/bin:$PATH"' >> "$HOME/.bashrc"
  fi
  
  echo "✅ PlatformIO installé"
else
  echo "✅ PlatformIO déjà installé"
fi

echo "--- Installation des outils MQTT ---"
sudo apt install -y \
  mosquitto mosquitto-clients

echo "--- Installation des outils réseau et debugging ---"
sudo apt install -y \
  wireshark \
  nmap \
  netcat-openbsd \
  socat \
  tcpdump \
  minicom \
  screen

# Ajout de l'utilisateur au groupe dialout pour accès série
sudo usermod -a -G dialout "$USER"

echo "--- Installation des outils de développement C/C++ ---"
sudo apt install -y \
  gcc-avr avr-libc \
  gcc-arm-none-eabi \
  openocd \
  dfu-util \
  esptool

echo "--- Installation d'outils utilitaires ---"
sudo apt install -y \
  htop btop \
  jq yq \
  httpie \
  tree \
  watch \
  tmux

echo
echo "=== Configuration post-installation ==="

echo "--- Configuration Arduino CLI ---"
if [ -f "$HOME/bin/arduino-cli" ]; then
  # Ajout des URLs pour ESP32/ESP8266
  "$HOME/bin/arduino-cli" config add board_manager.additional_urls https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
  "$HOME/bin/arduino-cli" config add board_manager.additional_urls http://arduino.esp8266.com/stable/package_esp8266com_index.json
  
  # Mise à jour de l'index
  "$HOME/bin/arduino-cli" core update-index
  
  # Installation des cores ESP32 et ESP8266
  "$HOME/bin/arduino-cli" core install esp32:esp32 || echo "⚠️  Erreur installation core ESP32"
  "$HOME/bin/arduino-cli" core install esp8266:esp8266 || echo "⚠️  Erreur installation core ESP8266"
  
  echo "✅ Arduino CLI configuré"
else
  echo "⚠️  Arduino CLI non trouvé"
fi

echo "--- Test des installations ---"
echo "=== Test des outils de développement ==="
echo -n "Arduino CLI : " && ("$HOME/bin/arduino-cli" version 2>/dev/null | head -1 || echo "Non accessible")
echo -n "PlatformIO  : " && (source ~/.platformio-venv/bin/activate 2>/dev/null && pio --version 2>/dev/null || echo "Non accessible") 
echo -n "MQTT        : " && (mosquitto_pub --help >/dev/null 2>&1 && echo "Installé" || echo "Non installé")
echo -n "ESPTool     : " && (esptool.py version 2>/dev/null | head -1 || echo "Non installé")
echo -n "OpenOCD     : " && (openocd --version 2>&1 | head -1 || echo "Non installé")

echo
echo "=== Installation terminée ==="
echo "✅ Arduino CLI installé dans $HOME/bin"
echo "✅ PlatformIO Core dans environnement virtuel"  
echo "✅ MQTT (Mosquitto + clients)"
echo "✅ Outils réseau et debugging"
echo "✅ Toolchains C/C++ (AVR, ARM)"
echo "✅ Utilitaires système"
echo ""
echo "📝 Actions requises :"
echo "   • Redémarrez votre session pour le groupe dialout"
echo "   • Rechargez votre terminal : source ~/.bashrc"
echo "   • Test : ~/bin/arduino-cli board list"
echo "   • Test : ~/.platformio-venv/bin/pio device list"
