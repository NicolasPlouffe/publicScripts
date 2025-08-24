#!/bin/bash

# Script d'installation automatique JetBrains Toolbox pour Ubuntu 24.04
# Inclut: téléchargement, installation, intégration GNOME, icône
# Auteur: Générateur automatique
# Date: $(date)

set -e  # Arrêter le script en cas d'erreur

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Fonction pour afficher des messages colorés
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}$1${NC}"
}

print_cyan() {
    echo -e "${CYAN}$1${NC}"
}

print_header "
╔══════════════════════════════════════════════════════════════════════╗
║                    INSTALLATION JETBRAINS TOOLBOX                   ║
║                        UBUNTU 24.04 + GNOME                         ║
╚══════════════════════════════════════════════════════════════════════╝
"

print_cyan "🚀 Ce script va installer JetBrains Toolbox avec intégration complète:"
print_cyan "   • Téléchargement automatique de la dernière version"
print_cyan "   • Installation des dépendances requises"
print_cyan "   • Configuration de l'intégration GNOME"
print_cyan "   • Création d'un raccourci avec icône"
print_cyan "   • Lancement automatique"
echo ""

# Variables
TOOLBOX_URL="https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"
TEMP_DIR="/tmp/jetbrains-toolbox-install"
INSTALL_DIR="$HOME/.local/share/JetBrains/Toolbox"
DESKTOP_FILE="$HOME/.local/share/applications/jetbrains-toolbox.desktop"
ICON_DIR="$HOME/.local/share/icons/hicolor/scalable/apps"

# Vérifier les permissions et prérequis
print_info "Vérification des prérequis..."

# Vérifier si on est sur Ubuntu/Debian
if ! command -v apt &> /dev/null; then
    print_error "Ce script est conçu pour Ubuntu/Debian avec apt"
    exit 1
fi

# Vérifier la connexion internet
if ! ping -c 1 google.com &> /dev/null; then
    print_error "Connexion internet requise pour télécharger Toolbox"
    exit 1
fi

print_success "Prérequis validés"

# Mettre à jour les packages système
print_info "Mise à jour des packages système..."
sudo apt update -y

# Installer les dépendances requises
print_info "Installation des dépendances JetBrains Toolbox..."
sudo apt install -y \
    libfuse2 \
    libxi6 \
    libxrender1 \
    libxtst6 \
    mesa-utils \
    libfontconfig \
    libgtk-3-bin \
    tar \
    dbus-user-session \
    wget \
    curl \
    unzip

print_success "Dépendances installées"

# Vérifier si Toolbox est déjà installé
if [[ -f "$INSTALL_DIR/bin/jetbrains-toolbox" ]]; then
    print_warning "JetBrains Toolbox est déjà installé dans $INSTALL_DIR"
    read -p "Voulez-vous le réinstaller ? [y/N]: " reinstall
    if [[ ! "$reinstall" =~ ^[Yy]$ ]]; then
        print_info "Installation annulée"
        exit 0
    fi

    print_info "Suppression de l'ancienne installation..."
    rm -rf "$INSTALL_DIR"
    rm -f "$DESKTOP_FILE"
fi

# Créer le répertoire temporaire
print_info "Création du répertoire temporaire..."
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Télécharger JetBrains Toolbox
print_info "Téléchargement de JetBrains Toolbox..."
print_info "URL: $TOOLBOX_URL"

if wget -O jetbrains-toolbox.tar.gz "$TOOLBOX_URL"; then
    print_success "Téléchargement réussi"
else
    print_error "Échec du téléchargement"
    print_info "Tentative avec URL alternative..."

    # URL alternative si la première échoue
    ALT_URL="https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.4.2.32922.tar.gz"
    if wget -O jetbrains-toolbox.tar.gz "$ALT_URL"; then
        print_success "Téléchargement réussi (URL alternative)"
    else
        print_error "Échec du téléchargement avec toutes les URLs"
        exit 1
    fi
fi

# Extraire l'archive
print_info "Extraction de l'archive..."
tar -xzf jetbrains-toolbox.tar.gz --strip-components=1

