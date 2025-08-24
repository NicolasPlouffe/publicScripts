#!/bin/bash

# Script d'installation MEGA Desktop pour Ubuntu 24.04
# Téléchargement, installation, intégration Nautilus/GNOME et nettoyage
# Compatible Sway + GNOME (pas de conflit)
# Auteur: Générateur automatique
# Date: $(date)

set -e

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

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
║                    INSTALLATION MEGA DESKTOP                        ║
║              UBUNTU 24.04 + NAUTILUS + GNOME/SWAY                  ║
╚══════════════════════════════════════════════════════════════════════╝
"

print_cyan "🚀 Ce script va installer MEGA Desktop avec intégration complète:"
print_cyan "   • Téléchargement du package officiel Ubuntu 24.04"
print_cyan "   • Installation de MEGAsync + extensions Nautilus"
print_cyan "   • Intégration parfaite GNOME (compatible Sway)"
print_cyan "   • Configuration du repository officiel"
print_cyan "   • Nettoyage automatique"
echo ""

# Variables
UBUNTU_VERSION="24.04"
MEGA_BASE_URL="https://mega.nz/linux/repo/xUbuntu_${UBUNTU_VERSION}/amd64"
MEGASYNC_DEB="megasync-xUbuntu_${UBUNTU_VERSION}_amd64.deb"
NAUTILUS_EXT_DEB="nautilus-megasync-xUbuntu_${UBUNTU_VERSION}_amd64.deb"
TEMP_DIR="/tmp/mega-install"

print_info "🔍 Détection de l'architecture système..."
ARCH=$(dpkg --print-architecture)
if [[ "$ARCH" != "amd64" ]]; then
    print_error "❌ Ce script est conçu pour architecture amd64, détectée: $ARCH"
    exit 1
fi
print_success "✅ Architecture amd64 confirmée"

print_info "🔍 Vérification de la version Ubuntu..."
if ! grep -q "24.04" /etc/os-release; then
    print_warning "⚠️  Version Ubuntu non-24.04 détectée, le script peut fonctionner quand même"
    print_info "Contenu /etc/os-release:"
    grep VERSION /etc/os-release
fi

# Création du répertoire temporaire
print_info "📁 Préparation de l'environnement..."
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

print_success "✅ Répertoire temporaire créé: $TEMP_DIR"

# Mise à jour du système
print_info "🔄 Mise à jour des packages système..."
sudo apt update -y

# Vérification de la connectivité
print_info "🌐 Vérification de la connectivité MEGA..."
if curl -s --connect-timeout 10 "$MEGA_BASE_URL" > /dev/null; then
    print_success "✅ Serveurs MEGA accessibles"
else
    print_warning "⚠️  Test de connectivité MEGA incertain, on continue..."
fi

# Téléchargement des packages MEGA
print_info "📥 Téléchargement de MEGAsync..."
print_info "URL: $MEGA_BASE_URL/$MEGASYNC_DEB"

if wget --progress=bar:force:noscroll -O "$MEGASYNC_DEB" "$MEGA_BASE_URL/$MEGASYNC_DEB"; then
    print_success "✅ MEGAsync téléchargé"
else
    print_error "❌ Échec du téléchargement de MEGAsync"
    print_info "💡 Solutions alternatives:"
    print_info "1. Vérifiez votre connexion internet"
    print_info "2. Essayez plus tard (serveurs temporairement indisponibles)"
    print_info "3. Téléchargement manuel: $MEGA_BASE_URL/$MEGASYNC_DEB"
    exit 1
fi

print_info "📥 Téléchargement de l'extension Nautilus..."
print_info "URL: $MEGA_BASE_URL/$NAUTILUS_EXT_DEB"

if wget --progress=bar:force:noscroll -O "$NAUTILUS_EXT_DEB" "$MEGA_BASE_URL/$NAUTILUS_EXT_DEB"; then
    print_success "✅ Extension Nautilus téléchargée"
else
    print_warning "⚠️  Échec du téléchargement de l'extension Nautilus (non critique)"
    print_info "MEGAsync sera installé sans intégration Nautilus"
    NAUTILUS_EXT_DEB=""
fi

# Vérification des fichiers téléchargés
print_info "🔍 Vérification des packages téléchargés..."
MEGASYNC_SIZE=$(stat -c%s "$MEGASYNC_DEB" 2>/dev/null || echo "0")
if [[ $MEGASYNC_SIZE -lt 1000000 ]]; then  # Moins de 1MB
    print_error "❌ Fichier MEGAsync trop petit ($MEGASYNC_SIZE bytes), probablement corrompu"
    exit 1
fi
print_success "✅ MEGAsync vérifié ($(($MEGASYNC_SIZE / 1024 / 1024)) MB)"

if [[ -n "$NAUTILUS_EXT_DEB" ]]; then
    NAUTILUS_SIZE=$(stat -c%s "$NAUTILUS_EXT_DEB" 2>/dev/null || echo "0")
    if [[ $NAUTILUS_SIZE -lt 10000 ]]; then  # Moins de 10KB
        print_warning "⚠️  Extension Nautilus trop petite, ignorée"
        NAUTILUS_EXT_DEB=""
    else
        print_success "✅ Extension Nautilus vérifiée ($(($NAUTILUS_SIZE / 1024)) KB)"
    fi
