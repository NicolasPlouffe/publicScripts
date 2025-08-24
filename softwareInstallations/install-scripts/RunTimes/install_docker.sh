#!/bin/bash

# Script d'installation Docker et Docker Compose pour Ubuntu 24.04
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

print_info "🐳 Installation de Docker et Docker Compose pour Ubuntu 24.04"
print_info "=========================================================="

# Mettre à jour les packages système
print_info "Mise à jour des packages système..."
sudo apt update -y

# Installer les dépendances nécessaires
print_info "Installation des dépendances..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release

# Vérifier si Docker est déjà installé
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    print_warning "Docker est déjà installé: $DOCKER_VERSION"

    # Vérifier si Docker est à jour
    print_info "Vérification des mises à jour de Docker..."
    sudo apt update
    if sudo apt list --upgradable 2>/dev/null | grep -q docker; then
        print_info "Mise à jour de Docker disponible, installation..."
        sudo apt upgrade -y docker-ce docker-ce-cli containerd.io
    else
        print_success "Docker est déjà à jour"
    fi
else
    print_info "Installation de Docker..."

    # Supprimer les anciennes versions si elles existent
    sudo apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true

    # Ajouter la clé GPG officielle de Docker
    print_info "Ajout de la clé GPG officielle de Docker..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Ajouter le repository Docker
    print_info "Ajout du repository Docker..."
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Mettre à jour la liste des packages
    sudo apt update

    # Installer Docker
    print_info "Installation de Docker CE..."
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    DOCKER_VERSION=$(docker --version)
    print_success "Docker installé: $DOCKER_VERSION"
fi

# Vérifier si Docker Compose est installé (via plugin)
if docker compose version &> /dev/null; then
    COMPOSE_VERSION=$(docker compose version)
    print_warning "Docker Compose est déjà installé: $COMPOSE_VERSION"
else
    print_info "Installation de Docker Compose standalone..."
    # Installer Docker Compose standalone en plus du plugin
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
    sudo curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    print_success "Docker Compose standalone installé: $(docker-compose --version)"
fi

# Démarrer et activer le service Docker
print_info "Démarrage et activation du service Docker..."
sudo systemctl start docker
sudo systemctl enable docker

# Ajouter l'utilisateur actuel au groupe docker (pour éviter sudo)
print_info "Ajout de l'utilisateur actuel au groupe docker..."
sudo usermod -aG docker $USER

# Vérifier l'installation avec hello-world
print_info "Test de l'installation Docker..."
if sudo docker run hello-world &> /dev/null; then
    print_success "Docker fonctionne correctement!"
else
    print_error "Erreur lors du test Docker"
fi

# Vérifications finales
print_info "Vérification des installations..."
DOCKER_FINAL=$(docker --version)
COMPOSE_PLUGIN=$(docker compose version)
if command -v docker-compose &> /dev/null; then
    COMPOSE_STANDALONE=$(docker-compose --version)
else
    COMPOSE_STANDALONE="Non installé"
fi

print_success "✅ Installation terminée avec succès!"
print_success "Docker: $DOCKER_FINAL"
print_success "Docker Compose (plugin): $COMPOSE_PLUGIN"
print_success "Docker Compose (standalone): $COMPOSE_STANDALONE"

print_warning "⚠️  Pour utiliser Docker sans sudo, vous devez:"
print_warning "1. Redémarrer votre session ou exécuter: newgrp docker"
print_warning "2. Ou redémarrer complètement votre système"

print_info "📝 Commandes utiles:"
print_info "  docker --version                # Vérifier la version de Docker"
print_info "  docker compose version          # Vérifier Docker Compose (plugin)"
print_info "  docker-compose --version        # Vérifier Docker Compose (standalone)"
print_info "  docker ps                       # Lister les conteneurs en cours"
print_info "  docker images                   # Lister les images Docker"
print_info "  docker run hello-world          # Tester Docker"
