#!/bin/bash

# Script d'installation C# (.NET SDK) pour Ubuntu 24.04 (VERSION CORRIGÉE)
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

print_info "🔷 Installation de C# (.NET SDK) pour Ubuntu 24.04 (CORRIGÉE)"
print_info "==========================================================="

# Mettre à jour les packages système
print_info "Mise à jour des packages système..."
sudo apt update -y

# Installer les dépendances nécessaires
print_info "Installation des dépendances..."
sudo apt install -y wget curl gpg software-properties-common apt-transport-https

# Variables
DOTNET_VERSION="8.0"  # Version LTS actuelle

# Vérifier si .NET est déjà installé
if command -v dotnet &> /dev/null; then
    DOTNET_VERSION_INSTALLED=$(dotnet --version 2>/dev/null || echo "Unknown")
    print_warning ".NET est déjà installé: $DOTNET_VERSION_INSTALLED"

    # Vérifier si on peut afficher les informations
    print_info "Informations .NET installé:"
    dotnet --info | head -20 || print_warning "Impossible d'afficher les infos .NET"

    # Éviter les mises à jour problématiques avec les conflits de packages
    print_warning "Évitement des mises à jour automatiques pour éviter les conflits de dépendances"
    print_success ".NET est fonctionnel, pas de mise à jour forcée"

else
    print_info "Installation de .NET..."

    # Méthode préférée: Installation via snap (évite les conflits de dépendances)
    if install_via_snap; then
        print_success "Installation via Snap réussie"
    # Méthode alternative: Script Microsoft
    elif install_via_microsoft_script; then
        print_success "Installation via script Microsoft réussie"
    else
        print_error "Échec de toutes les méthodes d'installation"
        exit 1
    fi
fi

# Fonction pour installation via Snap (recommandée pour éviter les conflits)
install_via_snap() {
    print_info "Installation via Snap (évite les conflits de dépendances)..."

    if sudo snap install dotnet-sdk --classic --channel=8.0; then
        # Créer un lien symbolique si nécessaire
        if [[ ! -f "/usr/bin/dotnet" ]]; then
            sudo ln -sf /snap/bin/dotnet-sdk.dotnet /usr/bin/dotnet || true
        fi
        return 0
    else
        return 1
    fi
}

# Fonction pour installation via script Microsoft (fallback)
install_via_microsoft_script() {
    print_info "Installation via le script Microsoft..."

    # Télécharger et exécuter le script d'installation Microsoft
    wget -O install-dotnet.sh https://dot.net/v1/dotnet-install.sh
    chmod +x install-dotnet.sh

    # Installer la dernière version LTS
    ./install-dotnet.sh --channel LTS --install-dir $HOME/.dotnet

    # Configurer les variables d'environnement
    export PATH="$PATH:$HOME/.dotnet"
    if ! grep -q "dotnet" ~/.bashrc; then
        echo 'export PATH="$PATH:$HOME/.dotnet"' >> ~/.bashrc
    fi

    # Nettoyer
    rm install-dotnet.sh

    return 0
}

# Si .NET n'était pas installé, l'installer maintenant
if ! command -v dotnet &> /dev/null; then
    # Essayer Snap en premier
    if command -v snap &> /dev/null; then
        install_via_snap || install_via_microsoft_script
    else
        install_via_microsoft_script
    fi
fi

# Vérifier l'installation finale
print_info "Vérification de l'installation..."
if command -v dotnet &> /dev/null; then
    DOTNET_VERSION_FINAL=$(dotnet --version 2>/dev/null || echo "Installé mais version indéterminée")

    print_success "✅ .NET SDK installé avec succès!"
    print_success "Version: $DOTNET_VERSION_FINAL"

    # Afficher les runtimes installés (avec gestion d'erreur)
    print_info "Runtimes installés:"
    dotnet --list-runtimes 2>/dev/null | head -10 || print_warning "Impossible de lister les runtimes"

    # Afficher les SDKs installés (avec gestion d'erreur)  
    print_info "SDKs installés:"
    dotnet --list-sdks 2>/dev/null | head -10 || print_warning "Impossible de lister les SDKs"

