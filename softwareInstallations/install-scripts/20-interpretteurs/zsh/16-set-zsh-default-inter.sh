#!/usr/bin/env bash
set -euo pipefail

# 16 – Configuration de Zsh comme shell par défaut

echo "=== Configuration de Zsh comme shell par défaut ==="

# Vérification que zsh est installé
if ! command -v zsh &> /dev/null; then
  echo "❌ Zsh n'est pas installé. Lancez d'abord 10-base-packages.sh"
  exit 1
fi

# Affichage du shell actuel
echo "--- Informations actuelles ---"
echo "Shell actuel : $SHELL"
echo "Utilisateur  : $USER"
echo "Zsh trouvé   : $(which zsh)"

# Vérification que zsh est dans /etc/shells
ZSH_PATH=$(which zsh)
if ! grep -q "$ZSH_PATH" /etc/shells; then
  echo "--- Ajout de zsh dans /etc/shells ---"
  echo "$ZSH_PATH" | sudo tee -a /etc/shells
  echo "✅ Zsh ajouté à /etc/shells"
else
  echo "✅ Zsh déjà présent dans /etc/shells"
fi

# Vérification si zsh est déjà le shell par défaut
if [[ "$SHELL" == "$ZSH_PATH" ]]; then
  echo "✅ Zsh est déjà votre shell par défaut"
  echo "📝 Aucune action nécessaire"
else
  echo "--- Changement du shell par défaut ---"
  echo "⚠️  Attention : Cette action nécessite votre mot de passe"
  echo "⚠️  Vous devrez vous reconnecter pour que le changement soit effectif"
  
  read -p "Voulez-vous définir zsh comme shell par défaut ? [y/N] " confirm
  
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    # Changement du shell par défaut
    chsh -s "$ZSH_PATH"
    
    if [[ $? -eq 0 ]]; then
      echo "✅ Shell par défaut changé vers zsh avec succès"
      
      # Vérification dans /etc/passwd
      echo "--- Vérification ---"
      grep "^$USER:" /etc/passwd | cut -d: -f7
      
      echo
      echo "🎉 Configuration terminée !"
      echo "📝 Actions requises :"
      echo "   • Déconnectez-vous et reconnectez-vous"
      echo "   • Ou redémarrez votre session graphique"
      echo "   • Ou ouvrez un nouveau terminal pour tester"
      echo
      echo "🧪 Test rapide (nouveau shell zsh) :"
      echo "   zsh"
      echo "   echo \$SHELL"
      echo "   exit"
      
    else
      echo "❌ Erreur lors du changement de shell"
      echo "💡 Essayez manuellement : chsh -s $ZSH_PATH"
      exit 1
    fi
  else
    echo "❌ Changement de shell annulé"
    echo "💡 Pour changer manuellement plus tard : chsh -s $ZSH_PATH"
  fi
fi

echo
echo "--- Informations post-configuration ---"
echo "Shell configuré dans /etc/passwd :"
grep "^$USER:" /etc/passwd | cut -d: -f7

echo
echo "Shell de la session actuelle : $SHELL"
echo "(Le changement sera effectif après reconnexion)"

echo
echo "=== Configuration du shell par défaut terminée ==="
echo "📚 Commandes utiles :"
echo "   • Vérifier le shell actuel : echo \$SHELL"
echo "   • Lister les shells disponibles : cat /etc/shells"
echo "   • Changer de shell temporairement : zsh"
echo "   • Revenir à bash : chsh -s /bin/bash"
