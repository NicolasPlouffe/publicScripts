#!/bin/bash

set -e

# Variables
URL="https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"
INSTALL_BASE="$HOME/.local/share/JetBrains"
INSTALL_DIR="$INSTALL_BASE/Toolbox"
BIN_LINK="$HOME/.local/bin/jetbrains-toolbox"
DESKTOP_FILE="$HOME/.local/share/applications/jetbrains-toolbox.desktop"
ICON_FILE="$INSTALL_DIR/bin/toolbox-tray-color.png"
TEMP_DIR="/tmp/jetbrains-toolbox-download"

# 1. Création des dossiers nécessaires
mkdir -p "$INSTALL_DIR"
mkdir -p "$(dirname "$BIN_LINK")"
mkdir -p "$(dirname "$DESKTOP_FILE")"

# 2. Télécharger l’archive officielle
echo "[INFO] Téléchargement de JetBrains Toolbox..."
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
wget --progress=bar:force:noscroll -O "$TEMP_DIR/jetbrains-toolbox.tar.gz" "$URL"

# 3. Extraction
echo "[INFO] Extraction..."
tar -xzf "$TEMP_DIR/jetbrains-toolbox.tar.gz" -C "$TEMP_DIR"
# Le dossier exact est inconnu d'avance (ex: jetbrains-toolbox-2.8.1.52155)
TBX_EXTRACTED=""
for d in "$TEMP_DIR"/jetbrains-toolbox-*; do
  if [[ -f "$d/bin/jetbrains-toolbox" ]]; then
    TBX_EXTRACTED="$d"
    break
  fi
done

if [[ ! -x "$TBX_EXTRACTED/bin/jetbrains-toolbox" ]]; then
  echo "[ERREUR] Fichier exécutable introuvable après extraction."
  exit 1
fi

# 4. Déplacement dans le dossier utilisateur
echo "[INFO] Installation dans $INSTALL_DIR ..."
rm -rf "$INSTALL_DIR"
mv "$TBX_EXTRACTED" "$INSTALL_DIR"

chmod +x "$INSTALL_DIR/bin/jetbrains-toolbox"

# 5. Lien vers ~/.local/bin
ln -sf "$INSTALL_DIR/bin/jetbrains-toolbox" "$BIN_LINK"

# 6. Icône (toujours disponible dans l’archive officielle)
ICON_DEST="$HOME/.local/share/icons/hicolor/256x256/apps/jetbrains-toolbox.png"
mkdir -p "$(dirname "$ICON_DEST")"
cp "$ICON_FILE" "$ICON_DEST"

# 7. Fichier .desktop (menu GNOME)
cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=JetBrains Toolbox
Comment=Gérer vos IDE JetBrains
Exec=$BIN_LINK
Icon=jetbrains-toolbox
Terminal=false
Categories=Development;IDE;
StartupNotify=true
EOF

chmod +x "$DESKTOP_FILE"

# 8. Rafraîchir la base GNOME
update-desktop-database ~/.local/share/applications 2>/dev/null || true
gtk-update-icon-cache -f -t ~/.local/share/icons/hicolor 2>/dev/null || true

# 9. Nettoyage
rm -rf "$TEMP_DIR"

echo "[SUCCESS] JetBrains Toolbox a été installé !"
echo "• Lancement : jetbrains-toolbox (dans un terminal) ou via le menu GNOME"
echo "• Pour désinstaller : supprime $INSTALL_DIR, $DESKTOP_FILE, $BIN_LINK et l'icône"

