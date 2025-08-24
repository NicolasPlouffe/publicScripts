#!/usr/bin/env bash
set -e

# =============================================================================
# INSTALLATION MEGA DESKTOP – Ubuntu 24.04 + Nautilus + GNOME/Sway
# Auteur : Générateur automatique
# Date   : $(date '+%Y-%m-%d')
# =============================================================================

# Couleurs pour les messages
RED='\033[0;31m'     GREEN='\033[0;32m'   YELLOW='\033[1;33m'
BLUE='\033[0;34m'    PURPLE='\033[0;35m'  CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_info()    { echo -e "${BLUE}[INFO]${NC}    $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error()   { echo -e "${RED}[ERROR]${NC}   $1"; }
print_header()  { echo -e "${PURPLE}$1${NC}"; }
print_cyan()    { echo -e "${CYAN}$1${NC}"; }

# -----------------------------------------------------------------------------
print_header "
╔══════════════════════════════════════════════════════╗
║               INSTALLATION MEGA DESKTOP             ║
║            Ubuntu 24.04 + Nautilus + GNOME/Sway      ║
╚══════════════════════════════════════════════════════╝
"
print_cyan "🚀 Ce script installe MEGAsync + intégration Nautilus, GNOME/Sway compatible"
echo ""

# Variables
UBUNTU_VER="24.04"
ARCH=$(dpkg --print-architecture)
BASE_URL="https://mega.nz/linux/repo/xUbuntu_${UBUNTU_VER}/amd64"
TMPDIR="/tmp/mega-install"
KEYRING="/usr/share/keyrings/meganz-archive-keyring.gpg"
LISTFILE="/etc/apt/sources.list.d/megasync.list"
DEB_MEGA="megasync-xUbuntu_${UBUNTU_VER}_amd64.deb"
DEB_NAUTILUS="nautilus-megasync-xUbuntu_${UBUNTU_VER}_amd64.deb"

# 1. Vérifications préalables
print_info "Vérification architecture..."
if [[ "$ARCH" != "amd64" ]]; then
  print_error "Ce script cible amd64, arch détectée: $ARCH"
  exit 1
fi
print_success "Architecture amd64 confirmée"

print_info "Vérification version Ubuntu..."
grep -q "Ubuntu ${UBUNTU_VER}" /etc/os-release \
  && print_success "Version $UBUNTU_VER confirmée" \
  || print_warning "Ubuntu != $UBUNTU_VER (continuation malgré tout)"

# 2. Préparation
print_info "Préparation répertoire temporaire..."
rm -rf "$TMPDIR"
mkdir -p "$TMPDIR"
cd "$TMPDIR"
print_success "Répertoire $TMPDIR créé"

# 3. Mise à jour APT
print_info "Mise à jour APT..."
sudo apt update -y

# 4. Téléchargements
print_info "Téléchargement MEGAsync..."
wget -q --show-progress -O "$DEB_MEGA" "${BASE_URL}/${DEB_MEGA}" \
  && print_success "MEGAsync téléchargé" \
  || { print_error "Échec téléchargement MEGAsync"; exit 1; }

print_info "Téléchargement extension Nautilus..."
if wget -q --show-progress -O "$DEB_NAUTILUS" "${BASE_URL}/${DEB_NAUTILUS}"; then
  print_success "Extension Nautilus téléchargée"
else
  print_warning "Téléchargement Nautilus échoué (on continue sans)"
  DEB_NAUTILUS=""
fi

# 5. Installation MEGAsync
print_info "Installation MEGAsync..."
if sudo apt install -y "./${DEB_MEGA}"; then
  print_success "MEGAsync installé"
else
  print_warning "Installation directe échouée, correction dépendances..."
  sudo dpkg -i "./${DEB_MEGA}" || true
  sudo apt -f install -y
  command -v megasync &>/dev/null \
    && print_success "Installation MEGAsync réussie" \
    || { print_error "Échec définitif MEGAsync"; exit 1; }
fi

# 6. Installation extension Nautilus
if [[ -n "$DEB_NAUTILUS" ]]; then
  print_info "Installation Nautilus..."
  sudo apt install -y "./${DEB_NAUTILUS}" \
    && print_success "Extension Nautilus installée" \
    || print_warning "Échec installation Nautilus (non critique)"
fi

# 7. Nettoyage anciens dépôts MEGA en conflit
print_info "Nettoyage dépôts Mega conflictuels..."
sudo rm -f /etc/apt/sources.list.d/mega.list
sudo rm -f /etc/apt/sources.list.d/megasync-old.list

# 8. Configuration repository officiel MEGA
print_info "Ajout clé GPG MEGA..."
curl -fsSL https://mega.nz/keys/meganz-archive-keyring.gpg \
  | sudo tee "$KEYRING" >/dev/null \
  && print_success "Clé GPG ajoutée" \
  || print_warning "Échec ajout clé GPG"

print_info "Ajout dépôt MEGA dans $LISTFILE..."
echo "deb [arch=amd64 signed-by=${KEYRING}] https://mega.nz/linux/repo/xUbuntu_${UBUNTU_VER}/ ./" \
  | sudo tee "$LISTFILE" >/dev/null \
  && print_success "Dépôt MEGA configuré" \
  || print_warning "Échec configuration dépôt"

print_info "Mise à jour APT (dépôt MEGA)..."
sudo apt update -y \
  && print_success "APT mis à jour" \
  || print_warning "Échec update APT (non critique)"

# 9. Vérifications post-installation
print_info "Vérification MEGAsync..."
if command -v megasync &>/dev/null; then
  print_success "MEGAsync disponible ($(megasync --version 2>/dev/null || echo "?" ))"
else
  print_error "MEGAsync introuvable après install"
  exit 1
fi

print_info "Vérification intégration Nautilus..."
if [[ -f "/usr/lib/nautilus/extensions-3.0/libnautilus-megasync.so" ]] \
  || [[ -f "/usr/lib/x86_64-linux-gnu/nautilus/extensions-3.0/libnautilus-megasync.so" ]]; then
  print_success "Extension Nautilus active"
else
  print_warning "Extension Nautilus non détectée"
fi

# 10. Nettoyage final
print_info "Nettoyage temporaire..."
cd "$HOME"
rm -rf "$TMPDIR"
print_success "Nettoyage terminé"

# 11. Fin et conseils
print_header "
╔════════════════════════════════════════════╗
║      INSTALLATION TERMINÉE AVEC SUCCÈS     ║
╚════════════════════════════════════════════╝
"
print_success "🎉 MEGA Desktop prêt à l’emploi !"
print_cyan "Lancez MEGAsync avec la commande : megasync"
