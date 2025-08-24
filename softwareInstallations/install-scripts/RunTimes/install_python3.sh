#!/bin/bash

# Script d'installation Python3 et pip pour Ubuntu 24.04 (VERSION CORRIGÉE)
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

print_info "🐍 Installation de Python3 et pip pour Ubuntu 24.04 (CORRIGÉE)"
print_info "============================================================="

# Mettre à jour les packages système
print_info "Mise à jour des packages système..."
sudo apt update -y

# Vérifier si Python3 est déjà installé
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    print_warning "Python3 est déjà installé: $PYTHON_VERSION"
else
    print_info "Installation de Python3..."
    sudo apt install -y python3
    PYTHON_VERSION=$(python3 --version)
    print_success "Python3 installé: $PYTHON_VERSION"
fi

# Installer les outils de développement Python (Ubuntu 24.04 compatible)
print_info "Installation des outils de développement Python..."
sudo apt install -y python3-dev python3-venv build-essential

# Vérifier si pip est déjà installé
if command -v pip3 &> /dev/null; then
    PIP_VERSION=$(pip3 --version)
    print_warning "pip3 est déjà installé: $PIP_VERSION"

    # Mettre à jour pip vers la dernière version
    print_info "Mise à jour de pip vers la dernière version..."
    python3 -m pip install --user --upgrade pip
else
    print_info "Installation de pip3..."

    # Méthode 1: Essayer via apt
    if sudo apt install -y python3-pip; then
        print_success "pip3 installé via apt"
    else
        # Méthode 2: Installation via get-pip.py (fallback)
        print_info "Installation de pip via get-pip.py..."
        curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
        python3 get-pip.py --user
        rm get-pip.py

        # Ajouter au PATH si nécessaire
        if ! echo $PATH | grep -q "$HOME/.local/bin"; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
            export PATH="$HOME/.local/bin:$PATH"
        fi

        print_success "pip3 installé via get-pip.py"
    fi

    PIP_VERSION=$(pip3 --version)
    print_success "pip3 installé: $PIP_VERSION"
fi

# Installer des outils Python essentiels
print_info "Installation d'outils Python essentiels..."
python3 -m pip install --user --upgrade setuptools wheel

# Installer virtualenv pour la gestion des environnements virtuels
print_info "Installation de virtualenv..."
python3 -m pip install --user virtualenv

# Installer quelques packages utiles pour le développement
print_info "Installation de packages Python utiles pour le développement..."
ESSENTIAL_PACKAGES=(
    "requests"      # HTTP library
    "numpy"         # Mathematical computing
    "pandas"        # Data manipulation
    "matplotlib"    # Plotting library
    "ipython"       # Enhanced interactive Python
    "jupyter"       # Jupyter notebooks
    "black"         # Code formatter
    "flake8"        # Linter
    "pytest"        # Testing framework
)

for package in "${ESSENTIAL_PACKAGES[@]}"; do
    print_info "Installation de $package..."
    if python3 -m pip install --user "$package"; then
        print_success "$package installé avec succès"
    else
        print_warning "Échec de l'installation de $package (non critique)"
    fi
done

# Vérifier les installations finales
print_info "Vérification des installations..."
PYTHON_FINAL=$(python3 --version)
PIP_FINAL=$(pip3 --version 2>/dev/null || python3 -m pip --version)

# Vérifier virtualenv
if python3 -m virtualenv --version &> /dev/null; then
    VIRTUALENV_VERSION=$(python3 -m virtualenv --version)
    print_success "virtualenv: $VIRTUALENV_VERSION"
elif python3 -m venv --help &> /dev/null; then
    VIRTUALENV_VERSION="venv (built-in module)"
    print_success "venv (module intégré): disponible"
else
    print_warning "Ni virtualenv ni venv ne sont disponibles"
    VIRTUALENV_VERSION="Non disponible"
fi

# Créer un projet de test Python
print_info "Création d'un projet de test Python..."
TEST_DIR="$HOME/python-test"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Créer un environnement virtuel de test
print_info "Création d'un environnement virtuel de test..."
if python3 -m venv test_env; then
    print_success "Environnement virtuel créé avec venv"
elif python3 -m virtualenv test_env; then
    print_success "Environnement virtuel créé avec virtualenv"
else
    print_warning "Impossible de créer un environnement virtuel"
fi

# Créer un script Python de test
cat > test_script.py << 'EOF'
#!/usr/bin/env python3
"""
Script de test Python - Vérification de l'installation
"""

import sys
import os
from datetime import datetime

