#!/bin/bash

# Script d'installation Node.js via NVM pour Ubuntu 24.04
# Auteur: Générateur automatique
# Date: $(date)

set -e  # Arrêter le script en cas d'erreur

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

print_info "🚀 Installation de Node.js via NVM pour Ubuntu 24.04"
print_info "================================================"

# Mettre à jour les packages système
print_info "Mise à jour des packages système..."
sudo apt update -y

# Installer les dépendances nécessaires
print_info "Installation des dépendances..."
sudo apt install -y curl wget software-properties-common apt-transport-https ca-certificates

# Vérifier si NVM est déjà installé
if command -v nvm &> /dev/null; then
    print_warning "NVM est déjà installé. Version actuelle:"
    nvm --version

    # Mettre à jour NVM vers la dernière version
    print_info "Mise à jour de NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
else
    # Installer NVM
    print_info "Installation de NVM (Node Version Manager)..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

    # Recharger le profil bash pour utiliser NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

    print_success "NVM installé avec succès!"
fi

# Recharger NVM si nécessaire
if ! command -v nvm &> /dev/null; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# Installer la dernière version LTS de Node.js
print_info "Installation de la dernière version LTS de Node.js..."
nvm install --lts
nvm use --lts
nvm alias default node

# Vérifier l'installation
print_info "Vérification de l'installation..."
NODE_VERSION=$(node --version)
NPM_VERSION=$(npm --version)

print_success "Node.js installé: $NODE_VERSION"
print_success "npm installé: $NPM_VERSION"

# Mettre à jour npm vers la dernière version
print_info "Mise à jour de npm vers la dernière version..."
npm install -g npm@latest

# Afficher les informations finales
print_success "✅ Installation terminée avec succès!"
print_info "Pour utiliser Node.js dans un nouveau terminal, exécutez:"
print_info "source ~/.bashrc"
print_info "ou redémarrez votre terminal."

print_info "📝 Commandes utiles:"
print_info "  nvm list                    # Lister les versions installées"
print_info "  nvm install <version>       # Installer une version spécifique"
print_info "  nvm use <version>           # Utiliser une version spécifique"
print_info "  nvm alias default <version> # Définir la version par défaut"
