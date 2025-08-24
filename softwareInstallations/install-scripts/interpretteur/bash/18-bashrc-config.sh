#!/usr/bin/env bash
set -euo pipefail

# 18 – Ajout de fonctions personnalisées dans ~/.bashrc

echo "=== Ajout de fonctions personnalisées dans ~/.bashrc ==="

# Vérification que le fichier .bashrc existe
if [ ! -f "$HOME/.bashrc" ]; then
    echo "❌ Fichier ~/.bashrc non trouvé"
    exit 1
fi

# Sauvegarde du .bashrc actuel
echo "--- Sauvegarde du .bashrc actuel ---"
cp "$HOME/.bashrc" "$HOME/.bashrc.backup.$(date +%Y%m%d_%H%M%S)"
echo "✅ Sauvegarde créée : ~/.bashrc.backup.*"

# Vérification si les fonctions existent déjà
if grep -q "# === FONCTIONS PERSONNALISEES ===" "$HOME/.bashrc"; then
    echo "⚠️  Fonctions personnalisées déjà présentes dans ~/.bashrc"
    read -p "Voulez-vous les remplacer ? [y/N] " replace
    
    if [[ "$replace" =~ ^[Yy]$ ]]; then
        # Suppression des anciennes fonctions
        sed -i '/# === FONCTIONS PERSONNALISEES ===/,/# === FIN FONCTIONS PERSONNALISEES ===/d' "$HOME/.bashrc"
        echo "✅ Anciennes fonctions supprimées"
    else
        echo "❌ Ajout annulé"
        exit 0
    fi
fi

echo "--- Ajout des nouvelles fonctions ---"

# Ajout des fonctions à la fin du .bashrc
cat >> "$HOME/.bashrc" << 'EOF'

# === FONCTIONS PERSONNALISEES ===
# Ajouté automatiquement par 18-bashrc-functions.sh

# Alias pour mise à jour complète
alias full-update='sudo apt update && sudo apt full-upgrade -y'

# Fonction Git : Add + Commit + Push en une commande
gcp() {
    # Vérifier qu'un message de commit a été fourni
    if [ -z "$1" ]; then
        echo "Erreur: Veuillez fournir un message de commit"
        echo "Usage: gcp 'votre message de commit'"
        return 1
    fi

    # Obtenir le nom de la branche courante
    current_branch=$(git branch --show-current)

    # Vérifier qu'on est dans un repo git
    if [ $? -ne 0 ]; then
        echo "Erreur: Vous n'êtes pas dans un répertoire git"
        return 1
    fi

    echo "📦 Ajout des fichiers..."
    git add .

    if [ $? -eq 0 ]; then
        echo "✅ Fichiers ajoutés avec succès"
    else
        echo "❌ Erreur lors de l'ajout des fichiers"
        return 1
    fi

    echo "💬 Création du commit avec le message: '$1'"
    git commit -m "$1"

    if [ $? -eq 0 ]; then
        echo "✅ Commit créé avec succès"
    else
        echo "❌ Erreur lors de la création du commit"
        return 1
    fi

    echo "🚀 Push vers la branche '$current_branch'..."
    git push origin "$current_branch"

    if [ $? -eq 0 ]; then
        echo "✅ Push effectué avec succès vers '$current_branch'"
    else
        echo "❌ Erreur lors du push"
        return 1
    fi

    echo "🎉 Processus terminé avec succès!"
}

# Fonction pour télécharger l'audio YouTube
audioDl() {
    local url="$1"
    local quality="${2:-320}"

    if [[ -z "$url" ]]; then
        echo "Usage: audioDl <URL_YOUTUBE> [qualite_audio]"
        return 1
    fi

    local cookie_arg=""
    if [[ -f "$HOME/.config/yt-dlp/cookies.txt" ]]; then
        cookie_arg="--cookies $HOME/.config/yt-dlp/cookies.txt"
    fi

    if [[ "$url" =~ (playlist|list=|channel|@) ]]; then
        echo "Playlist/Chaine detectee - Creation du dossier..."

        local folder_name
        folder_name=$(yt-dlp $cookie_arg --get-filename -o "%(uploader)s - %(playlist_title)s" "$url" 2>/dev/null | head -1)
        folder_name=$(echo "$folder_name" | sed 's/[<>:"/\\|?*]//g' | sed 's/  */ /g' | xargs)

        if [[ -z "$folder_name" ]]; then
            folder_name="YouTube_Audio_$(date +%Y%m%d_%H%M%S)"
        fi

        mkdir -p "$folder_name"
        cd "$folder_name"
        echo "Telechargement dans le dossier: $folder_name"

        yt-dlp $cookie_arg \
            --extract-audio \
            --audio-format mp3 \
            --audio-quality "$quality" \
            --embed-metadata \
            --add-metadata \
            --ignore-errors \
            --continue \
            --no-overwrites \
            -o "%(playlist_index)03d - %(title)s.%(ext)s" \
            "$url"
        cd ..
    else
        echo "Video unique detectee..."

        yt-dlp $cookie_arg \
            --extract-audio \
            --audio-format mp3 \
            --audio-quality "$quality" \
            --embed-metadata \
            --add-metadata \
            --ignore-errors \
            --continue \
            --no-overwrites \
            -o "%(title)s.%(ext)s" \
            "$url"
    fi

    if [[ $? -eq 0 ]]; then
        echo "✅ Telechargement termine avec succes!"
    else
        echo "❌ Echec du telechargement"
    fi
}

