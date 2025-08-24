#!/bin/bash

# Script d'installation Go (Golang) pour Ubuntu 24.04
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

print_info "🐹 Installation de Go (Golang) pour Ubuntu 24.04"
print_info "=============================================="

# Mettre à jour les packages système
print_info "Mise à jour des packages système..."
sudo apt update -y

# Installer les dépendances nécessaires
print_info "Installation des dépendances..."
sudo apt install -y wget curl software-properties-common

# Variables pour la version
GO_VERSION_URL="https://go.dev/dl/"
GO_LATEST=$(curl -s https://go.dev/VERSION?m=text 2>/dev/null || echo "go1.23.4")
GO_TARBALL="${GO_LATEST}.linux-amd64.tar.gz"
INSTALL_DIR="/usr/local"

# Vérifier si Go est déjà installé
if command -v go &> /dev/null; then
    CURRENT_VERSION=$(go version | awk '{print $3}')
    print_warning "Go est déjà installé: $CURRENT_VERSION"

    if [[ "$CURRENT_VERSION" == "$GO_LATEST" ]]; then
        print_success "Go est déjà à la dernière version!"

        # Vérifier la configuration des variables d'environnement
        if ! echo $PATH | grep -q "/usr/local/go/bin"; then
            print_warning "Variables d'environnement manquantes, reconfiguration..."
        else
            print_info "Variables d'environnement déjà configurées."
            go version
            exit 0
        fi
    else
        print_warning "Une nouvelle version est disponible: $GO_LATEST"
        print_info "Suppression de l'ancienne version..."
        sudo rm -rf /usr/local/go
    fi
else
    print_info "Installation de Go..."
fi

# Télécharger la dernière version de Go
print_info "Téléchargement de Go $GO_LATEST..."
cd /tmp
wget -q "https://go.dev/dl/${GO_TARBALL}" -O "${GO_TARBALL}"

if [[ ! -f "${GO_TARBALL}" ]]; then
    print_error "Échec du téléchargement de Go"
    exit 1
fi

# Extraire Go vers /usr/local
print_info "Installation de Go dans $INSTALL_DIR..."
sudo tar -C $INSTALL_DIR -xzf "${GO_TARBALL}"

# Configurer les variables d'environnement
print_info "Configuration des variables d'environnement..."

# Ajouter au profil système pour tous les utilisateurs
sudo tee /etc/profile.d/golang.sh > /dev/null <<EOF
export GOROOT=/usr/local/go
export GOPATH=\$HOME/go
export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin
EOF

# Rendre le script exécutable
sudo chmod +x /etc/profile.d/golang.sh

# Ajouter au profil utilisateur actuel
if ! grep -q "GOROOT" ~/.bashrc; then
    cat >> ~/.bashrc <<EOF

# Go programming language
export GOROOT=/usr/local/go
export GOPATH=\$HOME/go
export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin
EOF
fi

# Créer le workspace Go
print_info "Création du workspace Go..."
mkdir -p $HOME/go/{bin,src,pkg}

# Charger les variables d'environnement pour la session actuelle
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Nettoyer le fichier téléchargé
rm -f /tmp/${GO_TARBALL}

# Vérifier l'installation
if command -v go &> /dev/null; then
    GO_VERSION_INSTALLED=$(go version)
    print_success "✅ Go installé avec succès!"
    print_success "$GO_VERSION_INSTALLED"

    # Afficher les variables d'environnement
    print_info "Variables d'environnement configurées:"
    print_info "  GOROOT: $GOROOT"
    print_info "  GOPATH: $GOPATH"
    print_info "  PATH: Go ajouté au PATH"

else
    print_error "❌ Erreur lors de l'installation de Go"
    exit 1
fi

print_warning "⚠️  Pour utiliser Go immédiatement, exécutez:"
print_warning "source ~/.bashrc"
print_warning "ou redémarrez votre terminal."

print_info "📝 Commandes utiles:"
print_info "  go version                    # Vérifier la version de Go"
print_info "  go env                        # Afficher les variables d'environnement Go"
print_info "  go mod init <module_name>     # Créer un nouveau module Go"
print_info "  go run main.go                # Exécuter un programme Go"
print_info "  go build                      # Compiler un programme Go"
print_info "  go install                    # Installer un package Go"

print_info "🗂️  Workspace Go créé dans: $HOME/go"
print_info "  $HOME/go/src  # Code source"
print_info "  $HOME/go/bin  # Binaires"
print_info "  $HOME/go/pkg  # Packages compilés"
