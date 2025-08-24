#!/bin/bash

# Script principal d'installation pour Ubuntu 24.04
# Auteur: Générateur automatique  
# Date: $(date)

set -e  # Arrêter le script en cas d'erreur

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
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

# Fonction pour rendre un script exécutable et l'exécuter
run_script() {
    local script_name="$1"
    local description="$2"

    if [[ -f "$script_name" ]]; then
        print_info "Exécution du script: $description"
        chmod +x "$script_name"
        ./"$script_name"
        print_success "✅ $description terminé"
        echo ""
    else
        print_error "❌ Script $script_name non trouvé"
        return 1
    fi
}

# Banner
print_header "
╔══════════════════════════════════════════════════════════════╗
║             INSTALLATION AUTOMATIQUE - UBUNTU 24.04         ║
║                    Environnement de développement           ║
╚══════════════════════════════════════════════════════════════╝
"

print_info "🚀 Ce script va installer les composants de base de votre environnement de développement"
print_info "📦 Composants inclus: Node.js (NVM), Python3 + pip, Docker + Docker Compose"
echo ""

# Vérifier les permissions sudo
print_info "Vérification des permissions sudo..."
if ! sudo -n true 2>/dev/null; then
    print_warning "Ce script nécessite des permissions sudo. Vous pourriez être invité à saisir votre mot de passe."
    sudo -v
fi

print_success "Permissions sudo confirmées"
echo ""

# Menu interactif
print_info "Choisissez les composants à installer:"
echo "1) Tout installer (recommandé)"
echo "2) Node.js seulement"  
echo "3) Python3 + pip seulement"
echo "4) Docker + Docker Compose seulement"
echo "5) Installation personnalisée"
echo "6) Quitter"
echo ""

read -p "Votre choix [1-6]: " choice

case $choice in
    1)
        print_header "📦 Installation complète..."
        run_script "install_nodejs.sh" "Installation Node.js"
        run_script "install_python3.sh" "Installation Python3 + pip"
        run_script "install_docker.sh" "Installation Docker + Docker Compose"
        ;;
    2)
        print_header "📦 Installation Node.js..."
        run_script "install_nodejs.sh" "Installation Node.js"
        ;;
    3)
        print_header "📦 Installation Python3..."
        run_script "install_python3.sh" "Installation Python3 + pip"
        ;;
    4)
        print_header "📦 Installation Docker..."
        run_script "install_docker.sh" "Installation Docker + Docker Compose"
        ;;
    5)
        print_header "📦 Installation personnalisée..."

        read -p "Installer Node.js? [y/N]: " install_node
        if [[ "$install_node" =~ ^[Yy]$ ]]; then
            run_script "install_nodejs.sh" "Installation Node.js"
        fi

        read -p "Installer Python3 + pip? [y/N]: " install_python
        if [[ "$install_python" =~ ^[Yy]$ ]]; then
            run_script "install_python3.sh" "Installation Python3 + pip"
        fi

        read -p "Installer Docker + Docker Compose? [y/N]: " install_docker
        if [[ "$install_docker" =~ ^[Yy]$ ]]; then
            run_script "install_docker.sh" "Installation Docker + Docker Compose"
        fi
        ;;
    6)
        print_info "Installation annulée"
        exit 0
        ;;
    *)
        print_error "Choix invalide"
        exit 1
        ;;
esac

print_header "
╔══════════════════════════════════════════════════════════════╗
║                    INSTALLATION TERMINÉE                    ║
╚══════════════════════════════════════════════════════════════╝
"

print_success "🎉 Installation des composants de base terminée avec succès!"
print_info ""
print_info "📝 Prochaines étapes recommandées:"
print_info "1. Redémarrez votre terminal ou exécutez: source ~/.bashrc"
print_info "2. Pour Docker: vous devrez peut-être redémarrer votre session"
print_info "3. Testez vos installations:"
print_info "   - node --version && npm --version"
print_info "   - python3 --version && pip3 --version"  
print_info "   - docker --version && docker compose version"
print_info ""
print_warning "⚠️  Note: Pour les autres langages (Java, Rust, Go, etc.), lancez les scripts correspondants"
