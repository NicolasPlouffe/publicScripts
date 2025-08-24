#!/usr/bin/env bash
set -euo pipefail

# Script maître d'installation - Ubuntu 24.04 Setup

echo "██████████████████████████████████████████████████████████"
echo "    UBUNTU 24.04 - INSTALLATION COMPLÈTE AUTOMATISÉE"
echo "    Scripts d'installation IoT/Développement + Hyprland"
echo "██████████████████████████████████████████████████████████"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction de logging
log() {
    echo -e "${GREEN}[$(date +'%H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERREUR]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[ATTENTION]${NC} $1"
}

# Fonction pour trouver le script
find_script() {
    local prefix="$1"
    local script_dir="$(dirname "$0")"
    
    # Recherche exacte du fichier
    for file in "${script_dir}/${prefix}"*.sh; do
        if [[ -f "$file" ]]; then
            echo "$file"
            return 0
        fi
    done
    return 1
}

# Vérification de la distro
if [[ $(lsb_release -rs) != "24.04" ]]; then
    warning "Ce script est optimisé pour Ubuntu 24.04"
    read -p "Continuer quand même ? [y/N] " ans
    [[ ! "$ans" =~ ^[Yy]$ ]] && exit 0
fi

# Affichage des scripts disponibles
echo
echo "Scripts disponibles dans ce répertoire :"
for script in *.sh; do
    [[ "$script" == "install-all.sh" ]] && continue
    echo "  • $script"
done

echo
echo "Choisissez le mode d'installation :"
echo "1) Installation complète (ordre logique)"
echo "2) Installation sélective (choisir les scripts)"
echo "3) Installation développement (base + dev tools)"
echo "4) Exécuter un script spécifique"
echo "5) Quitter"

read -p "Votre choix [1-5] : " mode

case $mode in
    1)
        # Scripts dans l'ordre logique d'installation
        SCRIPT_FILES=(
            "00-system-update.sh"
            "10-base-packages.sh"
            "20-flatpak-apps.sh"
            "25-manual-installs.sh"
            "60-developpment-tools.sh"
            "90-cleanup.sh"
        )
        log "Mode installation complète sélectionné"
        ;;
    2)
        SCRIPT_FILES=()
        echo "Choisissez les scripts à exécuter :"
        for script in *.sh; do
            [[ "$script" == "install-all.sh" ]] && continue
            read -p "Exécuter $script ? [y/N] " ans
            [[ "$ans" =~ ^[Yy]$ ]] && SCRIPT_FILES+=("$script")
        done
        ;;
    3)
        SCRIPT_FILES=(
            "00-system-update.sh"
            "10-base-packages.sh"
            "25-manual-installs.sh"
            "60-developpment-tools.sh"
            "90-cleanup.sh"
        )
        log "Mode développement sélectionné"
        ;;
    4)
        echo "Scripts disponibles :"
        select script in *.sh; do
            [[ "$script" == "install-all.sh" ]] && continue
            if [[ -n "$script" ]]; then
                SCRIPT_FILES=("$script")
                break
            fi
        done
        ;;
    5)
        log "Installation annulée"
        exit 0
        ;;
    *)
        error "Choix invalide"
        exit 1
        ;;
esac

echo
log "Scripts à exécuter : ${SCRIPT_FILES[*]}"
read -p "Confirmer l'installation ? [y/N] " confirm
[[ ! "$confirm" =~ ^[Yy]$ ]] && exit 0

# Exécution des scripts
SCRIPT_DIR="$(dirname "$0")"
START_TIME=$(date +%s)
EXECUTED_SCRIPTS=()
FAILED_SCRIPTS=()

for script_file in "${SCRIPT_FILES[@]}"; do
    full_path="${SCRIPT_DIR}/${script_file}"
    
    if [[ -f "$full_path" ]]; then
        log "▶️  Exécution de $script_file"
        
        if bash "$full_path"; then
            log "✅ $script_file terminé avec succès"
            EXECUTED_SCRIPTS+=("$script_file")
        else
            error "❌ $script_file a échoué"
            FAILED_SCRIPTS+=("$script_file")
            read -p "Continuer malgré l'erreur ? [y/N] " cont
            [[ ! "$cont" =~ ^[Yy]$ ]] && exit 1
        fi
        
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    else
        warning "Script $script_file non trouvé dans $SCRIPT_DIR"
        FAILED_SCRIPTS+=("$script_file (introuvable)")
    fi
done

# Résumé final
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo
echo "██████████████████████████████████████████████████████████"
echo -e "${GREEN}    INSTALLATION TERMINÉE${NC}"
echo "██████████████████████████████████████████████████████████"
echo "⏱️  Durée totale : $((DURATION / 60))m $((DURATION % 60))s"
echo "✅ Scripts réussis : ${#EXECUTED_SCRIPTS[@]}"
if [[ ${#FAILED_SCRIPTS[@]} -gt 0 ]]; then
    echo "❌ Scripts échoués : ${FAILED_SCRIPTS[*]}"
fi
echo
echo "📝 Actions post-installation :"
echo "   • Redémarrez votre session pour finaliser"
echo "   • Rechargez votre terminal : source ~/.bashrc"

# Actions spécifiques selon les scripts exécutés
if [[ " ${EXECUTED_SCRIPTS[*]} " =~ "60-developpment-tools.sh" ]]; then
    echo "   • Test Arduino CLI : ~/bin/arduino-cli board list"
    echo "   • Test PlatformIO : ~/.platformio-venv/bin/pio device list"
fi

if [[ " ${EXECUTED_SCRIPTS[*]} " =~ "30-ppa-hyprland.sh" ]]; then
    echo "   • Hyprland disponible au login (si installation réussie)"
fi

echo
log "🎉 Configuration Ubuntu 24.04 terminée !"
