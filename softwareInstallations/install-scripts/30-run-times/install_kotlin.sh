#!/bin/bash

# Script d'installation Kotlin pour Ubuntu 24.04
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

print_info "🟣 Installation de Kotlin pour Ubuntu 24.04"
print_info "=========================================="

# Mettre à jour les packages système
print_info "Mise à jour des packages système..."
sudo apt update -y

# Installer les dépendances nécessaires
print_info "Installation des dépendances..."
sudo apt install -y curl unzip zip wget software-properties-common

# Méthode 1: Installation via SDKMAN (recommandée)
install_via_sdkman() {
    print_info "Installation via SDKMAN (méthode recommandée)..."

    # Vérifier si SDKMAN est déjà installé
    if [[ ! -d "$HOME/.sdkman" ]]; then
        print_info "Installation de SDKMAN..."
        curl -s "https://get.sdkman.io" | bash
        source "$HOME/.sdkman/bin/sdkman-init.sh"
    else
        print_warning "SDKMAN est déjà installé"
        source "$HOME/.sdkman/bin/sdkman-init.sh"
    fi

    # Installer Kotlin via SDKMAN
    print_info "Installation de Kotlin via SDKMAN..."
    sdk install kotlin

    return 0
}

# Méthode 2: Installation via Snap
install_via_snap() {
    print_info "Installation via Snap..."

    sudo snap install kotlin --classic

    return 0
}

# Méthode 3: Installation manuelle
install_manually() {
    print_info "Installation manuelle de Kotlin..."

    # Télécharger la dernière version
    KOTLIN_VERSION="2.1.0"  # Version récente stable
    KOTLIN_URL="https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip"

    cd /tmp
    wget -O kotlin-compiler.zip "$KOTLIN_URL"

    # Extraire et installer
    unzip kotlin-compiler.zip
    sudo mv kotlinc /opt/kotlin

    # Configurer les variables d'environnement
    sudo tee /etc/profile.d/kotlin.sh > /dev/null <<EOF
export KOTLIN_HOME=/opt/kotlin
export PATH=\$PATH:\$KOTLIN_HOME/bin
EOF

    # Ajouter au profil utilisateur
    if ! grep -q "KOTLIN_HOME" ~/.bashrc; then
        echo 'export KOTLIN_HOME=/opt/kotlin' >> ~/.bashrc
        echo 'export PATH=$PATH:$KOTLIN_HOME/bin' >> ~/.bashrc
    fi

    # Charger les variables pour la session actuelle
    export KOTLIN_HOME=/opt/kotlin
    export PATH=$PATH:$KOTLIN_HOME/bin

    # Nettoyer
    rm -f kotlin-compiler.zip

    return 0
}

# Vérifier si Java est installé (requis pour Kotlin)
if ! command -v java &> /dev/null; then
    print_info "Java n'est pas installé. Installation de OpenJDK..."
    sudo apt install -y openjdk-17-jre-headless openjdk-17-jdk-headless

    # Vérifier l'installation de Java
    if command -v java &> /dev/null; then
        JAVA_VERSION=$(java -version 2>&1 | head -n1)
        print_success "Java installé: $JAVA_VERSION"
    else
        print_error "Échec de l'installation de Java"
        exit 1
    fi
else
    JAVA_VERSION=$(java -version 2>&1 | head -n1)
    print_success "Java déjà installé: $JAVA_VERSION"
fi

# Vérifier si Kotlin est déjà installé
if command -v kotlin &> /dev/null; then
    KOTLIN_VERSION_INSTALLED=$(kotlin -version 2>&1 | head -n1 || echo "Version inconnue")
    print_warning "Kotlin est déjà installé: $KOTLIN_VERSION_INSTALLED"

    # Proposer de mettre à jour via SDKMAN si possible
    if [[ -d "$HOME/.sdkman" ]] && command -v sdk &> /dev/null; then
        print_info "Mise à jour de Kotlin via SDKMAN..."
        source "$HOME/.sdkman/bin/sdkman-init.sh"
        sdk update
        sdk upgrade kotlin
    fi

    print_success "✅ Kotlin est déjà installé et fonctionnel!"
