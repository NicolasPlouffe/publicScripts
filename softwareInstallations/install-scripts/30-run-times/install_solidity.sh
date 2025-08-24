#!/bin/bash

# Script d'installation Solidity pour Ubuntu 24.04
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

print_purple() {
    echo -e "${PURPLE}$1${NC}"
}

print_purple "⬟ Installation de Solidity pour Ubuntu 24.04"
print_purple "=============================================="

# Mettre à jour les packages système
print_info "Mise à jour des packages système..."
sudo apt update -y

# Installer les dépendances nécessaires
print_info "Installation des dépendances..."
sudo apt install -y software-properties-common curl wget gpg build-essential cmake git

# Méthode 1: Installation via PPA Ethereum (recommandée)
install_via_ppa() {
    print_info "Installation via PPA Ethereum (méthode recommandée)..."

    # Ajouter le PPA Ethereum
    sudo add-apt-repository -y ppa:ethereum/ethereum
    sudo apt update

    # Installer Solidity
    sudo apt install -y solc

    return 0
}

# Méthode 2: Installation via Snap
install_via_snap() {
    print_info "Installation via Snap..."

    # Installer la version stable
    sudo snap install solc

    return 0
}

# Méthode 3: Installation via npm (solc-js)
install_via_npm() {
    print_info "Installation de solc-js via npm..."

    # Vérifier si npm est disponible
    if ! command -v npm &> /dev/null; then
        print_warning "npm non trouvé. Installation de Node.js et npm..."
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi

    # Installer solc globalement via npm
    sudo npm install -g solc

    return 0
}

# Méthode 4: Compilation depuis les sources (pour les développeurs avancés)
install_from_source() {
    print_info "Compilation depuis les sources (méthode avancée)..."

    # Installer les dépendances de build
    sudo apt install -y build-essential cmake git libboost-all-dev

    # Cloner le repository
    cd /tmp
    git clone --recursive https://github.com/ethereum/solidity.git
    cd solidity

    # Créer le répertoire de build
    mkdir build
    cd build

    # Configurer et compiler
    cmake ..
    make -j$(nproc)

    # Installer
    sudo make install

    # Nettoyer
    cd ~
    rm -rf /tmp/solidity

    return 0
}

# Vérifier si Solidity est déjà installé
if command -v solc &> /dev/null; then
    SOLC_VERSION=$(solc --version 2>/dev/null | head -n1 || echo "Version inconnue")
    print_warning "Solidity est déjà installé: $SOLC_VERSION"

    # Vérifier les mises à jour si installé via apt
    if dpkg -l | grep -q solc; then
        print_info "Vérification des mises à jour..."
        sudo apt update
        if sudo apt list --upgradable 2>/dev/null | grep -q solc; then
            print_info "Mise à jour disponible pour Solidity"
            sudo apt upgrade -y solc
        else
            print_success "Solidity est à jour"
        fi
    fi

    print_success "✅ Solidity est déjà installé et fonctionnel!"
elif command -v solcjs &> /dev/null; then
    SOLCJS_VERSION=$(solcjs --version 2>/dev/null || echo "Version inconnue")
    print_warning "solc-js est déjà installé: $SOLCJS_VERSION"
    print_success "✅ Compilateur Solidity JavaScript déjà disponible!"
else
    print_info "Installation de Solidity..."

    # Essayer les méthodes d'installation dans l'ordre de préférence
    if install_via_ppa; then
        print_success "Installation via PPA Ethereum réussie"
    elif install_via_snap; then
        print_success "Installation via Snap réussie"  
    elif install_via_npm; then
        print_success "Installation via npm (solc-js) réussie"
    else
        print_error "Échec des installations standard. Tentative de compilation depuis les sources..."
        if install_from_source; then
            print_success "Compilation depuis les sources réussie"
        else
            print_error "Échec de toutes les méthodes d'installation"
            exit 1
        fi
    fi
fi

# Vérifier l'installation finale
print_info "Vérification de l'installation..."

SOLC_AVAILABLE=false
SOLCJS_AVAILABLE=false

if command -v solc &> /dev/null; then
    SOLC_VERSION_FINAL=$(solc --version 2>&1 | head -n1)
    print_success "✅ solc installé: $SOLC_VERSION_FINAL"
    SOLC_AVAILABLE=true
fi

if command -v solcjs &> /dev/null; then
    SOLCJS_VERSION_FINAL=$(solcjs --version 2>&1)
    print_success "✅ solc-js installé: $SOLCJS_VERSION_FINAL"
    SOLCJS_AVAILABLE=true
fi

if [[ "$SOLC_AVAILABLE" == false && "$SOLCJS_AVAILABLE" == false ]]; then
    print_error "❌ Aucun compilateur Solidity trouvé"
    exit 1
fi

# Créer un projet de test
print_info "Création d'un projet de test Solidity..."
TEST_DIR="$HOME/solidity-test"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Créer un smart contract de test simple
cat > HelloWorld.sol << 'EOF'
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title HelloWorld
 * @dev Un smart contract Solidity simple pour tester l'installation
 */
