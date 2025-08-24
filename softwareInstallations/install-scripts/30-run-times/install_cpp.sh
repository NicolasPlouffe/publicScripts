#!/bin/bash

# Script d'installation C++ et outils de build pour Ubuntu 24.04
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

print_info "⚙️  Installation de C++ et outils de développement pour Ubuntu 24.04"
print_info "=================================================================="

# Mettre à jour les packages système
print_info "Mise à jour des packages système..."
sudo apt update -y

# Installer le meta-package build-essential (inclut gcc, g++, make, etc.)
print_info "Installation de build-essential (GCC, G++, Make)..."
sudo apt install -y build-essential

# Installer des outils de développement additionnels
print_info "Installation d'outils de développement C++ additionnels..."
sudo apt install -y \
    gcc-multilib \
    g++-multilib \
    gdb \
    valgrind \
    cmake \
    ninja-build \
    pkg-config \
    autotools-dev \
    automake \
    autoconf \
    libtool \
    libboost-all-dev \
    libeigen3-dev \
    git \
    clang \
    clang-format \
    clang-tidy \
    lldb

# Installer des bibliothèques de développement utiles
print_info "Installation de bibliothèques de développement..."
sudo apt install -y \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncurses5-dev \
    libgdbm-dev \
    liblzma-dev \
    libffi-dev

# Vérifier les installations
print_info "Vérification des installations..."

# Vérifier GCC
if command -v gcc &> /dev/null; then
    GCC_VERSION=$(gcc --version | head -n1)
    print_success "GCC: $GCC_VERSION"
else
    print_error "❌ GCC non installé"
fi

# Vérifier G++
if command -v g++ &> /dev/null; then
    GPP_VERSION=$(g++ --version | head -n1)
    print_success "G++: $GPP_VERSION"
else
    print_error "❌ G++ non installé"
fi

# Vérifier Make
if command -v make &> /dev/null; then
    MAKE_VERSION=$(make --version | head -n1)
    print_success "Make: $MAKE_VERSION"
else
    print_error "❌ Make non installé"
fi

# Vérifier CMake
if command -v cmake &> /dev/null; then
    CMAKE_VERSION=$(cmake --version | head -n1)
    print_success "CMake: $CMAKE_VERSION"
else
    print_warning "⚠️  CMake non installé"
fi

# Vérifier Clang
if command -v clang &> /dev/null; then
    CLANG_VERSION=$(clang --version | head -n1)
    print_success "Clang: $CLANG_VERSION"
else
    print_warning "⚠️  Clang non installé"
fi

# Vérifier GDB
if command -v gdb &> /dev/null; then
    GDB_VERSION=$(gdb --version | head -n1)
    print_success "GDB: $GDB_VERSION"
else
    print_warning "⚠️  GDB non installé"
fi

# Vérifier Valgrind
if command -v valgrind &> /dev/null; then
    VALGRIND_VERSION=$(valgrind --version)
    print_success "Valgrind: $VALGRIND_VERSION"
else
    print_warning "⚠️  Valgrind non installé"
fi

# Créer un projet de test simple
print_info "Création d'un projet de test C++..."
mkdir -p ~/cpp-test
cat > ~/cpp-test/hello.cpp << 'EOF'
#include <iostream>
#include <vector>
#include <string>

int main() {
    std::vector<std::string> messages = {
        "Hello, C++!",
        "Build tools installed successfully!",
        "Ready for development!"
    };

    for (const auto& msg : messages) {
        std::cout << msg << std::endl;
    }

    return 0;
}
EOF

# Créer un Makefile simple
cat > ~/cpp-test/Makefile << 'EOF'
CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -O2
TARGET = hello
SOURCE = hello.cpp

$(TARGET): $(SOURCE)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(SOURCE)

clean:
	rm -f $(TARGET)

.PHONY: clean
EOF

# Créer un CMakeLists.txt
cat > ~/cpp-test/CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.10)
project(HelloCpp)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(hello hello.cpp)
EOF

print_info "Test de compilation avec G++..."
cd ~/cpp-test
if g++ -std=c++17 -Wall -Wextra -o hello hello.cpp; then
    print_success "✅ Compilation réussie avec G++!"
    if ./hello; then
        print_success "✅ Exécution réussie!"
    fi
else
    print_error "❌ Échec de la compilation"
fi

print_info "Test de compilation avec Make..."
if make clean && make; then
    print_success "✅ Compilation réussie avec Make!"
else
    print_warning "⚠️  Échec de la compilation avec Make"
fi

print_info "Test de compilation avec CMake..."
mkdir -p build && cd build
if cmake .. && make; then
    print_success "✅ Compilation réussie avec CMake!"
else
    print_warning "⚠️  Échec de la compilation avec CMake"
fi

cd ~

print_success "✅ Installation des outils C++ terminée avec succès!"

print_info "📝 Outils installés:"
print_info "  🔧 Compilateurs:"
print_info "    - GCC (GNU Compiler Collection)"
print_info "    - G++ (GNU C++ Compiler)" 
print_info "    - Clang (LLVM C/C++ Compiler)"
print_info "  🔨 Outils de build:"
print_info "    - Make (build automation)"
print_info "    - CMake (cross-platform build system)"
print_info "    - Ninja (small build system)"
print_info "  🐛 Débogage:"
print_info "    - GDB (GNU Debugger)"
print_info "    - LLDB (LLVM Debugger)"
print_info "    - Valgrind (memory debugging)"
print_info "  📚 Bibliothèques:"
print_info "    - Boost (C++ libraries)"
print_info "    - Eigen3 (linear algebra)"
print_info "    - OpenSSL (cryptography)"

print_info "📝 Commandes utiles:"
print_info "  g++ -std=c++17 -o prog prog.cpp    # Compiler avec G++"
print_info "  clang++ -std=c++17 -o prog prog.cpp # Compiler avec Clang++"
print_info "  make                                # Build avec Makefile"
print_info "  cmake . && make                     # Build avec CMake"
print_info "  gdb ./prog                          # Déboguer avec GDB"
print_info "  valgrind ./prog                     # Analyser la mémoire"
print_info "  clang-format -i *.cpp               # Formater le code"

print_info "📁 Projet de test créé dans: ~/cpp-test"
print_success "🚀 Environnement C++ prêt pour le développement!"
