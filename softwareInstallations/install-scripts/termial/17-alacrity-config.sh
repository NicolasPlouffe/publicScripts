#!/usr/bin/env bash
set -euo pipefail

# 17 – Configuration d'Alacritty comme terminal par défaut

echo "=== Configuration d'Alacritty avec votre config personnalisée ==="

# Vérification si Alacritty est installé
if ! command -v alacritty &> /dev/null; then
    echo "--- Installation d'Alacritty ---"
    
    # Vérification que Rust/Cargo est disponible (installé dans 25-manual-installs.sh)
    if ! command -v cargo &> /dev/null; then
        echo "❌ Cargo non trouvé. Lancez d'abord 25-manual-installs.sh"
        exit 1
    fi
    
    echo "Alacritty sera installé via Cargo (déjà fait dans 25-manual-installs.sh)"
else
    echo "✅ Alacritty déjà installé : $(alacritty --version)"
fi

echo "--- Création de la configuration Alacritty ---"

# Création du dossier de configuration
mkdir -p ~/.config/alacritty

# Sauvegarde de l'ancienne config si elle existe
if [ -f ~/.config/alacritty/alacritty.toml ]; then
    echo "--- Sauvegarde de l'ancienne configuration ---"
    cp ~/.config/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml.backup.$(date +%Y%m%d_%H%M%S)
    echo "✅ Sauvegarde créée"
fi

# Création du fichier de configuration
cat > ~/.config/alacritty/alacritty.toml << 'EOF'
# Configuration simple et efficace Alacritty pour Ubuntu 24.04

# IPC pour fenêtres multiples
ipc_socket = true

[window]
# Transparence
opacity = 0.95
# Padding autour du terminal
padding.x = 10
padding.y = 10

[font]
# Police (corrigé: "monospace" au lieu de "monspace")
normal.family = "monospace"
normal.style = "Regular"
# Taille de police unique
size = 12.0
# Ajustement de l'espacement
offset.x = 0
offset.y = 0
# Ajustement de la position des glyphes
glyph_offset.x = 0
glyph_offset.y = 0

[colors.primary]
# Couleurs sombres
background = "#1e1e1e"
foreground = "#d4d4d4"

[colors.normal]
black = "#000000"
red = "#ff5555"
green = "#50fa7b"
yellow = "#f1fa8c"
blue = "#bd93f9"
magenta = "#ff79c6"
cyan = "#8be9fd"
white = "#bfbfbf"

[scrolling]
# Historique de défilement
history = 10000

[[keyboard.bindings]]
key = "V"
mods = "Control|Shift"
action = "Paste"

[[keyboard.bindings]]
key = "C"
mods = "Control|Shift"
action = "Copy"

[[keyboard.bindings]]
key = "F"
mods = "Control|Shift"
action = "SearchForward"

[[keyboard.bindings]]
key = "N"
mods = "Control|Shift"
action = "CreateNewWindow"

[debug]
log_level = "Off"
persistent_logging = false
EOF

echo "✅ Configuration Alacritty créée"

echo "--- Définition d'Alacritty comme terminal par défaut ---"

# Création du fichier .desktop si nécessaire
ALACRITTY_DESKTOP="/usr/share/applications/Alacritty.desktop"
if [ ! -f "$ALACRITTY_DESKTOP" ]; then
    echo "--- Création du fichier .desktop ---"
    sudo tee "$ALACRITTY_DESKTOP" > /dev/null << 'EOF'
[Desktop Entry]
Type=Application
TryExec=alacritty
Exec=alacritty
Icon=Alacritty
Terminal=false
Categories=System;TerminalEmulator;
Name=Alacritty
GenericName=Terminal
Comment=A cross-platform, GPU-accelerated terminal emulator
StartupWMClass=Alacritty
Actions=New;

[Desktop Entry Action New]
Name=New Terminal
Exec=alacritty
EOF
    echo "✅ Fichier .desktop créé"
fi

# Configuration comme terminal par défaut via gsettings (GNOME)
if command -v gsettings &> /dev/null; then
    echo "--- Configuration GNOME ---"
    gsettings set org.gnome.desktop.default-applications.terminal exec 'alacritty'
    gsettings set org.gnome.desktop.default-applications.terminal exec-arg ''
    echo "✅ Alacritty défini comme terminal par défaut dans GNOME"
fi

# Configuration via update-alternatives
echo "--- Configuration système via update-alternatives ---"
if command -v update-alternatives &> /dev/null; then
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $(which alacritty) 50
    sudo update-alternatives --set x-terminal-emulator $(which alacritty)
    echo "✅ Alacritty défini comme terminal système par défaut"
fi

# Création d'un raccourci clavier suggéré
echo "--- Création d'un script de lancement ---"
mkdir -p ~/bin
cat > ~/bin/terminal << 'EOF'
#!/bin/bash
exec alacritty "$@"
EOF
chmod +x ~/bin/terminal

echo "--- Test de la configuration ---"
if alacritty --print-events >/dev/null 2>&1 &
ALACRITTY_PID=$!
sleep 2
kill $ALACRITTY_PID 2>/dev/null
then
    echo "✅ Test Alacritty réussi"
else
    echo "⚠️  Test Alacritty : vérifiez la configuration"
fi

echo
echo "=== Configuration Alacritty terminée ==="
echo "✅ Configuration personnalisée appliquée"
echo "✅ Terminal par défaut configuré"
echo "✅ Raccourcis clavier configurés :"
echo "   • Ctrl+Shift+C : Copier"
echo "   • Ctrl+Shift+V : Coller"
echo "   • Ctrl+Shift+F : Recherche"
echo "   • Ctrl+Shift+N : Nouvelle fenêtre"
echo ""
echo "🎨 Thème : Couleurs sombres avec transparence 95%"
echo "🔤 Police : Monospace 12pt"
echo "📜 Historique : 10 000 lignes"
echo ""
echo "📝 Actions requises :"
echo "   • Redémarrez votre session pour activer"
echo "   • Test : alacritty"
echo "   • Raccourci clavier : ~/bin/terminal"
echo ""
echo "⚙️  Configuration stockée dans : ~/.config/alacritty/alacritty.toml"
