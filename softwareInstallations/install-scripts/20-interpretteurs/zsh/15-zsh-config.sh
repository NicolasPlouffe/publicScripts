#!/usr/bin/env bash
set -euo pipefail

# 15 – Configuration personnalisée Zsh

echo "=== Configuration personnalisée Zsh ==="

# Vérification que zsh est installé
if ! command -v zsh &> /dev/null; then
  echo "❌ Zsh n'est pas installé. Lancez d'abord 10-base-packages.sh"
  exit 1
fi

# Sauvegarde de l'ancien .zshrc si il existe
if [ -f "$HOME/.zshrc" ]; then
  echo "--- Sauvegarde de l'ancien .zshrc ---"
  cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
  echo "✅ Sauvegarde créée : ~/.zshrc.backup.*"
fi

echo "--- Installation de Starship prompt ---"
if ! command -v starship &> /dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
  echo "✅ Starship installé"
else
  echo "✅ Starship déjà installé"
fi

echo "--- Création du nouveau .zshrc ---"
cat > "$HOME/.zshrc" << 'EOF'
# Created by newuser for 5.9
eval "$(starship init zsh)"
alias full-update='sudo apt update && sudo apt full-upgrade -y'

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

# Alias utiles
alias adl='audioDl'
alias vdl='videoDl'

# Homebrew (si installé)
if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# PlatformIO (si installé)
if [[ -d "$HOME/.platformio-venv" ]]; then
    export PATH="$HOME/.platformio-venv/bin:$PATH"
fi

# Arduino CLI (si installé)
if [[ -d "$HOME/bin" ]]; then
    export PATH="$HOME/bin:$PATH"
fi
EOF

echo "--- Rechargement de la configuration ---"
# Source le nouveau .zshrc dans le processus actuel si on utilise zsh
if [[ "$SHELL" == *"zsh"* ]]; then
  source "$HOME/.zshrc"
fi

echo "--- Test de la configuration ---"
echo "Contenu du .zshrc :"
cat "$HOME/.zshrc" | head -10
echo "..."
echo "$(tail -5 "$HOME/.zshrc")"

echo
echo "=== Configuration Zsh terminée ==="
echo "✅ Starship prompt installé"
echo "✅ Nouveau .zshrc créé avec tes fonctions personnalisées"
echo "✅ Alias et fonctions disponibles :"
echo "   • full-update - Mise à jour complète du système"
echo "   • gcp 'message' - Git add + commit + push"
echo "   • audioDl <URL> - Téléchargement audio YouTube"
echo "   • videoDl <URL> - Téléchargement vidéo YouTube"
echo "   • adl/vdl - Alias courts pour les fonctions ci-dessus"
echo ""
echo "📝 Pour activer dans ce terminal : source ~/.zshrc"
echo "📝 Pour définir zsh comme shell par défaut : chsh -s $(which zsh)"
