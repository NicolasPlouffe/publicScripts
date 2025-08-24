#!/usr/bin/env bash
set -e

# Racine des scripts (dossier contenant l'arborescence)
BASE_DIR="$(dirname "$0")"

# Fonction d'affichage d'un menu de choix
menu() {
  local prompt="$1"; shift
  local options=("$@")
  local PS3="$prompt "
  select opt in "${options[@]}" "Retour" "Quitter"; do
    case $REPLY in
      [1-$((${#options[@]}))]) echo "${options[$REPLY-1]}"; return 0 ;;
      $((${#options[@]}+1))) echo "__BACK__"; return 0 ;;    # Retour
      $((${#options[@]}+2))) echo "__EXIT__"; return 0 ;;    # Quitter
      *) echo "Choix invalide." ;;
    esac
  done
}

# Fonction principale
explore_dir() {
  local dir="$1"

  while true; do
    # Lister les sous-dossiers et fichiers .sh
    mapfile -t subdirs < <(find "$dir" -maxdepth 1 -type d ! -path "$dir" -printf "%f\n")
    mapfile -t scripts < <(find "$dir" -maxdepth 1 -type f -name "*.sh" -printf "%f\n")
    
    # Menu de choix des sous-dossiers + fichiers
    echo
    echo "📂 Dossier courant : $(basename "$dir")"
    if [ ${#subdirs[@]} -gt 0 ]; then
      echo "Sous-dossiers disponibles :"
      select sd in "${subdirs[@]}" "Choisir un script" "Retour" "Quitter"; do
        case $REPLY in
          [1-$((${#subdirs[@]}))])
            explore_dir "$dir/$sd"
            break
            ;;
          $((${#subdirs[@]}+1)))
            # Passer au menu des scripts
            break
            ;;
          $((${#subdirs[@]}+2)))
            return 1
            ;;
          $((${#subdirs[@]}+3)))
            exit 0
            ;;
          *)
            echo "Choix invalide."
            ;;
        esac
      done
    fi

    # Menu de choix des scripts
    if [ ${#scripts[@]} -gt 0 ]; then
      echo
      echo "Scripts disponibles dans $(basename "$dir") :"
      PS3="Que voulez-vous faire ? "
      select choice in "Exécuter un script" "Exécuter tous les scripts" "Retour" "Quitter"; do
        case $REPLY in
          1)
            # Sélection d’un script unique
            select s in "${scripts[@]}" "Annuler"; do
              if [ "$s" = "Annuler" ] || [ -z "$s" ]; then break; fi
              echo "→ Exécution de $s..."
              bash "$dir/$s"
              break
            done
            break
            ;;
          2)
            # Exécution de tous les scripts
            for s in "${scripts[@]}"; do
              echo "→ Exécution de $s..."
              bash "$dir/$s"
            done
            break
            ;;
          3)
            # Retour au dossier parent
            return 0
            ;;
          4)
            exit 0
            ;;
          *)
            echo "Choix invalide."
            ;;
        esac
      done
    else
      echo "Aucun script .sh dans ce dossier."
      return 0
    fi
  done
}

# Lancement du menu depuis la racine
explore_dir "$BASE_DIR"
