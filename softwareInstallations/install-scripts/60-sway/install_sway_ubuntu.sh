#!/bin/bash

# Script d'installation Sway pour Ubuntu 24.04 avec GPU NVIDIA
# Pour un étudiant en informatique - configuration simple et user-friendly

echo "🚀 Installation et configuration de Sway sur Ubuntu 24.04"
echo "📋 Ce script va installer Sway avec support NVIDIA et configuration de base"
echo ""

# Vérification si on est sur Ubuntu 24.04
if ! lsb_release -d | grep -q "Ubuntu 24.04"; then
    echo "⚠️  Ce script est conçu pour Ubuntu 24.04. Continuez à vos risques et périls."
    read -p "Voulez-vous continuer? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Mise à jour du système
echo "📦 Mise à jour du système..."
sudo apt update && sudo apt full-upgrade -y

# Installation de Sway et des composants essentiels
echo "🔧 Installation de Sway et des outils essentiels..."
sudo apt install -y \
    sway \
    swaybg \
    swayidle \
    swaylock \
    waybar \
    wofi \
    foot \
    grimshot \
    wl-clipboard \
    brightnessctl \
    pavucontrol \
    pulseaudio-utils \
    network-manager-gnome \
    gnome-themes-extra \
    fonts-font-awesome \
    mako-notifier \
    grim \
    slurp \
    xdg-desktop-portal-wlr

# Vérification du GPU NVIDIA
echo "🎮 Vérification du GPU NVIDIA..."
if lspci | grep -i nvidia > /dev/null; then
    echo "✅ GPU NVIDIA détecté"

    # Installation des drivers NVIDIA si pas déjà installés
    if ! nvidia-smi &> /dev/null; then
        echo "📦 Installation des drivers NVIDIA..."
        sudo apt install -y nvidia-driver-535 nvidia-settings
        echo "⚠️  Redémarrage nécessaire après l'installation des drivers"
    fi

    # Configuration pour NVIDIA
    echo "⚙️ Configuration pour GPU NVIDIA..."

    # Ajout des modules au kernel
    if ! grep -q "nvidia" /etc/modules-load.d/nvidia.conf 2>/dev/null; then
        echo "nvidia" | sudo tee -a /etc/modules-load.d/nvidia.conf
        echo "nvidia_modeset" | sudo tee -a /etc/modules-load.d/nvidia.conf
        echo "nvidia_uvm" | sudo tee -a /etc/modules-load.d/nvidia.conf
        echo "nvidia_drm" | sudo tee -a /etc/modules-load.d/nvidia.conf
    fi

    # Configuration des paramètres du kernel
    if ! grep -q "nvidia-drm.modeset=1" /etc/default/grub; then
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/&nvidia-drm.modeset=1 /' /etc/default/grub
        sudo update-grub
    fi

    # Création du script de lancement Sway pour NVIDIA
    sudo tee /usr/local/bin/sway-nvidia > /dev/null << 'EOF'
#!/bin/bash
export WLR_NO_HARDWARE_CURSORS=1
export WLR_RENDERER_ALLOW_SOFTWARE=1
export LIBVA_DRIVER_NAME=nvidia
export XDG_SESSION_TYPE=wayland
export GBM_BACKEND=nvidia-drm
export __GLX_VENDOR_LIBRARY_NAME=nvidia
exec sway --unsupported-gpu "$@"
EOF
    sudo chmod +x /usr/local/bin/sway-nvidia

    # Création du fichier de session pour GDM
    sudo tee /usr/share/wayland-sessions/sway-nvidia.desktop > /dev/null << 'EOF'
[Desktop Entry]
Name=Sway (NVIDIA)
Comment=An i3-compatible Wayland compositor with NVIDIA support
Exec=/usr/local/bin/sway-nvidia
Type=Application
EOF

else
    echo "ℹ️  Pas de GPU NVIDIA détecté, configuration standard"
fi

# Création des dossiers de configuration
echo "📁 Création des dossiers de configuration..."
mkdir -p ~/.config/{sway,waybar,wofi,mako}

# Sauvegarde des configurations existantes
echo "💾 Sauvegarde des configurations existantes..."
[ -f ~/.config/sway/config ] && cp ~/.config/sway/config ~/.config/sway/config.bak.$(date +%Y%m%d)
[ -f ~/.config/waybar/config ] && cp ~/.config/waybar/config ~/.config/waybar/config.bak.$(date +%Y%m%d)

# Copie de la configuration par défaut de Sway
if [ ! -f ~/.config/sway/config.bak.$(date +%Y%m%d) ]; then
    cp /etc/sway/config ~/.config/sway/config
fi

# Configuration de base pour les notifications
tee ~/.config/mako/config > /dev/null << 'EOF'
sort=-time
layer=overlay
background-color=#2f343f
width=350
height=100
border-size=2
border-color=#5e81ac
border-radius=15
icons=1
max-icon-size=64
default-timeout=5000
ignore-timeout=1
font=monospace 11

[urgency=low]
border-color=#cccccc

[urgency=normal]
border-color=#d08770

[urgency=high]
border-color=#bf616a
default-timeout=0
EOF

# Configuration de Wofi (menu d'applications)
tee ~/.config/wofi/config > /dev/null << 'EOF'
width=600
height=400
location=center
show=drun
prompt=Applications
filter_rate=100
allow_markup=true
no_actions=true
halign=fill
orientation=vertical
content_halign=fill
insensitive=true
allow_images=true
image_size=40
EOF

echo "✅ Installation terminée!"
echo ""
echo "📝 Prochaines étapes:"
echo "1. Redémarrez votre système: sudo reboot"
if lspci | grep -i nvidia > /dev/null; then
    echo "2. À la connexion, sélectionnez 'Sway (NVIDIA)' dans le menu des sessions"
else
    echo "2. À la connexion, sélectionnez 'Sway' dans le menu des sessions"
fi
echo "3. Utilisez Super+Return pour ouvrir un terminal"
echo "4. Utilisez Super+D pour ouvrir le menu d'applications"
echo "5. Utilisez Super+Shift+C pour recharger la configuration"
echo ""
echo "🎓 Raccourcis essentiels pour débuter:"
echo "   Super = Touche Windows"
echo "   Super+Return = Terminal"
echo "   Super+D = Menu d'applications"
echo "   Super+Shift+Q = Fermer la fenêtre"
echo "   Super+1,2,3... = Changer d'espace de travail"
echo "   Super+Shift+E = Quitter Sway"
echo ""
echo "📚 Pour plus d'aide: man sway"
