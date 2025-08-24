#!/bin/bash

# Script principal d'installation pour Ubuntu 24.04
# Environnement de développement complet
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
╔══════════════════════════════════════════════════════════════════════╗
║                    INSTALLATION AUTOMATIQUE - UBUNTU 24.04          ║
║                      Environnement de développement                 ║
║                            COMPLET                                   ║
╚══════════════════════════════════════════════════════════════════════╝
"

print_cyan "🚀 Ce script va installer un environnement de développement complet"
print_cyan "📦 Langages et outils disponibles:"
echo ""
print_cyan "   🌐 Frontend & Web:"
print_cyan "   • Node.js + npm (JavaScript/TypeScript runtime)"
print_cyan "   • React, Angular, Vite (via npm)"
print_cyan "   • Tailwind CSS (via npm)"
echo ""
print_cyan "   🖥️  Backend & Systems:"
print_cyan "   • Python3 + pip (data science, web, automation)"
print_cyan "   • Java Eclipse Temurin (enterprise applications)"
print_cyan "   • Go (cloud, microservices, CLI tools)"
print_cyan "   • Rust (systems programming, performance)"
print_cyan "   • C++ (performance, embedded, games)"
echo ""
print_cyan "   🏗️  Infrastructure & DevOps:"
print_cyan "   • Docker + Docker Compose (containerization)"
print_cyan "   • Kubernetes tools (orchestration)"
echo ""
print_cyan "   📚 Prochains scripts (à venir):"
print_cyan "   • C# (.NET development)"
print_cyan "   • Kotlin (Android, multiplatform)"
print_cyan "   • Solidity (blockchain development)"
print_cyan "   • R (statistical computing)"
echo ""

# Vérifier les permissions sudo
print_info "Vérification des permissions sudo..."
if ! sudo -n true 2>/dev/null; then
    print_warning "Ce script nécessite des permissions sudo. Vous pourriez être invité à saisir votre mot de passe."
    sudo -v
fi

print_success "Permissions sudo confirmées"
echo ""

# Menu principal
print_info "🎯 Choisissez le type d'installation:"
echo "1)  🚀 Installation COMPLÈTE (tous les langages - recommandé)"
echo "2)  🌐 Pack FRONTEND (Node.js + outils web)"
echo "3)  🖥️  Pack BACKEND (Python + Java + Go)"
echo "4)  ⚡ Pack SYSTEMS (Rust + C++ + Go)"
echo "5)  🏗️  Pack DEVOPS (Docker + Kubernetes)"
echo "6)  🎛️  Installation PERSONNALISÉE (choisir individuellement)"
echo "7)  📋 Voir les scripts disponibles"
echo "8)  ❌ Quitter"
echo ""

read -p "Votre choix [1-8]: " choice