def test_python_installation():
    print("🐍 Test d'installation Python")
    print("=" * 40)
    print(f"Version Python: {sys.version}")
    print(f"Exécutable: {sys.executable}")
    print(f"Plateforme: {sys.platform}")
    print(f"Date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print()

    # Test des modules de base
    print("📦 Test des modules de base:")
    base_modules = [
        'json', 'os', 'sys', 'datetime', 'urllib',
        'sqlite3', 'csv', 'math', 'random', 're'
    ]

    for module in base_modules:
        try:
            __import__(module)
            print(f"  ✅ {module}")
        except ImportError:
            print(f"  ❌ {module}")

    # Test des packages installés
    print("\n📚 Test des packages installés:")
    optional_packages = [
        'requests', 'numpy', 'pandas', 'matplotlib', 
        'IPython', 'black', 'pytest'
    ]

    for package in optional_packages:
        try:
            __import__(package)
            print(f"  ✅ {package}")
        except ImportError:
            print(f"  ⚠️  {package} (optionnel, non installé)")

    # Test de calculs simples
    print("\n🧮 Test de calculs:")
    import math
    numbers = [1, 2, 3, 4, 5, 10, 15, 20]
    moyenne = sum(numbers) / len(numbers)
    ecart_type = math.sqrt(sum((x - moyenne) ** 2 for x in numbers) / len(numbers))

    print(f"  Moyenne: {moyenne}")
    print(f"  Écart-type: {ecart_type:.2f}")
    print(f"  Maximum: {max(numbers)}")
    print(f"  Minimum: {min(numbers)}")

    # Test de manipulation de fichiers
    print("\n📄 Test de manipulation de fichiers:")
    test_file = "test_data.txt"
    try:
        with open(test_file, 'w') as f:
            f.write("Test d'écriture Python\nLigne 2\nLigne 3\n")

        with open(test_file, 'r') as f:
            lines = f.readlines()
            print(f"  ✅ Fichier créé avec {len(lines)} lignes")

        os.remove(test_file)
        print("  ✅ Fichier supprimé")

    except Exception as e:
        print(f"  ❌ Erreur manipulation fichier: {e}")

    print("\n✅ Test Python terminé avec succès!")
    print("🚀 Python est prêt pour le développement!")

if __name__ == "__main__":
    test_python_installation()
EOF

# Créer un fichier requirements.txt
cat > requirements.txt << 'EOF'
# Packages Python essentiels pour le développement
requests>=2.25.0
numpy>=1.20.0
pandas>=1.3.0
matplotlib>=3.3.0
ipython>=7.20.0
jupyter>=1.0.0
black>=21.0.0
flake8>=3.8.0
pytest>=6.0.0
virtualenv>=20.0.0
EOF

# Créer un exemple avec classes et fonctions modernes
cat > example_modern_python.py << 'EOF'
#!/usr/bin/env python3
"""
Exemple de code Python moderne avec fonctionnalités avancées
"""

from dataclasses import dataclass
from typing import List, Optional, Dict
from pathlib import Path
import json

@dataclass
class Developer:
    """Classe représentant un développeur"""
    name: str
    languages: List[str]
    experience: int
    active: bool = True

    def add_language(self, language: str) -> None:
        """Ajouter un langage à la liste"""
        if language not in self.languages:
            self.languages.append(language)

    def get_info(self) -> Dict[str, any]:
        """Retourner les informations du développeur"""
        return {
            "name": self.name,
            "languages": self.languages,
            "experience": self.experience,
            "active": self.active,
            "total_languages": len(self.languages)
        }

def demonstrate_python_features():
    """Démonstration des fonctionnalités Python modernes"""
    print("🔥 Démonstration Python moderne")
    print("=" * 35)

    # Création d'objets avec dataclass
    developers = [
        Developer("Alice", ["Python", "JavaScript"], 5),
        Developer("Bob", ["Java", "C++"], 3),
        Developer("Charlie", ["Rust", "Go"], 2)
    ]

    # List comprehensions et f-strings
    active_devs = [dev for dev in developers if dev.active]
    print(f"Développeurs actifs: {len(active_devs)}")

    # Utilisation de Path (moderne)
    data_file = Path("developers.json")

    # Sauvegarde en JSON
    dev_data = [dev.get_info() for dev in developers]
    with data_file.open('w') as f:
        json.dump(dev_data, f, indent=2)

    print(f"✅ Données sauvegardées dans {data_file}")

    # Pattern matching (Python 3.10+)
    for dev in developers:
        match len(dev.languages):
            case 1:
                level = "Débutant"
            case 2:
                level = "Intermédiaire"  
            case n if n >= 3:
                level = "Expert"
            case _:
                level = "Inconnu"

        print(f"👨‍💻 {dev.name}: {level} ({len(dev.languages)} langages)")

    # Walrus operator (Python 3.8+)
    if (total_experience := sum(dev.experience for dev in developers)) > 8:
        print(f"🎯 Équipe expérimentée: {total_experience} années totales")

    # Nettoyage
    data_file.unlink(missing_ok=True)
    print("🧹 Fichier temporaire nettoyé")

if __name__ == "__main__":
    demonstrate_python_features()
EOF

# Exécuter le script de test
print_info "Exécution du test Python..."
if python3 test_script.py; then
    print_success "✅ Test d'exécution réussi!"
else
    print_warning "⚠️  Test d'exécution partiellement réussi"
fi

cd ~

print_success "✅ Installation de Python3 terminée avec succès!"
print_success "Python3: $PYTHON_FINAL"
print_success "pip3: $PIP_FINAL"
print_success "virtualenv: $VIRTUALENV_VERSION"

print_info "📝 Commandes utiles:"
print_info "  python3 --version              # Vérifier la version de Python"
print_info "  pip3 --version                 # Vérifier la version de pip"
print_info "  pip3 install <package>         # Installer un package"
print_info "  python3 -m venv <env_name>     # Créer un environnement virtuel"
print_info "  source <env_name>/bin/activate # Activer un environnement virtuel"
print_info "  deactivate                     # Désactiver un environnement virtuel"
print_info "  pip3 freeze                    # Lister les packages installés"
print_info "  pip3 install -r requirements.txt  # Installer depuis requirements.txt"

print_info "🔧 Outils de développement installés:"
print_info "  • black (formateur de code)"
print_info "  • flake8 (linter)"
print_info "  • pytest (framework de test)"
print_info "  • ipython (shell interactif amélioré)"
print_info "  • jupyter (notebooks interactifs)"

print_info "📁 Projet de test créé dans: $TEST_DIR"
print_info "  📄 test_script.py (tests d'installation)"
print_info "  📄 example_modern_python.py (exemple code moderne)"
print_info "  📄 requirements.txt (dépendances)"
print_info "  📁 test_env/ (environnement virtuel de test)"

print_success "🚀 Python est prêt pour le développement!"
