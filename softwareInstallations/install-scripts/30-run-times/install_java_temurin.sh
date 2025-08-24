#!/bin/bash

# Script d'installation Java Eclipse Temurin pour Ubuntu 24.04
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

print_info "☕ Installation de Java Eclipse Temurin pour Ubuntu 24.04"
print_info "========================================================"

# Mettre à jour les packages système
print_info "Mise à jour des packages système..."
sudo apt update -y

# Installer les dépendances nécessaires
print_info "Installation des dépendances..."
sudo apt install -y wget apt-transport-https gpg software-properties-common

# Variables de configuration
JAVA_DEFAULT_VERSION="21"  # Version LTS recommandée
INSTALL_VERSIONS=("17" "21")  # Versions à installer

# Fonction pour installer via repository Adoptium
install_via_repository() {
    print_info "Installation via le repository Adoptium..."

    # Télécharger et ajouter la clé GPG Adoptium
    print_info "Ajout de la clé GPG Adoptium..."
    wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null

    # Ajouter le repository Adoptium
    print_info "Ajout du repository Adoptium..."
    echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list > /dev/null

    # Mettre à jour la liste des packages
    sudo apt update

    # Installer les versions Java spécifiées
    for version in "${INSTALL_VERSIONS[@]}"; do
        print_info "Installation de Temurin $version JDK..."
        sudo apt install -y temurin-${version}-jdk
    done

    return 0
}

# Fonction pour installation manuelle (fallback)
install_manually() {
    local version=$1
    print_info "Installation manuelle de Java $version..."

    # URLs pour les dernières versions
    case $version in
        17)
            DOWNLOAD_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.12%2B7/OpenJDK17U-jdk_x64_linux_hotspot_17.0.12_7.tar.gz"
            JAVA_DIR="jdk-17.0.12+7"
            ;;
        21)
            DOWNLOAD_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.4%2B7/OpenJDK21U-jdk_x64_linux_hotspot_21.0.4_7.tar.gz"
            JAVA_DIR="jdk-21.0.4+7"
            ;;
        *)
            print_error "Version Java $version non supportée pour l'installation manuelle"
            return 1
            ;;
    esac

    # Télécharger Java
    cd /tmp
    wget -O temurin-${version}.tar.gz "$DOWNLOAD_URL"

    # Extraire et installer
    tar -xzf temurin-${version}.tar.gz
    sudo mv "$JAVA_DIR" "/opt/java-${version}-temurin"

    # Nettoyer
    rm -f temurin-${version}.tar.gz

    print_success "Java $version installé manuellement dans /opt/java-${version}-temurin"
}

# Vérifier si Java est déjà installé
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -n1)
    print_warning "Java est déjà installé: $JAVA_VERSION"

    # Vérifier si c'est Temurin
    if java -version 2>&1 | grep -q "Temurin"; then
        print_success "Eclipse Temurin déjà installé"

        # Vérifier les mises à jour
        print_info "Vérification des mises à jour..."
        sudo apt update
        if sudo apt list --upgradable 2>/dev/null | grep -q temurin; then
            print_info "Mises à jour disponibles pour Temurin"
            sudo apt upgrade -y temurin-*
        else
            print_success "Temurin est à jour"
        fi
    else
        print_warning "Une autre version de Java est installée. Installation de Temurin en parallèle."
    fi
else
    print_info "Java non détecté. Installation de Eclipse Temurin..."
fi

# Essayer l'installation via repository, puis fallback manuel si échec
if ! install_via_repository; then
    print_warning "Installation via repository échouée. Tentative d'installation manuelle..."
    for version in "${INSTALL_VERSIONS[@]}"; do
        install_manually "$version"
    done
fi

# Configuration des alternatives Java (pour gérer plusieurs versions)
print_info "Configuration des alternatives Java..."

# Chercher les installations Temurin
TEMURIN_PATHS=(
    "/usr/lib/jvm/temurin-17-jdk-amd64"
    "/usr/lib/jvm/temurin-21-jdk-amd64"
    "/opt/java-17-temurin"
    "/opt/java-21-temurin"
)

PRIORITY=100
for java_path in "${TEMURIN_PATHS[@]}"; do
    if [[ -d "$java_path" && -f "$java_path/bin/java" ]]; then
        print_info "Configuration des alternatives pour $java_path..."
        sudo update-alternatives --install /usr/bin/java java "$java_path/bin/java" $PRIORITY
        sudo update-alternatives --install /usr/bin/javac javac "$java_path/bin/javac" $PRIORITY
        sudo update-alternatives --install /usr/bin/jar jar "$java_path/bin/jar" $PRIORITY
        ((PRIORITY+=10))
    fi
done

# Définir Java par défaut (version LTS récente)
for java_path in "${TEMURIN_PATHS[@]}"; do
    if [[ -d "$java_path" && "$java_path" =~ ${JAVA_DEFAULT_VERSION} ]]; then
        print_info "Définition de Java $JAVA_DEFAULT_VERSION comme version par défaut..."
        sudo update-alternatives --set java "$java_path/bin/java"
        sudo update-alternatives --set javac "$java_path/bin/javac"
        sudo update-alternatives --set jar "$java_path/bin/jar"

        # Configurer JAVA_HOME
        export JAVA_HOME="$java_path"
        echo "export JAVA_HOME=$java_path" | sudo tee /etc/environment > /dev/null

        # Ajouter au profil utilisateur
        if ! grep -q "JAVA_HOME" ~/.bashrc; then
            echo "export JAVA_HOME=$java_path" >> ~/.bashrc
            echo 'export PATH=$PATH:$JAVA_HOME/bin' >> ~/.bashrc
        fi

        break
    fi
done

# Vérifier l'installation finale
print_info "Vérification de l'installation..."
if command -v java &> /dev/null && command -v javac &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -n1)
    JAVAC_VERSION=$(javac -version 2>&1)

    print_success "✅ Java Eclipse Temurin installé avec succès!"
    print_success "Java Runtime: $JAVA_VERSION"
    print_success "Java Compiler: $JAVAC_VERSION"

    if [[ -n "$JAVA_HOME" ]]; then
        print_success "JAVA_HOME: $JAVA_HOME"
    fi

    # Afficher les versions disponibles
    print_info "Versions Java disponibles:"
    sudo update-alternatives --list java 2>/dev/null || echo "Commande alternatives non disponible"

else
    print_error "❌ Erreur lors de l'installation de Java"
    exit 1
fi

print_warning "⚠️  Pour utiliser JAVA_HOME immédiatement, exécutez:"
print_warning "source ~/.bashrc"
print_warning "ou redémarrez votre terminal."

print_info "📝 Commandes utiles:"
print_info "  java -version                              # Vérifier la version Java"
print_info "  javac -version                             # Vérifier la version du compilateur"
print_info "  sudo update-alternatives --config java     # Changer la version par défaut"
print_info "  echo \$JAVA_HOME                           # Afficher JAVA_HOME"
print_info "  java -cp . MyClass                         # Exécuter une classe Java"
print_info "  javac MyClass.java                         # Compiler un fichier Java"

print_info "📚 Versions installées:"
for version in "${INSTALL_VERSIONS[@]}"; do
    if [[ -d "/usr/lib/jvm/temurin-${version}-jdk-amd64" ]] || [[ -d "/opt/java-${version}-temurin" ]]; then
        print_info "  ✓ Temurin JDK $version"
    fi
done

print_success "🚀 Java Eclipse Temurin prêt pour le développement!"
