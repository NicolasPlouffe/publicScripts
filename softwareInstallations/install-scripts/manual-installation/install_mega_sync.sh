#!/bin/bash

# Script d'installation MEGA Sync pour Ubuntu 24.04
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
║                        INSTALLATION MEGA SYNC                       ║
║                           UBUNTU 24.04                              ║
╚══════════════════════════════════════════════════════════════════════╝
"

print_cyan "☁️  Ce script va installer MEGA Sync pour Ubuntu 24.04:"
print_cyan "   • Téléchargement automatique du package officiel"
print_cyan "   • Installation des dépendances requises"
print_cyan "   • Configuration de MEGA Sync"
print_cyan "   • Intégration avec le système de fichiers"
echo ""

# Variables
MEGA_URL="https://mega.nz/linux/repo/xUbuntu_24.04/amd64/megasync-xUbuntu_24.04_amd64.deb"
TEMP_DIR="/tmp/mega-install"
DEB_FILE="megasync-xUbuntu_24.04_amd64.deb"

# Vérifier les permissions et prérequis
print_info "Vérification des prérequis..."

# Vérifier si on est sur Ubuntu/Debian
if ! command -v apt &> /dev/null; then
    print_error "Ce script est conçu pour Ubuntu/Debian avec apt"
    exit 1
fi

# Vérifier la connexion internet
if ! ping -c 1 mega.nz &> /dev/null; then
    print_error "Connexion internet requise pour télécharger MEGA Sync"
    exit 1
fi

print_success "Prérequis validés"

# Vérifier si MEGA Sync est déjà installé
if command -v megasync &> /dev/null; then
    MEGA_VERSION=$(megasync --version 2>/dev/null || echo "Version inconnue")
    print_warning "MEGA Sync est déjà installé: $MEGA_VERSION"
    read -p "Voulez-vous le réinstaller/mettre à jour ? [y/N]: " reinstall
    if [[ ! "$reinstall" =~ ^[Yy]$ ]]; then
        print_info "Installation annulée"
        exit 0
    fi
fi

# Mettre à jour les packages système
print_info "Mise à jour des packages système..."
sudo apt update -y

# Installer les dépendances requises pour MEGA Sync
print_info "Installation des dépendances MEGA Sync..."
sudo apt install -y \
    wget \
    curl \
    ca-certificates \
    gnupg \
    lsb-release \
    libqt5widgets5 \
    libqt5gui5 \
    libqt5core5a \
    libqt5network5 \
    libqt5svg5 \
    libssl3 \
    libc-ares2 \
    libcrypto++8 \
    libmediainfo0v5 \
    libzen0v5 \
    libuv1

print_success "Dépendances installées"

# Créer le répertoire temporaire
print_info "Création du répertoire temporaire..."
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Télécharger MEGA Sync
print_info "Téléchargement de MEGA Sync..."
print_info "URL: $MEGA_URL"

if wget -O "$DEB_FILE" "$MEGA_URL"; then
    print_success "Téléchargement réussi"
else
    print_error "Échec du téléchargement"

    # URL alternative via repository
    print_info "Tentative avec le repository MEGA..."

    # Ajouter la clé GPG MEGA
    wget -qO - https://mega.nz/linux/repo/xUbuntu_24.04/Release.key | sudo apt-key add - || true

    # Ajouter le repository MEGA
    echo "deb https://mega.nz/linux/repo/xUbuntu_24.04/ ./" | sudo tee /etc/apt/sources.list.d/megasync.list

    # Mettre à jour et installer via repository
    sudo apt update
    if sudo apt install -y megasync; then
        print_success "MEGA Sync installé via repository"
        cd "$HOME"
        rm -rf "$TEMP_DIR"

        # Aller directement aux vérifications finales
        print_info "Installation via repository réussie, passage aux vérifications..."
        REPO_INSTALL=true
    else
        print_error "Échec de toutes les méthodes d'installation"
        exit 1
    fi
fi

# Installation du package .deb (si téléchargement direct réussi)
if [[ "$REPO_INSTALL" != "true" ]]; then
    print_info "Installation du package MEGA Sync..."

    # Vérifier l'intégrité du fichier téléchargé
    if [[ ! -f "$DEB_FILE" ]]; then
        print_error "Fichier $DEB_FILE non trouvé"
        exit 1
    fi

    # Vérifier la taille du fichier (doit être > 1MB)
    FILE_SIZE=$(stat -c%s "$DEB_FILE")
    if [[ $FILE_SIZE -lt 1000000 ]]; then
        print_error "Fichier téléchargé trop petit ($FILE_SIZE bytes), probablement corrompu"
        exit 1
    fi

    print_success "Fichier vérifié (${FILE_SIZE} bytes)"

    # Installer le package avec gestion des dépendances
    print_info "Installation du package .deb..."
    if sudo apt install -y "./$DEB_FILE"; then
        print_success "MEGA Sync installé via package .deb"
    else
        print_warning "Échec de l'installation directe, tentative avec dpkg + fix..."

        # Installer avec dpkg puis corriger les dépendances
        sudo dpkg -i "./$DEB_FILE" || true
        sudo apt-get install -f -y

        if command -v megasync &> /dev/null; then
            print_success "MEGA Sync installé après correction des dépendances"
        else
            print_error "Échec définitif de l'installation"
            exit 1
        fi
    fi

    # Nettoyer les fichiers temporaires
    print_info "Nettoyage des fichiers temporaires..."
    cd "$HOME"
    rm -rf "$TEMP_DIR"