contract HelloWorld {
    string private message;
    address public owner;

    // Event émis quand le message change
    event MessageChanged(string newMessage, address changedBy);

    // Constructeur
    constructor(string memory _initialMessage) {
        message = _initialMessage;
        owner = msg.sender;
    }

    // Fonction pour récupérer le message
    function getMessage() public view returns (string memory) {
        return message;
    }

    // Fonction pour changer le message (seulement le propriétaire)
    function setMessage(string memory _newMessage) public {
        require(msg.sender == owner, "Seul le proprietaire peut changer le message");
        message = _newMessage;
        emit MessageChanged(_newMessage, msg.sender);
    }

    // Fonction pour obtenir l'adresse du propriétaire
    function getOwner() public view returns (address) {
        return owner;
    }
}
EOF

# Créer un contrat plus avancé
cat > Counter.sol << 'EOF'
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Counter
 * @dev Un compteur simple avec fonctionnalités avancées
 */
contract Counter {
    uint256 private count;
    mapping(address => uint256) public userCounts;

    event CountIncremented(uint256 newCount, address user);
    event CountDecremented(uint256 newCount, address user);
    event CountReset(address user);

    constructor() {
        count = 0;
    }

    function increment() public {
        count++;
        userCounts[msg.sender]++;
        emit CountIncremented(count, msg.sender);
    }

    function decrement() public {
        require(count > 0, "Le compteur ne peut pas etre negatif");
        count--;
        emit CountDecremented(count, msg.sender);
    }

    function getCount() public view returns (uint256) {
        return count;
    }

    function getUserCount(address user) public view returns (uint256) {
        return userCounts[user];
    }

    function reset() public {
        count = 0;
        emit CountReset(msg.sender);
    }
}
EOF

# Compiler les contrats de test
print_info "Test de compilation des smart contracts..."

if [[ "$SOLC_AVAILABLE" == true ]]; then
    print_info "Test avec solc (compilateur natif)..."
    if solc --bin --abi --optimize -o build HelloWorld.sol Counter.sol; then
        print_success "✅ Compilation avec solc réussie!"
        print_info "📁 Fichiers générés dans: build/"
        ls -la build/ 2>/dev/null || true
    else
        print_warning "⚠️  Échec de la compilation avec solc"
    fi
fi

if [[ "$SOLCJS_AVAILABLE" == true ]]; then
    print_info "Test avec solcjs (compilateur JavaScript)..."
    if solcjs --bin --abi --optimize-runs 200 HelloWorld.sol Counter.sol; then
        print_success "✅ Compilation avec solcjs réussie!"
        print_info "📁 Fichiers générés:"
        ls -la *_sol_*.* 2>/dev/null || true
    else
        print_warning "⚠️  Échec de la compilation avec solcjs"
    fi
fi

cd ~

print_success "✅ Installation de Solidity terminée avec succès!"

print_purple "📝 Commandes utiles:"
if [[ "$SOLC_AVAILABLE" == true ]]; then
    print_info "  solc --version                    # Vérifier la version"
    print_info "  solc --bin --abi Contract.sol     # Compiler un contrat"
    print_info "  solc --optimize Contract.sol      # Compiler avec optimisation"
    print_info "  solc --help                       # Voir toutes les options"
fi

if [[ "$SOLCJS_AVAILABLE" == true ]]; then
    print_info "  solcjs --version                  # Vérifier la version solc-js"
    print_info "  solcjs --bin Contract.sol         # Compiler avec solc-js"
    print_info "  solcjs --abi Contract.sol         # Générer l'ABI"
fi

print_purple "🏗️  Développement Solidity:"
print_info "  📝 Éditeurs recommandés:"
print_info "    - VS Code avec extension Solidity"
print_info "    - Remix IDE (en ligne: remix.ethereum.org)"
print_info "    - Hardhat ou Truffle pour les projets complexes"

print_info "  🔧 Frameworks de développement:"
print_info "    - Hardhat (framework moderne recommandé)"
print_info "    - Truffle Suite (framework classique)"
print_info "    - Foundry (outils rapides en Rust)"

print_info "  🌐 Réseaux de test:"
print_info "    - Ganache (blockchain locale)"
print_info "    - Sepolia Testnet (réseau de test Ethereum)"
print_info "    - Polygon Mumbai (réseau de test Polygon)"

print_purple "🔍 Outils d'analyse:"
print_info "  - Slither (analyse statique de sécurité)"
print_info "  - MythX (audit de sécurité)"
print_info "  - Echidna (fuzzing pour smart contracts)"

print_info "📁 Projet de test créé dans: $TEST_DIR"
print_success "🚀 Environnement Solidity prêt pour le développement blockchain!"

print_warning "💡 Conseil: Commencez par Remix IDE pour apprendre, puis passez à Hardhat pour les projets sérieux."
