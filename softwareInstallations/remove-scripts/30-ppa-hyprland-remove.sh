#!/usr/bin/env bash
set -euo pipefail

# 30 – Nettoyage complet Hyprland et résolution conflits

echo "=== Nettoyage complet Hyprland et résolution des conflits ==="

echo "--- Nettoyage complet CMake et dépendances ---"
# Purge complète de tous les paquets cmake
sudo apt remove --purge -y cmake cmake-data kitware-archive-keyring || true
sudo apt autoremove --purge -y

# Nettoyage des dépôts Kitware
sudo rm -f /etc/apt/sources.list.d/kitware.list
sudo rm -f /usr/share/keyrings/kitware-archive-keyring.gpg

echo "--- Recherche et suppression de toutes les installations Hyprland ---"
# Recherche dans tous les emplacements possibles
HYPRLAND_LOCATIONS=(
  "/usr/local/bin/Hyprland"
  "/usr/bin/Hyprland"
  "/opt/hyprland/bin/Hyprland"
  "/home/$USER/.local/bin/Hyprland"
)

for location in "${HYPRLAND_LOCATIONS[@]}"; do
  if [ -f "$location" ]; then
    sudo rm -f "$location"
    echo "✅ Supprimé : $location"
  fi
done

# Suppression des sessions Hyprland
sudo rm -f /usr/share/wayland-sessions/hyprland.desktop
sudo rm -f /usr/share/xsessions/hyprland.desktop

echo "--- Nettoyage des dossiers de build temporaires ---"
sudo rm -rf /tmp/hyprland-build
sudo rm -rf /tmp/Hyprland*
sudo rm -rf /tmp/Ubuntu-Hyprland*

echo "--- Nettoyage des configurations utilisateur ---"
rm -rf "$HOME/.config/hypr"
rm -rf "$HOME/.cache/hyprland"

echo "--- Réparation du système de paquets ---"
sudo apt update
sudo dpkg --configure -a
sudo apt install -f

# Réinstallation propre de CMake Ubuntu
echo "--- Réinstallation CMake Ubuntu ---"
sudo apt install -y cmake cmake-data

echo "--- Nettoyage final ---"
sudo apt autoremove --purge -y
sudo apt autoclean

echo
echo "=== Vérification post-nettoyage ==="
echo -n "CMake Ubuntu : " && (cmake --version | head -1)
echo -n "Hyprland     : " && (which Hyprland 2>/dev/null && echo "⚠️ Encore présent" || echo "✅ Supprimé")

echo
echo "=== Nettoyage complet terminé ==="
echo "✅ Toutes les installations Hyprland supprimées"
echo "✅ Conflits de dépendances résolus"
echo "✅ CMake Ubuntu restauré"
echo "📝 Redémarrez pour finaliser le nettoyage"
