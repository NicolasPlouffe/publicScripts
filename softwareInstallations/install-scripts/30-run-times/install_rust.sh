#!/bin/bash

# Script d'installation Rust pour Ubuntu 24.04
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

print_info "🦀 Installation de Rust pour Ubuntu 24.04"
print_info "========================================"

# Mettre à jour les packages système
print_info "Mise à jour des packages système..."
sudo apt update -y

# Installer les dépendances nécessaires
print_info "Installation des dépendances..."
sudo apt install -y curl wget build-essential

# Vérifier si Rust est déjà installé
if command -v rustc &> /dev/null; then
    RUST_VERSION=$(rustc --version)
    print_warning "Rust est déjà installé: $RUST_VERSION"

    # Vérifier si rustup est installé pour les mises à jour
    if command -v rustup &> /dev/null; then
        print_info "Mise à jour de Rust vers la dernière version..."
        rustup update stable
        rustup default stable

        UPDATED_VERSION=$(rustc --version)
        print_success "Rust mis à jour: $UPDATED_VERSION"

        # Vérifier Cargo
        if command -v cargo &> /dev/null; then
            CARGO_VERSION=$(cargo --version)
            print_success "Cargo: $CARGO_VERSION"
        fi

        print_success "✅ Rust est déjà installé et à jour!"
        exit 0
    else
        print_warning "Rust installé mais rustup manquant. Réinstallation recommandée."
        print_info "Sauvegarde de l'installation actuelle..."
    fi
else
    print_info "Installation de Rust avec rustup..."
fi

# Télécharger et exécuter le script d'installation rustup
print_info "Téléchargement et exécution du script d'installation rustup..."

# Installation non-interactive avec les paramètres par défaut
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Charger l'environnement Rust pour la session actuelle
print_info "Configuration de l'environnement Rust..."
source "$HOME/.cargo/env"

# Vérifier que l'installation a réussi
if command -v rustc &> /dev/null && command -v cargo &> /dev/null; then
    RUST_VERSION=$(rustc --version)
    CARGO_VERSION=$(cargo --version)
    RUSTUP_VERSION=$(rustup --version | head -n1)

    print_success "✅ Rust installé avec succès!"
    print_success "Rustc: $RUST_VERSION"
    print_success "Cargo: $CARGO_VERSION"
    print_success "Rustup: $RUSTUP_VERSION"
else
    print_error "❌ Erreur lors de l'installation de Rust"
    exit 1
fi

# Installer les composants utiles
print_info "Installation des composants Rust utiles..."
rustup component add clippy rustfmt rust-docs

# Vérifier les composants installés
print_info "Composants installés:"
rustup component list --installed

# Mettre à jour Rust vers la dernière version stable
print_info "Mise à jour vers la dernière version stable..."
rustup update stable
rustup default stable

# Afficher les informations finales
print_success "📦 Rust installé dans: ~/.cargo"
print_success "🔧 Cargo (package manager): disponible"
print_success "📚 Documentation: rustup doc"

print_warning "⚠️  Pour utiliser Rust immédiatement, exécutez:"
print_warning "source ~/.cargo/env"
print_warning "ou redémarrez votre terminal."

print_info "📝 Commandes utiles:"
print_info "  rustc --version              # Vérifier la version de Rust"
print_info "  cargo --version              # Vérifier la version de Cargo"
print_info "  cargo new <project_name>     # Créer un nouveau projet Rust"
print_info "  cargo build                  # Compiler le projet"
print_info "  cargo run                    # Compiler et exécuter le projet"
print_info "  cargo test                   # Exécuter les tests"
print_info "  cargo update                 # Mettre à jour les dépendances"
print_info "  cargo clippy                 # Linter Rust"
print_info "  cargo fmt                    # Formater le code"
print_info "  rustup update                # Mettre à jour Rust"
print_info "  rustup doc                   # Ouvrir la documentation"

print_info "🔗 Utilitaires installés:"
print_info "  clippy  # Linter avancé pour Rust"
print_info "  rustfmt # Formateur de code Rust"
print_info "  docs    # Documentation hors-ligne"

print_info "🚀 Prêt pour le développement Rust!"