case $choice in
    1)
        print_header "🚀 Installation COMPLÈTE en cours..."
        run_script "install_nodejs.sh" "Installation Node.js + npm"
        run_script "install_python3.sh" "Installation Python3 + pip"
        run_script "install_java_temurin.sh" "Installation Java Eclipse Temurin"
        run_script "install_go.sh" "Installation Go (Golang)"
        run_script "install_rust.sh" "Installation Rust"
        run_script "install_cpp.sh" "Installation C++ + outils"
        run_script "install_docker.sh" "Installation Docker + Docker Compose"
        ;;
    2)
        print_header "🌐 Installation Pack FRONTEND..."
        run_script "install_nodejs.sh" "Installation Node.js + npm"
        print_info "Installation des outils frontend..."
        source ~/.bashrc 2>/dev/null || true
        npm install -g create-react-app @angular/cli @vitejs/create-vue tailwindcss typescript
        ;;
    3)
        print_header "🖥️  Installation Pack BACKEND..."
        run_script "install_python3.sh" "Installation Python3 + pip"
        run_script "install_java_temurin.sh" "Installation Java Eclipse Temurin"
        run_script "install_go.sh" "Installation Go (Golang)"
        ;;
    4)
        print_header "⚡ Installation Pack SYSTEMS..."
        run_script "install_rust.sh" "Installation Rust"
        run_script "install_cpp.sh" "Installation C++ + outils"
        run_script "install_go.sh" "Installation Go (Golang)"
        ;;
    5)
        print_header "🏗️  Installation Pack DEVOPS..."
        run_script "install_docker.sh" "Installation Docker + Docker Compose"
        print_info "Installation des outils Kubernetes..."
        # Installation de kubectl
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
        rm kubectl
        print_success "kubectl installé"
        ;;
    6)
        print_header "🎛️  Installation PERSONNALISÉE..."

        read -p "📦 Installer Node.js + npm ? [y/N]: " install_node
        if [[ "$install_node" =~ ^[Yy]$ ]]; then
            run_script "install_nodejs.sh" "Installation Node.js + npm"
        fi

        read -p "🐍 Installer Python3 + pip ? [y/N]: " install_python
        if [[ "$install_python" =~ ^[Yy]$ ]]; then
            run_script "install_python3.sh" "Installation Python3 + pip"
        fi

        read -p "☕ Installer Java Eclipse Temurin ? [y/N]: " install_java
        if [[ "$install_java" =~ ^[Yy]$ ]]; then
            run_script "install_java_temurin.sh" "Installation Java Eclipse Temurin"
        fi

        read -p "🐹 Installer Go (Golang) ? [y/N]: " install_go
        if [[ "$install_go" =~ ^[Yy]$ ]]; then
            run_script "install_go.sh" "Installation Go (Golang)"
        fi

        read -p "🦀 Installer Rust ? [y/N]: " install_rust
        if [[ "$install_rust" =~ ^[Yy]$ ]]; then
            run_script "install_rust.sh" "Installation Rust"
        fi

        read -p "⚙️  Installer C++ + outils ? [y/N]: " install_cpp
        if [[ "$install_cpp" =~ ^[Yy]$ ]]; then
            run_script "install_cpp.sh" "Installation C++ + outils"
        fi

        read -p "🐳 Installer Docker + Docker Compose ? [y/N]: " install_docker
        if [[ "$install_docker" =~ ^[Yy]$ ]]; then
            run_script "install_docker.sh" "Installation Docker + Docker Compose"
        fi
        ;;
    7)
        print_header "📋 Scripts disponibles:"
        echo ""
        ls -la *.sh | grep -E "install_|setup_" | while read -r line; do
            script_name=$(echo "$line" | awk '{print $9}')
            case $script_name in
                install_nodejs.sh) echo "  📜 $script_name - Node.js + npm + outils frontend" ;;
                install_python3.sh) echo "  📜 $script_name - Python3 + pip + outils" ;;
                install_java_temurin.sh) echo "  📜 $script_name - Java Eclipse Temurin OpenJDK" ;;
                install_go.sh) echo "  📜 $script_name - Go (Golang) dernière version" ;;
                install_rust.sh) echo "  📜 $script_name - Rust + Cargo + outils" ;;
                install_cpp.sh) echo "  📜 $script_name - C++ + GCC + Clang + CMake" ;;
                install_docker.sh) echo "  📜 $script_name - Docker + Docker Compose" ;;
                *) echo "  📜 $script_name" ;;
            esac
        done
        echo ""
        print_info "Pour exécuter un script individuellement: ./nom_du_script.sh"
        exit 0
        ;;
    8)
        print_info "Installation annulée"
        exit 0
        ;;
    *)
        print_error "Choix invalide"
        exit 1
        ;;
esac

print_header "
╔══════════════════════════════════════════════════════════════════════╗
║                         INSTALLATION TERMINÉE                       ║
╚══════════════════════════════════════════════════════════════════════╝
"

print_success "🎉 Installation terminée avec succès!"
print_info ""
print_info "🔄 Prochaines étapes recommandées:"
print_info "1. Redémarrez votre terminal ou exécutez: source ~/.bashrc"
print_info "2. Pour Docker: vous devrez peut-être redémarrer votre session"
print_info "3. Testez vos installations:"

# Afficher les commandes de test selon ce qui a été installé
if [[ -f "install_nodejs.sh" ]]; then
    print_info "   📦 Node.js: node --version && npm --version"
fi
if [[ -f "install_python3.sh" ]]; then
    print_info "   🐍 Python: python3 --version && pip3 --version"
fi
if [[ -f "install_java_temurin.sh" ]]; then
    print_info "   ☕ Java: java -version && javac -version"
fi
if [[ -f "install_go.sh" ]]; then
    print_info "   🐹 Go: go version"
fi
if [[ -f "install_rust.sh" ]]; then
    print_info "   🦀 Rust: rustc --version && cargo --version"
fi
if [[ -f "install_cpp.sh" ]]; then
    print_info "   ⚙️  C++: g++ --version && clang++ --version"
fi
if [[ -f "install_docker.sh" ]]; then
    print_info "   🐳 Docker: docker --version && docker compose version"
fi

print_info ""
print_cyan "📚 Ressources utiles:"
print_cyan "• Documentation officielle de chaque langage"
print_cyan "• VS Code avec extensions pour chaque langage"
print_cyan "• Git pour le versioning: sudo apt install git"

print_warning "⚠️  Note: Certains outils (C#, Kotlin, Solidity, R) nécessitent des scripts séparés"
print_info "Consultez la documentation pour ces langages spécifiques."

print_success "🚀 Votre environnement de développement est prêt!"