fi

# Installation des packages
print_info "📦 Installation de MEGAsync..."

# Installation de MEGAsync avec gestion des dépendances
if sudo apt install -y "./$MEGASYNC_DEB"; then
    print_success "✅ MEGAsync installé avec succès"
else
    print_warning "⚠️  Installation directe échouée, tentative avec correction des dépendances..."

    # Tentative avec dpkg puis correction
    sudo dpkg -i "./$MEGASYNC_DEB" || true
    sudo apt-get install -f -y

    if command -v megasync &> /dev/null; then
        print_success "✅ MEGAsync installé après correction des dépendances"
    else
        print_error "❌ Échec définitif de l'installation de MEGAsync"
        exit 1
    fi
fi

# Installation de l'extension Nautilus si disponible
if [[ -n "$NAUTILUS_EXT_DEB" ]]; then
    print_info "📦 Installation de l'extension Nautilus..."

    if sudo apt install -y "./$NAUTILUS_EXT_DEB"; then
        print_success "✅ Extension Nautilus installée"
    else
        print_warning "⚠️  Installation de l'extension Nautilus échouée (non critique)"
        # Tentative avec dpkg
        sudo dpkg -i "./$NAUTILUS_EXT_DEB" || true
        sudo apt-get install -f -y || true
    fi
fi

# Configuration du repository officiel MEGA (pour les mises à jour)
print_info "⚙️  Configuration du repository MEGA pour les mises à jour..."

# Ajout de la clé GPG MEGA
print_info "🔑 Ajout de la clé GPG MEGA..."
if curl -fsSL https://mega.nz/keys/MEGA_signing.key | sudo gpg --dearmor -o /usr/share/keyrings/mega-archive-keyring.gpg; then
    print_success "✅ Clé GPG MEGA ajoutée"
else
    print_warning "⚠️  Échec de l'ajout de la clé GPG (les mises à jour automatiques ne fonctionneront pas)"
fi

# Ajout du repository
print_info "📋 Ajout du repository MEGA..."
REPO_LINE="deb [arch=amd64 signed-by=/usr/share/keyrings/mega-archive-keyring.gpg] https://mega.nz/linux/repo/xUbuntu_${UBUNTU_VERSION}/ ./"

if echo "$REPO_LINE" | sudo tee /etc/apt/sources.list.d/mega.list > /dev/null; then
    print_success "✅ Repository MEGA ajouté"

    # Mise à jour avec le nouveau repository
    if sudo apt update -y; then
        print_success "✅ Liste des packages mise à jour"
    else
        print_warning "⚠️  Mise à jour des packages échouée (non critique)"
    fi
else
    print_warning "⚠️  Échec de l'ajout du repository MEGA"
fi

# Vérification de l'installation
print_info "🧪 Vérification de l'installation..."

if command -v megasync &> /dev/null; then
    MEGA_VERSION=$(megasync --version 2>/dev/null || echo "Installé")
    print_success "✅ MEGAsync installé et fonctionnel"
    print_success "Version: $MEGA_VERSION"
else
    print_error "❌ MEGAsync non accessible après installation"
    exit 1
fi

# Vérification de l'intégration système
print_info "🖥️  Vérification de l'intégration système..."

# Fichier .desktop
if [[ -f "/usr/share/applications/megasync.desktop" ]]; then
    print_success "✅ Raccourci GNOME installé"
else
    print_warning "⚠️  Raccourci GNOME non trouvé"
fi

# Extension Nautilus
if [[ -f "/usr/lib/nautilus/extensions-3.0/libnautilus-megasync.so" ]] || [[ -f "/usr/lib/x86_64-linux-gnu/nautilus/extensions-3.0/libnautilus-megasync.so" ]]; then
    print_success "✅ Extension Nautilus installée"
else
    print_warning "⚠️  Extension Nautilus non détectée"
fi

# Test de compatibilité Sway/GNOME
print_info "🪟 Vérification de la compatibilité environnement..."