fi

# Vérifications finales
print_info "Vérification de l'installation..."

if command -v megasync &> /dev/null; then
    MEGA_VERSION_FINAL=$(megasync --version 2>/dev/null || echo "Installé")
    print_success "✅ MEGA Sync installé avec succès!"
    print_success "Version: $MEGA_VERSION_FINAL"
else
    print_error "❌ MEGA Sync n'est pas accessible après installation"
    exit 1
fi

# Vérifier l'intégration système
if [[ -f "/usr/share/applications/megasync.desktop" ]]; then
    print_success "Raccourci bureau installé"
else
    print_warning "Raccourci bureau non trouvé"
fi

# Configuration additionnelle
print_info "Configuration de MEGA Sync..."

# Créer le répertoire de configuration s'il n'existe pas
mkdir -p "$HOME/.local/share/data/Mega Limited"

# Vérifier si le service peut démarrer
print_info "Test de démarrage de MEGA Sync..."
timeout 10 megasync --version &>/dev/null && print_success "MEGA Sync fonctionne correctement" || print_warning "Délai d'attente dépassé pour le test"

print_header "
╔══════════════════════════════════════════════════════════════════════╗
║                    INSTALLATION TERMINÉE AVEC SUCCÈS                ║
╚══════════════════════════════════════════════════════════════════════╝
"

print_success "🎉 MEGA Sync installé avec succès!"
echo ""

print_cyan "📍 Informations d'installation:"
print_info "  📁 Exécutable: $(which megasync 2>/dev/null || echo '/usr/bin/megasync')"
print_info "  🖥️  Raccourci: Recherchez 'MEGA' dans le menu des applications"
print_info "  ⚙️  Configuration: ~/.local/share/data/Mega Limited/"
print_info "  📄 Logs: ~/.local/share/data/Mega Limited/MEGAsync/logs/"
echo ""

print_cyan "🔧 Comment utiliser MEGA Sync:"
print_info "1. Recherchez 'MEGA' dans le menu des applications GNOME"
print_info "2. Ou lancez depuis le terminal: megasync"
print_info "3. Connectez-vous avec votre compte MEGA"
print_info "4. Configurez les dossiers à synchroniser"
echo ""

print_cyan "⚙️  Fonctionnalités MEGA Sync:"
print_info "• Synchronisation automatique de fichiers"
print_info "• Chiffrement de bout en bout"
print_info "• Partage de fichiers et dossiers"
print_info "• Versions de fichiers et corbeille"
print_info "• Intégration avec l'explorateur de fichiers"
echo ""

# Proposer de lancer MEGA Sync
read -p "☁️  Voulez-vous lancer MEGA Sync maintenant ? [Y/n]: " launch_now
if [[ "$launch_now" =~ ^[Nn]$ ]]; then
    print_info "Vous pouvez lancer MEGA Sync plus tard depuis le menu des applications"
else
    print_info "Lancement de MEGA Sync..."

    # Lancer en arrière-plan
    nohup megasync > /dev/null 2>&1 &

    sleep 3

    if pgrep -f megasync > /dev/null; then
        print_success "✅ MEGA Sync lancé avec succès!"
        print_info "L'icône devrait apparaître dans votre barre de notification"
        print_info "Cliquez dessus pour vous connecter à votre compte MEGA"
    else
        print_warning "⚠️  MEGA Sync ne semble pas s'être lancé automatiquement"
        print_info "Vous pouvez le lancer manuellement depuis le menu des applications"
    fi
fi

print_cyan "💡 Conseils d'utilisation:"
print_info "• Premier lancement: connectez-vous avec votre compte MEGA"
print_info "• Configurez la synchronisation sélective pour économiser l'espace"
print_info "• Utilisez le clic droit dans l'explorateur pour partager des fichiers"
print_info "• Vérifiez les paramètres de bande passante si nécessaire"
print_info "• Les fichiers synchronisés apparaissent dans ~/MEGA par défaut"

print_cyan "🔒 Sécurité:"
print_info "• Vos fichiers sont chiffrés de bout en bout"
print_info "• Même MEGA ne peut pas accéder à vos données"
print_info "• Gardez votre clé de récupération en lieu sûr"

print_success "🎯 MEGA Sync est prêt à synchroniser vos fichiers! ☁️✨"

# Afficher des informations sur la désinstallation
print_cyan "🗑️  Pour désinstaller plus tard:"
print_info "sudo apt remove megasync"