# Vérifier que l'exécutable existe
if [[ ! -f "jetbrains-toolbox" ]]; then
    print_error "Fichier exécutable jetbrains-toolbox non trouvé après extraction"
    ls -la
    exit 1
fi

print_success "Archive extraite avec succès"

# Créer le répertoire d'installation
print_info "Création du répertoire d'installation..."
mkdir -p "$INSTALL_DIR/bin"
mkdir -p "$ICON_DIR"
mkdir -p "$(dirname "$DESKTOP_FILE")"

# Copier l'exécutable
print_info "Installation de JetBrains Toolbox..."
cp jetbrains-toolbox "$INSTALL_DIR/bin/"
chmod +x "$INSTALL_DIR/bin/jetbrains-toolbox"

print_success "JetBrains Toolbox installé dans $INSTALL_DIR/bin/"

# Télécharger l'icône officielle
print_info "Téléchargement de l'icône JetBrains Toolbox..."
ICON_URL="https://resources.jetbrains.com/storage/products/toolbox/img/meta/toolbox_logo_300x300.png"

if wget -O "$ICON_DIR/jetbrains-toolbox.png" "$ICON_URL"; then
    print_success "Icône téléchargée"
else
    print_warning "Échec du téléchargement de l'icône, création d'une icône par défaut..."

    # Créer une icône SVG simple si le téléchargement échoue
    cat > "$ICON_DIR/jetbrains-toolbox.svg" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<svg width="64" height="64" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg">
  <rect width="64" height="64" rx="8" fill="#000000"/>
  <rect x="8" y="8" width="48" height="48" rx="4" fill="#ffffff"/>
  <text x="32" y="38" font-family="Arial, sans-serif" font-size="14" font-weight="bold" text-anchor="middle" fill="#000000">JB</text>
</svg>
EOF
fi

# Créer le fichier .desktop pour l'intégration GNOME
print_info "Création du raccourci GNOME..."
cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=JetBrains Toolbox
Comment=Manage your JetBrains IDEs
Comment[fr]=Gérez vos IDEs JetBrains
Exec=$INSTALL_DIR/bin/jetbrains-toolbox
Icon=jetbrains-toolbox
Terminal=false
Categories=Development;IDE;
Keywords=jetbrains;intellij;pycharm;webstorm;phpstorm;ide;development;
StartupNotify=true
StartupWMClass=jetbrains-toolbox
MimeType=x-scheme-handler/jetbrains;
EOF

# Rendre le fichier .desktop exécutable
chmod +x "$DESKTOP_FILE"

print_success "Raccourci GNOME créé"

# Mettre à jour la base de données des applications
print_info "Mise à jour de la base de données des applications..."
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$HOME/.local/share/applications"
fi

if command -v gtk-update-icon-cache &> /dev/null; then
    gtk-update-icon-cache -f -t "$HOME/.local/share/icons/hicolor" 2>/dev/null || true
fi

# Nettoyer les fichiers temporaires
print_info "Nettoyage des fichiers temporaires..."
cd "$HOME"
rm -rf "$TEMP_DIR"

print_success "Nettoyage terminé"

# Créer un script de désinstallation
print_info "Création du script de désinstallation..."
UNINSTALL_SCRIPT="$INSTALL_DIR/uninstall.sh"

cat > "$UNINSTALL_SCRIPT" << 'EOF'
#!/bin/bash
# Script de désinstallation JetBrains Toolbox

echo "🗑️  Désinstallation de JetBrains Toolbox..."

# Fermer Toolbox s'il est en cours d'exécution
pkill -f jetbrains-toolbox || true

# Supprimer les fichiers d'installation
rm -rf "$HOME/.local/share/JetBrains/Toolbox"

# Supprimer le raccourci
rm -f "$HOME/.local/share/applications/jetbrains-toolbox.desktop"

# Supprimer l'icône
rm -f "$HOME/.local/share/icons/hicolor/scalable/apps/jetbrains-toolbox.png"
rm -f "$HOME/.local/share/icons/hicolor/scalable/apps/jetbrains-toolbox.svg"