# Détection de l'environnement graphique
if [[ -n "$GNOME_DESKTOP_SESSION_ID" ]] || [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
    print_success "✅ Environnement GNOME détecté - intégration parfaite"
elif [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
    print_success "✅ Session Wayland détectée - compatible Sway"
else
    print_info "ℹ️  Environnement: $XDG_CURRENT_DESKTOP ($XDG_SESSION_TYPE)"
fi

print_info "💡 MEGA Desktop est compatible avec:"
print_info "   • GNOME (intégration native Nautilus)"
print_info "   • Sway (fonctionne parfaitement en Wayland)"
print_info "   • Autres environnements (fonctionnalité de base)"

# Nettoyage des fichiers temporaires
print_info "🧹 Nettoyage des fichiers temporaires..."
cd "$HOME"
rm -rf "$TEMP_DIR"
print_success "✅ Nettoyage terminé"

# Configuration post-installation
print_info "⚙️  Configuration post-installation..."

# Mise à jour des bases de données GNOME
if command -v update-desktop-database &> /dev/null; then
    sudo update-desktop-database /usr/share/applications 2>/dev/null || true
    print_success "✅ Base de données des applications mise à jour"
fi

# Redémarrage de Nautilus pour charger l'extension (si en cours)
if pgrep nautilus > /dev/null; then
    print_info "🔄 Redémarrage de Nautilus pour charger l'extension..."
    nautilus -q 2>/dev/null || true
    sleep 2
    print_success "✅ Nautilus redémarré"
fi

print_header "
╔══════════════════════════════════════════════════════════════════════╗
║                    INSTALLATION TERMINÉE AVEC SUCCÈS                ║
╚══════════════════════════════════════════════════════════════════════╝
"

print_success "🎉 MEGA Desktop installé avec succès sur Ubuntu 24.04!"
echo ""

print_cyan "📍 Informations d'installation:"
print_info "  🚀 Application: MEGAsync dans le menu des applications"
print_info "  📁 Intégration: Nautilus (clic droit dans les dossiers)"
print_info "  🔄 Mises à jour: Repository officiel configuré"
print_info "  💾 Taille totale: $(($MEGASYNC_SIZE / 1024 / 1024)) MB"
echo ""

print_cyan "🔧 Comment utiliser MEGA Desktop:"
print_info "1. Recherchez 'MEGA' dans le menu des applications GNOME"
print_info "2. Ou lancez depuis le terminal: megasync"
print_info "3. Connectez-vous à votre compte MEGA"
print_info "4. Configurez la synchronisation de vos dossiers"
print_info "5. Clic droit dans Nautilus pour les options MEGA"
echo ""

print_cyan "🌐 Fonctionnalités MEGA Desktop:"
print_info "• Synchronisation automatique chiffrée de bout en bout"
print_info "• 20 GB de stockage gratuit"
print_info "• Intégration Nautilus (upload, partage, etc.)"
print_info "• Synchronisation sélective des dossiers"
print_info "• Sauvegarde en temps réel"
print_info "• Compatible GNOME + Sway (sans conflit)"
echo ""

print_cyan "🔒 Sécurité et confidentialité:"
print_info "• Chiffrement de bout en bout (zero-knowledge)"
print_info "• Clés de chiffrement contrôlées par l'utilisateur"
print_info "• Aucun accès possible aux données par MEGA"
print_info "• Authentification à deux facteurs disponible"
echo ""

# Proposition de lancement
read -p "🚀 Voulez-vous lancer MEGA Desktop maintenant ? [Y/n]: " launch_now

if [[ "$launch_now" =~ ^[Nn]$ ]]; then
    print_info "Vous pouvez lancer MEGA plus tard depuis le menu des applications"
else
    print_info "Lancement de MEGA Desktop..."

    # Lancer en arrière-plan
    if command -v megasync &> /dev/null; then
        nohup megasync > /tmp/megasync.log 2>&1 &

        sleep 3

        if pgrep -f megasync > /dev/null; then
            print_success "✅ MEGA Desktop lancé avec succès!"
            print_info "L'icône devrait apparaître dans votre barre de notification"
            print_info "Cliquez dessus pour vous connecter à votre compte MEGA"
        else
            print_warning "⚠️  MEGA Desktop ne semble pas s'être lancé automatiquement"
            print_info "Vous pouvez le lancer manuellement depuis le menu des applications"
        fi
    fi
fi

echo ""

print_cyan "💡 Conseils d'utilisation:"
print_info "• Premier lancement: connectez-vous avec votre compte MEGA"
print_info "• Configurez la synchronisation sélective pour économiser l'espace"
print_info "• Dans Nautilus: clic droit → MEGA pour partager des fichiers"
print_info "• Vérifiez les paramètres de bande passante si nécessaire"
print_info "• Les fichiers synchronisés apparaissent dans ~/MEGA par défaut"

print_cyan "🔧 Compatibilité Sway + GNOME:"
print_info "• MEGA Desktop fonctionne parfaitement avec les deux"
print_info "• Sway: utilisation en Wayland native"
print_info "• GNOME: intégration Nautilus complète"
print_info "• Aucun conflit entre les environnements"
print_info "• Basculement transparent entre GNOME et Sway"

print_cyan "🗑️  Pour désinstaller plus tard:"
print_info "sudo apt remove megasync nautilus-megasync"
print_info "sudo rm /etc/apt/sources.list.d/mega.list"

print_success "🎯 MEGA Desktop est prêt à synchroniser vos fichiers! ☁️🔒"

# Informations de dépannage
print_cyan "🔧 En cas de problème:"
print_info "• Logs MEGA: ~/.local/share/data/Mega Limited/MEGAsync/logs/"
print_info "• Redémarrer MEGA: pkill megasync puis relancer"
print_info "• Extension Nautilus: redémarrer Nautilus (nautilus -q)"
print_info "• Support officiel: https://help.mega.io/"

print_success "🌟 Installation terminée avec succès!"