else
    print_info "Installation de Kotlin..."

    # Essayer les méthodes d'installation dans l'ordre de préférence
    if install_via_sdkman; then
        print_success "Installation via SDKMAN réussie"
        source "$HOME/.sdkman/bin/sdkman-init.sh"
    elif install_via_snap; then
        print_success "Installation via Snap réussie"
    elif install_manually; then
        print_success "Installation manuelle réussie"
    else
        print_error "Échec de toutes les méthodes d'installation"
        exit 1
    fi
fi

# Recharger l'environnement si nécessaire
if [[ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Vérifier l'installation finale
print_info "Vérification de l'installation..."
if command -v kotlin &> /dev/null && command -v kotlinc &> /dev/null; then
    KOTLIN_VERSION_FINAL=$(kotlin -version 2>&1 | head -n1)
    KOTLINC_VERSION=$(kotlinc -version 2>&1 | head -n1)

    print_success "✅ Kotlin installé avec succès!"
    print_success "Runtime: $KOTLIN_VERSION_FINAL"
    print_success "Compiler: $KOTLINC_VERSION"

else
    print_error "❌ Erreur lors de l'installation de Kotlin"
    exit 1
fi

# Créer un projet de test
print_info "Création d'un projet de test Kotlin..."
TEST_DIR="$HOME/kotlin-test"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Créer un fichier Kotlin de test
cat > Hello.kt << 'EOF'
// Exemple Kotlin avec diverses fonctionnalités
fun main() {
    println("🟣 Hello, Kotlin!")
    println("===================")

    // Variables et types
    val name: String = "Développeur Kotlin"
    val numbers = listOf(1, 2, 3, 4, 5)

    // Fonctions d'ordre supérieur et lambda
    val evenNumbers = numbers.filter { it % 2 == 0 }
    println("Nombres pairs: ${evenNumbers.joinToString(", ")}")

    // Classes de données
    data class Person(val name: String, val age: Int)
    val developer = Person("Alice", 30)
    println("👩‍💻 Développeur: ${developer.name}, âge: ${developer.age}")

    // Extension functions
    fun String.addEmoji() = "✨ $this ✨"
    println("Message stylé".addEmoji())

    // Null safety
    val nullableString: String? = "Kotlin est génial"
    nullableString?.let { println("📝 $it") }

    println("✅ Test Kotlin terminé avec succès!")
}
EOF

# Compiler et exécuter le programme de test
print_info "Compilation et exécution du test..."
if kotlinc Hello.kt -include-runtime -d hello.jar && java -jar hello.jar; then
    print_success "✅ Test d'exécution réussi!"
else
    print_warning "⚠️  Échec du test d'exécution"
fi

cd ~

print_success "✅ Installation de Kotlin terminée avec succès!"

print_info "📝 Commandes utiles:"
print_info "  kotlin -version                      # Vérifier la version du runtime"
print_info "  kotlinc -version                     # Vérifier la version du compilateur"
print_info "  kotlinc hello.kt -include-runtime -d hello.jar  # Compiler en JAR"
print_info "  kotlin hello.kt                      # Exécuter directement (script mode)"
print_info "  java -jar hello.jar                  # Exécuter le JAR compilé"

print_info "🎯 Types de projets Kotlin:"
print_info "  📱 Android    # Applications mobiles Android"
print_info "  🖥️  JVM       # Applications serveur et desktop"
print_info "  🌐 JS/WASM   # Applications web et WebAssembly"  
print_info "  🔧 Native    # Applications natives multiplaform"

if [[ -d "$HOME/.sdkman" ]]; then
    print_info "🔧 Commandes SDKMAN utiles:"
    print_info "  sdk list kotlin                     # Lister les versions disponibles"
    print_info "  sdk install kotlin <version>        # Installer une version spécifique"
    print_info "  sdk use kotlin <version>             # Utiliser une version temporairement"
    print_info "  sdk default kotlin <version>        # Définir une version par défaut"
fi

print_info "📁 Projet de test créé dans: $TEST_DIR"
print_success "🚀 Environnement Kotlin prêt pour le développement!"

print_info "🔧 Outils recommandés:"
print_info "  - IntelliJ IDEA (IDE officiel JetBrains)"
print_info "  - VS Code avec extension Kotlin"
print_info "  - Android Studio (pour développement mobile)"

print_warning "⚠️  Pour utiliser Kotlin immédiatement, vous devrez peut-être:"
print_warning "source ~/.bashrc"
print_warning "ou redémarrer votre terminal."
