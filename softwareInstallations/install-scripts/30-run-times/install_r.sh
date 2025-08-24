#!/bin/bash

# Script d'installation R pour Ubuntu 24.04
# Auteur: Générateur automatique
# Date: $(date)

set -e  # Arrêter le script en cas d'erreur

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

print_cyan() {
    echo -e "${CYAN}$1${NC}"
}

print_cyan "📊 Installation de R (langage statistique) pour Ubuntu 24.04"
print_cyan "=========================================================="

# Mettre à jour les packages système
print_info "Mise à jour des packages système..."
sudo apt update -y

# Installer les dépendances nécessaires
print_info "Installation des dépendances..."
sudo apt install -y software-properties-common dirmngr curl wget apt-transport-https ca-certificates

# Méthode 1: Installation via repository Ubuntu (simple mais version plus ancienne)
install_via_ubuntu_repo() {
    print_info "Installation via le repository Ubuntu (version stable)..."

    sudo apt install -y r-base r-base-dev

    return 0
}

# Méthode 2: Installation via CRAN (dernière version)
install_via_cran() {
    print_info "Installation via CRAN (dernière version)..."

    # Ajouter la clé GPG CRAN
    print_info "Ajout de la clé GPG CRAN..."
    wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc > /dev/null

    # Ajouter le repository CRAN
    print_info "Ajout du repository CRAN..."
    sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" -y

    # Mettre à jour et installer R
    sudo apt update
    sudo apt install -y --no-install-recommends r-base r-base-dev

    return 0
}

# Méthode 3: Installation avec R2U pour avoir tous les packages CRAN pré-compilés
setup_r2u() {
    print_info "Configuration de R2U pour les packages CRAN pré-compilés..."

    # Télécharger et exécuter le script R2U pour Ubuntu 24.04 (noble)
    if [[ "$(lsb_release -cs)" == "noble" ]]; then
        curl -s https://raw.githubusercontent.com/eddelbuettel/r2u/refs/heads/master/inst/scripts/add_cranapt_noble.sh -o add_cranapt_noble.sh
        sudo bash add_cranapt_noble.sh
        rm -f add_cranapt_noble.sh
        print_success "R2U configuré pour Ubuntu 24.04"
    else
        print_warning "R2U auto-setup non disponible pour cette version d'Ubuntu"
        print_info "Configuration manuelle de r2u..."

        # Configuration manuelle pour autres versions
        wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc > /dev/null
        wget -qO- https://eddelbuettel.github.io/r2u/assets/dirk_eddelbuettel_key.asc | sudo tee -a /etc/apt/trusted.gpg.d/cranapt_key.asc > /dev/null

        echo "deb [signed-by=/etc/apt/trusted.gpg.d/cranapt_key.asc] https://r2u.stat.illinois.edu/ubuntu $(lsb_release -cs) main" | sudo tee -a /etc/apt/sources.list.d/cranapt.list

        sudo apt update
        print_success "R2U configuré manuellement"
    fi

    return 0
}

# Vérifier si R est déjà installé
if command -v R &> /dev/null; then
    R_VERSION_INSTALLED=$(R --version 2>&1 | head -n1)
    print_warning "R est déjà installé: $R_VERSION_INSTALLED"

    # Vérifier les mises à jour
    print_info "Vérification des mises à jour..."
    sudo apt update
    if sudo apt list --upgradable 2>/dev/null | grep -E "r-base|r-cran" | head -5; then
        print_info "Mises à jour disponibles pour R"
        sudo apt upgrade -y r-base* r-cran-* || true
    else
        print_success "R est à jour"
    fi

    print_success "✅ R est déjà installé et fonctionnel!"
else
    print_info "Installation de R..."

    # Menu de choix d'installation
    print_info "Choisissez la méthode d'installation:"
    echo "1) CRAN (dernière version - recommandé)"
    echo "2) Repository Ubuntu (version stable)"
    echo "3) Installation automatique CRAN"
    echo ""

    read -p "Votre choix [1-3, défaut=1]: " install_choice
    install_choice=${install_choice:-1}

    case $install_choice in
        1)
            if install_via_cran; then
                print_success "Installation via CRAN réussie"
            else
                print_warning "Installation CRAN échouée, tentative via Ubuntu repo..."
                install_via_ubuntu_repo
            fi
            ;;
        2)
            install_via_ubuntu_repo
            ;;
        3)
            install_via_cran
            ;;
        *)
            print_warning "Choix invalide, utilisation de CRAN par défaut"
            install_via_cran
            ;;
    esac