# Mettre à jour la base de données
update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
gtk-update-icon-cache -f -t "$HOME/.local/share/icons/hicolor" 2>/dev/null || true

echo "✅ JetBrains Toolbox désinstallé avec succès"
EOF

chmod +x "$UNINSTALL_SCRIPT"

print_success "Script de désinstallation créé: $UNINSTALL_SCRIPT"

# Ajouter Toolbox au PATH (optionnel)
print_info "Configuration des variables d'environnement..."
if ! echo "$PATH" | grep -q "$INSTALL_DIR/bin"; then
    if [[ -f "$HOME/.bashrc" ]]; then
        echo "export PATH=\"\$PATH:$INSTALL_DIR/bin\"" >> "$HOME/.bashrc"
    fi

    if [[ -f "$HOME/.zshrc" ]]; then
        echo "export PATH=\"\$PATH:$INSTALL_DIR/bin\"" >> "$HOME/.zshrc"
    fi

    export PATH="$PATH:$INSTALL_DIR/bin"
    print_success "JetBrains Toolbox ajouté au PATH"
fi

print_header "
╔══════════════════════════════════════════════════════════════════════╗
║                    INSTALLATION TERMINÉE AVEC SUCCÈS                ║
╚══════════════════════════════════════════════════════════════════════╝
"

print_success "🎉 JetBrains Toolbox installé avec succès!"
echo ""

print_cyan "📍 Informations d'installation:"
print_info "  📁 Répertoire: $INSTALL_DIR"
print_info "  🚀 Exécutable: $INSTALL_DIR/bin/jetbrains-toolbox"
print_info "  🖥️  Raccourci GNOME: $DESKTOP_FILE"
print_info "  🎨 Icône: $ICON_DIR/jetbrains-toolbox.*"
print_info "  🗑️  Désinstalleur: $UNINSTALL_SCRIPT"
echo ""

print_cyan "🔧 Comment utiliser:"
print_info "1. Recherchez 'JetBrains Toolbox' dans le menu des applications GNOME"
print_info "2. Ou lancez depuis le terminal: jetbrains-toolbox"
print_info "3. Ou utilisez le chemin complet: $INSTALL_DIR/bin/jetbrains-toolbox"
echo ""

print_cyan "📦 Prochaines étapes:"
print_info "• Connectez-vous à votre compte JetBrains dans Toolbox"
print_info "• Installez vos IDEs préférés (IntelliJ, PyCharm, WebStorm, etc.)"
print_info "• Configurez les paramètres selon vos préférences"
echo ""

# Proposer de lancer Toolbox immédiatement
read -p "🚀 Voulez-vous lancer JetBrains Toolbox maintenant ? [Y/n]: " launch_now
if [[ "$launch_now" =~ ^[Nn]$ ]]; then
    print_info "Vous pouvez lancer Toolbox plus tard depuis le menu des applications"
else
    print_info "Lancement de JetBrains Toolbox..."

    # Lancer en arrière-plan pour ne pas bloquer le terminal
    nohup "$INSTALL_DIR/bin/jetbrains-toolbox" > /dev/null 2>&1 &

    # Attendre un peu pour que l'application se lance
    sleep 3

    if pgrep -f jetbrains-toolbox > /dev/null; then
        print_success "✅ JetBrains Toolbox lancé avec succès!"
        print_info "L'application devrait apparaître dans votre barre des tâches"
    else
        print_warning "⚠️  Toolbox ne semble pas s'être lancé automatiquement"
        print_info "Vous pouvez le lancer manuellement depuis le menu des applications"
    fi
fi

print_cyan "💡 Conseils:"
print_info "• Toolbox gère automatiquement les mises à jour de vos IDEs"
print_info "• Vous pouvez installer plusieurs versions d'un même IDE"
print_info "• Utilisez les projets récents pour un accès rapide"
print_info "• Pour désinstaller: bash $UNINSTALL_SCRIPT"

print_success "🎯 Installation terminée! Bon développement avec JetBrains! 🚀"
