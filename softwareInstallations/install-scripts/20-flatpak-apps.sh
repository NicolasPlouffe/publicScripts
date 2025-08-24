#!/usr/bin/env bash
set -euo pipefail

# 20 – Installation des applications Flatpak

echo "=== Configuration de Flatpak et ajout de Flathub ==="
sudo apt install -y flatpak

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "=== Installation des applications Flatpak ==="
# Installation en deux étapes pour gérer les erreurs
echo "--- Applications stables ---"
flatpak install -y flathub \
  com.obsproject.Studio \
  org.onlyoffice.desktopeditors \
  com.skype.Client \
  io.dbeaver.DBeaverCommunity \
  com.logseq.Logseq \
  md.obsidian.Obsidian \
  org.remmina.Remmina \
  com.discordapp.Discord \
  com.mattjakeman.ExtensionManager \
  com.redis.RedisInsight \
  com.getpostman.Postman \
  org.videolan.VLC \
  org.gnome.Rhythmbox3 \
  fm.reaper.Reaper \
  org.virt_manager.virt-manager \
  io.neovim.nvim

echo "--- Applications potentiellement problématiques ---"
# VS Code : réessayer individuellement
echo "Installation VS Code..."
flatpak install -y flathub com.visualstudio.code || echo "ÉCHEC : VS Code - installer manuellement"

echo
echo "=== Vérification des applications installées ==="
flatpak list --app --columns=name,application | head -20

echo
echo "=== Résumé ==="
echo "✅ Applications installées avec succès"
echo "❌ MEGAsync retiré (End-of-Life sur Flathub)"
echo "⚠️  VS Code : Si échec, installer via snap ou .deb"
echo "📝 Alternative MEGAsync : installer le .deb officiel depuis mega.nz"
