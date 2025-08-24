# Mettre à jour le script principal pour inclure TOUS les langages
final_master_script = '''#!/bin/bash

# Script COMPLET d'installation pour Ubuntu 24.04
# Environnement de développement POLYGLOTTE
# Auteur: Générateur automatique  
# Date: $(date)

set -e  # Arrêter le script en cas d'erreur

# Couleurs pour les messages
RED='\\033[0;31m'
GREEN='\\033[0;32m'
YELLOW='\\033[1;33m'
BLUE='\\033[0;34m'
PURPLE='\\033[0;35m'
CYAN='\\033[0;36m'
WHITE='\\033[1;37m'
NC='\\033[0m' # No Color

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

print_white() {
    echo -e "${WHITE}$1${NC}"
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

# Banner principal
print_header "
╔═══════════════════════════════════════════════════════════════════════════════════╗
║                         INSTALLATION AUTOMATIQUE - UBUNTU 24.04                  ║
║                          ENVIRONNEMENT DE DÉVELOPPEMENT                          ║
║                                  POLYGLOTTE COMPLET                              ║
╚═══════════════════════════════════════════════════════════════════════════════════╝
"

print_white "🌟 STACK TECHNOLOGIQUE COMPLET - 18 LANGAGES ET OUTILS"
print_white "========================================================="
echo ""

print_cyan "🌐 FRONTEND & WEB:"
print_cyan "   • JavaScript + TypeScript    (Node.js, runtime moderne)"
print_cyan "   • React + Angular + Vite     (frameworks frontend)"
print_cyan "   • CSS + Tailwind CSS         (styling avancé)"
echo ""

print_cyan "🖥️  BACKEND & ENTERPRISE:"
print_cyan "   • Python3 + pip             (data science, web, AI/ML)"
print_cyan "   • Java Eclipse Temurin       (enterprise, microservices)"
print_cyan "   • C# (.NET SDK)              (Microsoft stack, cross-platform)"
print_cyan "   • Go (Golang)                (cloud native, performance)"
print_cyan "   • Rust + Cargo               (systems programming, safety)"
print_cyan "   • C++                        (performance critique, embedded)"
echo ""

print_cyan "📱 MOBILE & MULTIPLATFORM:"
print_cyan "   • Kotlin                     (Android, multiplatform JVM)"
echo ""

print_cyan "⛓️  BLOCKCHAIN & SMART CONTRACTS:"
print_cyan "   • Solidity                   (Ethereum, DeFi, Web3)"
echo ""

print_cyan "📊 DATA SCIENCE & STATISTICS:"
print_cyan "   • R + RStudio                (analyse statistique, visualisation)"
echo ""

print_cyan "🏗️  DEVOPS & INFRASTRUCTURE:"
print_cyan "   • Docker + Docker Compose   (containerisation)"
print_cyan "   • Kubernetes (kubectl)      (orchestration)"
echo ""

print_warning "💾 Espace disque recommandé: 8-12 GB pour l'installation complète"
print_warning "⏰ Temps d'installation estimé: 15-45 minutes selon votre connexion"
echo ""

# Vérifier les permissions sudo
print_info "Vérification des permissions sudo..."
if ! sudo -n true 2>/dev/null; then
    print_warning "Ce script nécessite des permissions sudo. Vous pourriez être invité à saisir votre mot de passe."
    sudo -v
fi

print_success "Permissions sudo confirmées"
echo ""

# Menu principal étendu
print_header "🎯 CHOISISSEZ VOTRE INSTALLATION:"
echo ""
echo " 1)  🌟 INSTALLATION COMPLÈTE (18 langages - développeur polyglotte)"
echo " 2)  🌐 PACK FRONTEND (Node.js + React + Angular + Tailwind)"
echo " 3)  🖥️  PACK BACKEND (Python + Java + C# + Go + Rust)"
echo " 4)  📱 PACK MOBILE (Java + Kotlin + Node.js)"
echo " 5)  ⛓️  PACK BLOCKCHAIN (Node.js + Solidity + Go + Rust)"
echo " 6)  📊 PACK DATA SCIENCE (Python + R + C++ pour performance)"
echo " 7)  ⚡ PACK SYSTEMS (Rust + C++ + Go pour performance)"
echo " 8)  🏗️  PACK DEVOPS (Docker + Kubernetes + Go + Python)"
echo " 9)  🎛️  INSTALLATION PERSONNALISÉE (choisir individuellement)"
echo "10)  📋 VOIR TOUS LES SCRIPTS DISPONIBLES"
echo "11)  🧪 MODE TEST (installation rapide pour tests)"
echo "12)  ❌ QUITTER"
echo ""

read -p "Votre choix [1-12]: " choice

case $choice in
    1)
        print_header "🌟 INSTALLATION COMPLÈTE - 18 LANGAGES"
        print_info "Installation de l'environnement de développement polyglotte complet..."
        
        # Infrastructure de base
        run_script "install_docker.sh" "Docker + Docker Compose"
        
        # Langages web et frontend
        run_script "install_nodejs.sh" "Node.js + npm + outils frontend"
        
        # Langages backend et systems
        run_script "install_python3.sh" "Python3 + pip + data science"
        run_script "install_java_temurin.sh" "Java Eclipse Temurin OpenJDK"
        run_script "install_csharp.sh" "C# (.NET SDK)"
        run_script "install_go.sh" "Go (Golang)"
        run_script "install_rust.sh" "Rust + Cargo + outils"
        run_script "install_cpp.sh" "C++ + outils de développement"
        
        # Langages spécialisés
        run_script "install_kotlin.sh" "Kotlin (Android + multiplatform)"
        run_script "install_solidity.sh" "Solidity (blockchain)"
        run_script "install_r.sh" "R (statistiques + data science)"
        
        # Installation des outils frontend après Node.js
        print_info "Installation des outils frontend globaux..."
        source ~/.bashrc 2>/dev/null || true
        npm install -g create-react-app @angular/cli @vitejs/create-vue tailwindcss typescript || print_warning "Certains outils frontend n'ont pas pu être installés"
        ;;
        
    2)
        print_header "🌐 PACK FRONTEND"
        run_script "install_nodejs.sh" "Node.js + npm"
        print_info "Installation des frameworks frontend..."
        source ~/.bashrc 2>/dev/null || true
        npm install -g create-react-app @angular/cli @vitejs/create-vue tailwindcss typescript
        ;;
        
    3)
        print_header "🖥️  PACK BACKEND"
        run_script "install_python3.sh" "Python3 + pip"
        run_script "install_java_temurin.sh" "Java Eclipse Temurin"
        run_script "install_csharp.sh" "C# (.NET SDK)"
        run_script "install_go.sh" "Go (Golang)"
        run_script "install_rust.sh" "Rust + Cargo"
        ;;
        
    4)
        print_header "📱 PACK MOBILE"
        run_script "install_java_temurin.sh" "Java Eclipse Temurin (requis pour Kotlin)"
        run_script "install_kotlin.sh" "Kotlin (Android development)"
        run_script "install_nodejs.sh" "Node.js (React Native, Ionic)"
        ;;
        
    5)
        print_header "⛓️  PACK BLOCKCHAIN"
        run_script "install_nodejs.sh" "Node.js (Web3, frameworks JS)"
        run_script "install_solidity.sh" "Solidity (smart contracts)"
        run_script "install_go.sh" "Go (blockchain backends)"
        run_script "install_rust.sh" "Rust (blockchain performance)"
        ;;
        
    6)
        print_header "📊 PACK DATA SCIENCE"
        run_script "install_python3.sh" "Python3 (pandas, numpy, sklearn)"
        run_script "install_r.sh" "R + RStudio (statistiques)"
        run_script "install_cpp.sh" "C++ (calculs haute performance)"
        ;;
        
    7)
        print_header "⚡ PACK SYSTEMS"
        run_script "install_rust.sh" "Rust (sécurité mémoire)"
        run_script "install_cpp.sh" "C++ (performance maximale)"
        run_script "install_go.sh" "Go (concurrence, networking)"
        ;;
        
    8)
        print_header "🏗️  PACK DEVOPS"
        run_script "install_docker.sh" "Docker + Docker Compose"
        run_script "install_go.sh" "Go (outils DevOps)"
        run_script "install_python3.sh" "Python3 (automation, Ansible)"
        
        # Installation de kubectl
        print_info "Installation de kubectl..."
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
        rm kubectl
        print_success "kubectl installé"
        ;;
        
    9)
        print_header "🎛️  INSTALLATION PERSONNALISÉE"
        
        print_info "🏗️  Infrastructure:"
        read -p "   Installer Docker + Docker Compose? [y/N]: " install_docker
        if [[ "$install_docker" =~ ^[Yy]$ ]]; then
            run_script "install_docker.sh" "Docker + Docker Compose"
        fi
        
        print_info "🌐 Frontend & Web:"
        read -p "   Installer Node.js + npm + outils frontend? [y/N]: " install_node
        if [[ "$install_node" =~ ^[Yy]$ ]]; then
            run_script "install_nodejs.sh" "Node.js + npm"
        fi
        
        print_info "🖥️  Backend & Enterprise:"
        read -p "   Installer Python3 + pip? [y/N]: " install_python
        if [[ "$install_python" =~ ^[Yy]$ ]]; then
            run_script "install_python3.sh" "Python3 + pip"
        fi
        
        read -p "   Installer Java Eclipse Temurin? [y/N]: " install_java
        if [[ "$install_java" =~ ^[Yy]$ ]]; then
            run_script "install_java_temurin.sh" "Java Eclipse Temurin"
        fi
        
        read -p "   Installer C# (.NET SDK)? [y/N]: " install_csharp
        if [[ "$install_csharp" =~ ^[Yy]$ ]]; then
            run_script "install_csharp.sh" "C# (.NET SDK)"
        fi
        
        read -p "   Installer Go (Golang)? [y/N]: " install_go
        if [[ "$install_go" =~ ^[Yy]$ ]]; then
            run_script "install_go.sh" "Go (Golang)"
        fi
        
        read -p "   Installer Rust? [y/N]: " install_rust
        if [[ "$install_rust" =~ ^[Yy]$ ]]; then
            run_script "install_rust.sh" "Rust"
        fi
        
        read -p "   Installer C++ + outils? [y/N]: " install_cpp
        if [[ "$install_cpp" =~ ^[Yy]$ ]]; then
            run_script "install_cpp.sh" "C++ + outils"
        fi
        
        print_info "📱 Mobile & Spécialisé:"
        read -p "   Installer Kotlin? [y/N]: " install_kotlin
        if [[ "$install_kotlin" =~ ^[Yy]$ ]]; then
            run_script "install_kotlin.sh" "Kotlin"
        fi
        
        read -p "   Installer Solidity (blockchain)? [y/N]: " install_solidity
        if [[ "$install_solidity" =~ ^[Yy]$ ]]; then
            run_script "install_solidity.sh" "Solidity"
        fi
        
        read -p "   Installer R (statistiques)? [y/N]: " install_r
        if [[ "$install_r" =~ ^[Yy]$ ]]; then
            run_script "install_r.sh" "R + RStudio"
        fi
        ;;
        
    10)
        print_header "📋 SCRIPTS DISPONIBLES:"
        echo ""
        ls -la *.sh | grep -E "install_" | while read -r line; do
            script_name=$(echo "$line" | awk '{print $9}')
            case $script_name in
                install_nodejs.sh) echo "  📜 $script_name - Node.js + npm + outils frontend" ;;
                install_python3.sh) echo "  📜 $script_name - Python3 + pip + outils dev" ;;
                install_java_temurin.sh) echo "  📜 $script_name - Java Eclipse Temurin OpenJDK" ;;
                install_csharp.sh) echo "  📜 $script_name - C# (.NET SDK) multiplateforme" ;;
                install_go.sh) echo "  📜 $script_name - Go (Golang) dernière version" ;;
                install_rust.sh) echo "  📜 $script_name - Rust + Cargo + outils" ;;
                install_cpp.sh) echo "  📜 $script_name - C++ + GCC + Clang + CMake" ;;
                install_kotlin.sh) echo "  📜 $script_name - Kotlin + SDKMAN + outils" ;;
                install_solidity.sh) echo "  📜 $script_name - Solidity + compilateurs blockchain" ;;
                install_r.sh) echo "  📜 $script_name - R + RStudio + packages essentiels" ;;
                install_docker.sh) echo "  📜 $script_name - Docker + Docker Compose" ;;
                *) echo "  📜 $script_name" ;;
            esac
        done
        echo ""
        print_info "💡 Pour exécuter un script individuellement: ./nom_du_script.sh"
        exit 0
        ;;
        
    11)
        print_header "🧪 MODE TEST (Installation rapide)"
        print_info "Installation des outils les plus essentiels pour tests..."
        run_script "install_nodejs.sh" "Node.js (essentiel web)"
        run_script "install_python3.sh" "Python3 (essentiel data/backend)"
        run_script "install_docker.sh" "Docker (essentiel DevOps)"
        ;;
        
    12)
        print_info "Installation annulée"
        exit 0
        ;;
        
    *)
        print_error "Choix invalide"
        exit 1
        ;;
esac

print_header "
╔═══════════════════════════════════════════════════════════════════════════════════╗
║                              INSTALLATION TERMINÉE                               ║
║                           ENVIRONNEMENT POLYGLOTTE PRÊT                          ║
╚═══════════════════════════════════════════════════════════════════════════════════╝
"

print_success "🎉 Installation terminée avec succès!"
echo ""

print_white "🔄 PROCHAINES ÉTAPES RECOMMANDÉES:"
print_info "1. Redémarrez votre terminal ou exécutez: source ~/.bashrc"
print_info "2. Pour Docker: redémarrez votre session utilisateur"
print_info "3. Testez vos installations avec les commandes ci-dessous"
echo ""

print_white "🧪 COMMANDES DE TEST:"
print_cyan "Frontend & Web:"
print_info "  node --version && npm --version"
print_info "  npx create-react-app --version"
echo ""

print_cyan "Backend & Systems:"
print_info "  python3 --version && pip3 --version"
print_info "  java -version && javac -version"
print_info "  dotnet --version"
print_info "  go version"
print_info "  rustc --version && cargo --version"
print_info "  g++ --version && clang++ --version"
echo ""

print_cyan "Spécialisés:"
print_info "  kotlin -version"
print_info "  solc --version || solcjs --version"
print_info "  R --version"
echo ""

print_cyan "DevOps:"
print_info "  docker --version && docker compose version"
print_info "  kubectl version --client"
echo ""

print_white "📚 RESSOURCES UTILES:"
print_cyan "• Documentation officielle de chaque langage"
print_cyan "• VS Code avec extensions pour tous les langages"
print_cyan "• JetBrains IDEs (IntelliJ, PyCharm, WebStorm, Rider)"
print_cyan "• Git pour le versioning: sudo apt install git"
echo ""

print_white "🗂️  PROJETS DE TEST CRÉÉS:"
print_info "  ~/nodejs-test/     (Node.js + JavaScript/TypeScript)"
print_info "  ~/python-test/     (Python3 + packages)"
print_info "  ~/java-test/       (Java avec exemples)"
print_info "  ~/csharp-test/     (C# .NET exemples)"
print_info "  ~/go/              (Go workspace)"
print_info "  ~/cpp-test/        (C++ projets exemple)"
print_info "  ~/kotlin-test/     (Kotlin exemples)"
print_info "  ~/solidity-test/   (Smart contracts)"
print_info "  ~/r-test/          (Scripts R et analyses)"
echo ""

print_header "🚀 VOTRE ENVIRONNEMENT POLYGLOTTE EST PRÊT!"
print_white "Vous pouvez maintenant développer en 18+ langages et technologies différentes!"
'''