# Fonction pour télécharger les vidéos YouTube
videoDl() {
    local url="$1"
    local format="${2:-bestvideo+bestaudio}"

    if [[ -z "$url" ]]; then
        echo "Usage: videoDl <URL_YOUTUBE> [format]"
        echo "Exemples:"
        echo "  videoDl 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'"
        echo "  videoDl 'https://www.youtube.com/watch?v=dQw4w9WgXcQ' 'bestvideo[height<=1080]+bestaudio'"
        echo "  videoDl 'https://www.youtube.com/watch?v=dQw4w9WgXcQ' 'best[height<=720]'"
        return 1
    fi

    local cookie_arg=""
    if [[ -f "$HOME/.config/yt-dlp/cookies.txt" ]]; then
        cookie_arg="--cookies $HOME/.config/yt-dlp/cookies.txt"
    fi

    if [[ "$url" =~ (playlist|list=|channel|@) ]]; then
        echo "Playlist/Chaine detectee - Creation du dossier..."

        local folder_name
        folder_name=$(yt-dlp $cookie_arg --get-filename -o "%(uploader)s - %(playlist_title)s" "$url" 2>/dev/null | head -1)
        folder_name=$(echo "$folder_name" | sed 's/[<>:"/\\|?*]//g' | sed 's/  */ /g' | xargs)

        if [[ -z "$folder_name" ]]; then
            folder_name="YouTube_Video_$(date +%Y%m%d_%H%M%S)"
        fi

        mkdir -p "$folder_name"
        cd "$folder_name"
        echo "Telechargement dans le dossier: $folder_name"

        yt-dlp $cookie_arg \
            -f "$format" \
            --merge-output-format mp4 \
            --ignore-errors \
            --continue \
            --no-overwrites \
            -o "%(playlist_index)03d - %(title)s.%(ext)s" \
            "$url"
        cd ..
    else
        echo "Video unique detectee..."

        yt-dlp $cookie_arg \
            -f "$format" \
            --merge-output-format mp4 \
            --ignore-errors \
            --continue \
            --no-overwrites \
            -o "%(title)s.%(ext)s" \
            "$url"
    fi

    if [[ $? -eq 0 ]]; then
        echo "✅ Telechargement termine avec succes!"
    else
        echo "❌ Echec du telechargement"
    fi
}

# Alias utiles pour les fonctions de téléchargement
alias adl='audioDl'
alias vdl='videoDl'

# Ajout des PATHs importants (si les répertoires existent)
# PlatformIO
if [[ -d "$HOME/.platformio-venv" ]]; then
    export PATH="$HOME/.platformio-venv/bin:$PATH"
fi

# Arduino CLI
if [[ -d "$HOME/bin" ]]; then
    export PATH="$HOME/bin:$PATH"
fi

# Homebrew (si installé)
if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# === FIN FONCTIONS PERSONNALISEES ===
EOF

echo "✅ Fonctions ajoutées au ~/.bashrc"

echo "--- Rechargement de la configuration ---"
# Source le .bashrc dans le processus actuel
source "$HOME/.bashrc"

echo "--- Test des fonctions ajoutées ---"
echo "Test des alias et fonctions :"

# Test que les fonctions sont bien définies
if type -t full-update >/dev/null; then
    echo "✅ alias full-update défini"
else
    echo "❌ alias full-update non trouvé"
fi

if type -t gcp >/dev/null; then
    echo "✅ fonction gcp définie"
else
    echo "❌ fonction gcp non trouvée"
fi

if type -t audioDl >/dev/null; then
    echo "✅ fonction audioDl définie"
else
    echo "❌ fonction audioDl non trouvée"
fi

if type -t videoDl >/dev/null; then
    echo "✅ fonction videoDl définie"
else
    echo "❌ fonction videoDl non trouvée"
fi

echo
echo "=== Configuration ~/.bashrc terminée ==="
echo "✅ Fonctions personnalisées ajoutées"
echo "✅ Configuration automatiquement rechargée"
echo "✅ Fonctions disponibles dans ce terminal"
echo ""
echo "🚀 Fonctions disponibles :"
echo "   • full-update - Mise à jour complète du système"
echo "   • gcp 'message' - Git add + commit + push rapide"
echo "   • audioDl <URL> [qualité] - Téléchargement audio YouTube"
echo "   • videoDl <URL> [format] - Téléchargement vidéo YouTube"
echo "   • adl / vdl - Raccourcis pour audioDl / videoDl"
echo ""
echo "📝 Les fonctions sont maintenant disponibles dans tous vos nouveaux terminaux"
echo "📝 Configuration sauvegardée dans : ~/.bashrc.backup.*"