else
    print_error "❌ Erreur lors de l'installation de .NET"
    exit 1
fi

# Créer un projet de test
print_info "Création d'un projet de test C#..."
TEST_DIR="$HOME/csharp-test"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Créer une application console simple si elle n'existe pas
if ! [ -f "HelloCSharp/Program.cs" ]; then
    print_info "Création d'un nouveau projet console..."
    if dotnet new console -n HelloCSharp --force; then
        cd HelloCSharp

        # Modifier le fichier Program.cs pour un exemple plus intéressant
        cat > Program.cs << 'EOF'
using System;
using System.Collections.Generic;
using System.Linq;

namespace HelloCSharp
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("🔷 Hello, C# and .NET!");
            Console.WriteLine("=============================");

            // Exemple avec LINQ
            var numbers = new List<int> { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
            var evenNumbers = numbers.Where(n => n % 2 == 0).ToList();

            Console.WriteLine($"Nombres pairs: {string.Join(", ", evenNumbers)}");

            // Exemple avec des features modernes C#
            var person = new { Name = "Développeur", Language = "C#" };
            Console.WriteLine($"👋 Bonjour {person.Name}, bienvenue dans {person.Language}!");

            // Test de la version .NET
            Console.WriteLine($"🔧 Version .NET: {Environment.Version}");
            Console.WriteLine($"📁 Répertoire: {Environment.CurrentDirectory}");

            Console.WriteLine("✅ Installation et test réussis!");
        }
    }
}
EOF

        # Construire et exécuter le projet de test
        print_info "Construction et test du projet..."
        if dotnet build; then
            print_success "✅ Construction réussie!"

            if dotnet run; then
                print_success "✅ Test d'exécution réussi!"
            else
                print_warning "⚠️  Construction OK mais exécution échouée"
            fi
        else
            print_warning "⚠️  Échec de la construction du projet de test"
        fi
    else
        print_warning "⚠️  Impossible de créer le projet de test"
    fi
else
    print_info "Projet de test déjà existant, pas de recréation"
    cd HelloCSharp

    # Tester l'exécution du projet existant
    print_info "Test du projet existant..."
    if dotnet run; then
        print_success "✅ Projet existant fonctionne!"
    else
        print_warning "⚠️  Projet existant ne fonctionne pas correctement"
    fi
fi

cd ~

print_success "✅ Installation de C# (.NET) terminée avec succès!"

print_info "📝 Commandes utiles:"
print_info "  dotnet --version                    # Vérifier la version"
print_info "  dotnet --list-sdks                  # Lister les SDKs installés"
print_info "  dotnet --list-runtimes              # Lister les runtimes installés"
print_info "  dotnet new console -n MyApp         # Créer une nouvelle app console"
print_info "  dotnet new webapi -n MyApi          # Créer une nouvelle API Web"
print_info "  dotnet build                        # Construire le projet"
print_info "  dotnet run                          # Exécuter le projet"
print_info "  dotnet publish                      # Publier pour la production"
print_info "  dotnet add package <Package>        # Ajouter un package NuGet"

print_info "🏗️  Types de projets disponibles:"
print_info "  console        # Application console"
print_info "  webapp         # Application web ASP.NET Core"
print_info "  webapi         # API Web ASP.NET Core"
print_info "  classlib       # Bibliothèque de classes"
print_info "  mvc            # Application MVC"
print_info "  blazorserver   # Application Blazor Server"

print_info "📁 Projet de test créé dans: $TEST_DIR/HelloCSharp"
print_success "🚀 Environnement C# (.NET) prêt pour le développement!"

# Afficher des informations sur les outils additionnels
print_info "🔧 Outils recommandés:"
print_info "  - VS Code avec extension C#"
print_info "  - JetBrains Rider (IDE complet)"
print_info "  - Visual Studio Code Dev Containers"

# Note sur les conflits de dépendances
print_warning "💡 Note: Script corrigé pour éviter les conflits entre versions .NET"
print_warning "Si vous avez des problèmes, utilisez dotnet via Snap ou script Microsoft"