with open('install_complete_dev_stack.sh', 'w') as f:
    f.write(final_master_script)

# Rendre tous les scripts exécutables
import os
all_scripts = [
    'install_complete_dev_stack.sh',
    'install_dev_environment.sh',
    'install_base.sh', 
    'install_nodejs.sh', 
    'install_python3.sh', 
    'install_docker.sh',
    'install_go.sh',
    'install_rust.sh', 
    'install_java_temurin.sh',
    'install_cpp.sh',
    'install_csharp.sh',
    'install_kotlin.sh',
    'install_solidity.sh',
    'install_r.sh'
]

for script in all_scripts:
    if os.path.exists(script):
        os.chmod(script, 0o755)

print("🎉 SCRIPTS D'INSTALLATION COMPLETS CRÉÉS!")
print("=" * 55)
print()
print("📦 TOUS LES SCRIPTS GÉNÉRÉS ET RENDUS EXÉCUTABLES:")
for script in all_scripts:
    if os.path.exists(script):
        print(f"  ✅ {script}")

print()
print("🚀 COMMANDES PRINCIPALES:")
print("  ./install_complete_dev_stack.sh    # Script COMPLET (18+ langages)")
print("  ./install_dev_environment.sh       # Version précédente (7 langages)")
print()
print("📜 SCRIPTS INDIVIDUELS:")
individual_scripts = [s for s in all_scripts if s.startswith('install_') and s not in ['install_complete_dev_stack.sh', 'install_dev_environment.sh', 'install_base.sh']]
for script in individual_scripts:
    if os.path.exists(script):
        lang = script.replace('install_', '').replace('.sh', '').replace('_', ' ').title()
        print(f"  ./{script:<30} # {lang}")

print()
print("🌟 STACK TECHNOLOGIQUE FINAL COUVERT:")
print("  🌐 Frontend: JavaScript, TypeScript, React, Angular, Vite, CSS, Tailwind")
print("  🖥️  Backend: Python3, Java, C#, Go, Rust, C++")  
print("  📱 Mobile: Kotlin")
print("  ⛓️  Blockchain: Solidity") 
print("  📊 Data: R + RStudio")
print("  🏗️  DevOps: Docker, Kubernetes")
print()
print("🎯 VOUS AVEZ MAINTENANT UN ENVIRONNEMENT DE DÉVELOPPEMENT")
print("   POLYGLOTTE COMPLET POUR UBUNTU 24.04! 🚀")