fi

# Vérifier l'installation finale
print_info "Vérification de l'installation..."
if command -v R &> /dev/null; then
    R_VERSION_FINAL=$(R --version 2>&1 | head -n1)
    print_success "✅ R installé avec succès!"
    print_success "$R_VERSION_FINAL"

    # Afficher des informations sur R
    print_info "Configuration R:"
    R --slave --no-restore --no-save -e "cat('R version:', R.version.string, '\n'); cat('Platform:', R.version\$platform, '\n'); cat('Packages library:', .libPaths()[1], '\n')" 2>/dev/null || true
else
    print_error "❌ Erreur lors de l'installation de R"
    exit 1
fi

# Proposer d'installer R2U pour des packages plus rapides
if ! grep -q "r2u" /etc/apt/sources.list.d/* 2>/dev/null; then
    read -p "📦 Voulez-vous configurer R2U pour des installations de packages plus rapides? [y/N]: " setup_r2u_choice
    if [[ "$setup_r2u_choice" =~ ^[Yy]$ ]]; then
        setup_r2u
    fi
fi

# Installer des packages R essentiels
print_info "Installation de packages R essentiels..."

# Créer un script R pour installer les packages de base
cat > /tmp/install_r_packages.R << 'EOF'
# Installer les packages R essentiels
essential_packages <- c(
    "tidyverse",    # Collection pour data science (ggplot2, dplyr, etc.)
    "devtools",     # Outils de développement
    "shiny",        # Applications web interactives
    "rmarkdown",    # Documents dynamiques
    "knitr",        # Rapports reproductibles
    "ggplot2",      # Visualisation de données
    "dplyr",        # Manipulation de données
    "readr",        # Lecture de fichiers
    "data.table",   # Manipulation efficace de grandes données
    "lubridate"     # Manipulation de dates
)

cat("Installation des packages essentiels...\n")
for (pkg in essential_packages) {
    if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
        cat("Installation de", pkg, "...\n")
        install.packages(pkg, repos="https://cloud.r-project.org/", quiet=TRUE)
    } else {
        cat(pkg, "déjà installé\n")
    }
}

cat("\n✅ Installation des packages terminée!\n")
EOF

# Exécuter l'installation des packages avec timeout
print_info "Installation des packages R essentiels (peut prendre plusieurs minutes)..."
if timeout 300 R --slave --no-restore --no-save < /tmp/install_r_packages.R; then
    print_success "✅ Packages essentiels installés"
else
    print_warning "⚠️  Installation des packages interrompue ou échouée (timeout)"
    print_info "Vous pourrez installer les packages manuellement plus tard"
fi

# Nettoyer
rm -f /tmp/install_r_packages.R

# Créer un projet de test R
print_info "Création d'un projet de test R..."
TEST_DIR="$HOME/r-test"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Créer un script R de test avec analyse de données
cat > data_analysis_test.R << 'EOF'
# Script de test R - Analyse de données simple
cat("📊 Test d'installation R\n")
cat("========================\n\n")

# Afficher des informations sur R
cat("Version R:", R.version.string, "\n")
cat("Plateforme:", R.version$platform, "\n")
cat("Date:", Sys.Date(), "\n\n")

# Test de calculs basiques
cat("🧮 Tests de calculs basiques:\n")
result <- 2 + 2
cat("2 + 2 =", result, "\n")

numbers <- c(1, 2, 3, 4, 5, 10, 15, 20)
cat("Moyenne:", mean(numbers), "\n")
cat("Médiane:", median(numbers), "\n")
cat("Écart-type:", sd(numbers), "\n\n")

# Test de manipulation de données
cat("📋 Test de manipulation de données:\n")
# Créer un data frame simple
df <- data.frame(
    nom = c("Alice", "Bob", "Charlie", "Diana", "Eve"),
    age = c(25, 30, 35, 28, 32),
    salaire = c(50000, 60000, 75000, 55000, 68000)
)

cat("Données créées:\n")
print(df)

# Calculs sur les données
cat("\nStatistiques:\n")
cat("Âge moyen:", mean(df$age), "ans\n")
cat("Salaire médian:", median(df$salaire), "€\n")

# Test conditionnel de packages
if (requireNamespace("ggplot2", quietly = TRUE)) {
    cat("\n📈 ggplot2 disponible - création d'un graphique simple\n")
    library(ggplot2)

    # Sauvegarder un graphique simple
    p <- ggplot(df, aes(x = age, y = salaire)) +
        geom_point(color = "blue", size = 3) +
        geom_smooth(method = "lm", color = "red") +
        labs(title = "Relation Âge-Salaire", 
             x = "Âge (années)", 
             y = "Salaire (€)") +
        theme_minimal()

    # Essayer de sauvegarder le graphique
    tryCatch({
        ggsave("age_salaire_plot.png", plot = p, width = 8, height = 6)
        cat("✅ Graphique sauvegardé dans age_salaire_plot.png\n")
    }, error = function(e) {
        cat("⚠️  Impossible de sauvegarder le graphique:", e$message, "\n")
    })
} else {
    cat("\n📊 Package ggplot2 non disponible - calculs uniquement\n")
}

cat("\n✅ Test R terminé avec succès!\n")
cat("🚀 R est prêt pour l'analyse de données!\n")
EOF

# Exécuter le script de test
print_info "Exécution du test R..."
if R --slave --no-restore --no-save < data_analysis_test.R; then
    print_success "✅ Test d'exécution réussi!"

    # Vérifier si le graphique a été créé
    if [[ -f "age_salaire_plot.png" ]]; then
        print_success "📈 Graphique de test créé avec succès!"
    fi
else
    print_warning "⚠️  Test d'exécution partiellement réussi"
fi

cd ~

print_success "✅ Installation de R terminée avec succès!"

print_cyan "📝 Commandes utiles:"
print_info "  R                               # Lancer la console R interactive"
print_info "  R --version                     # Vérifier la version de R"
print_info "  Rscript myscript.R              # Exécuter un script R"
print_info "  R CMD INSTALL package.tar.gz    # Installer un package depuis source"

print_cyan "📦 Gestion des packages dans R:"
print_info "  install.packages('nom_package') # Installer un package"
print_info "  library(nom_package)            # Charger un package"
print_info "  update.packages()               # Mettre à jour tous les packages"
print_info "  installed.packages()            # Lister les packages installés"
print_info "  remove.packages('nom_package')  # Désinstaller un package"

print_cyan "🔧 IDEs recommandés:"
print_info "  📝 RStudio Desktop (IDE principal pour R)"
print_info "  📊 VS Code avec extension R"
print_info "  🌐 RStudio Server (interface web)"
print_info "  📓 Jupyter Notebook avec kernel R"

print_cyan "📚 Packages essentiels installés (si disponibles):"
print_info "  • tidyverse  (collection data science)"
print_info "  • ggplot2    (visualisation)"
print_info "  • dplyr      (manipulation de données)"
print_info "  • shiny      (applications web interactives)"
print_info "  • rmarkdown  (rapports dynamiques)"

print_info "📁 Projet de test créé dans: $TEST_DIR"

# Proposer d'installer RStudio
read -p "📊 Voulez-vous installer RStudio Desktop maintenant? [y/N]: " install_rstudio
if [[ "$install_rstudio" =~ ^[Yy]$ ]]; then
    print_info "Téléchargement et installation de RStudio..."

    # Télécharger RStudio
    RSTUDIO_URL="https://download1.rstudio.org/electron/jammy/amd64/rstudio-2024.12.0-467-amd64.deb"
    wget -O /tmp/rstudio.deb "$RSTUDIO_URL"

    # Installer RStudio
    if sudo apt install -y /tmp/rstudio.deb; then
        print_success "✅ RStudio installé avec succès!"
        print_info "Lancez RStudio avec: rstudio"
    else
        print_warning "⚠️  Échec de l'installation de RStudio"
        print_info "Vous pouvez le télécharger manuellement depuis: https://www.rstudio.com/"
    fi

    # Nettoyer
    rm -f /tmp/rstudio.deb
fi

print_success "🚀 Environnement R prêt pour l'analyse statistique et la data science!"

print_cyan "💡 Premiers pas recommandés:"
print_info "1. Lancez R ou RStudio"
print_info "2. Explorez le projet de test dans ~/r-test/"
print_info "3. Consultez help.start() pour la documentation"
print_info "4. Essayez les tutorials avec swirl: install.packages('swirl')"
