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
  io.dbeaver.DBeaverCommunity \
  md.obsidian.Obsidian \
  org.remmina.Remmina \
  com.discordapp.Discord \
  com.super_productivity.SuperProductivity \
  com.mattjakeman.ExtensionManager \
  com.redis.RedisInsight \
  com.getpostman.Postman \
  org.videolan.VLC \
  org.gnome.Rhythmbox3 \
  fm.reaper.Reaper \
  org.virt_manager.virt-manager \
  io.neovim.nvim \
  com.vscodium.codium \
  org.ferdium.Ferdium \
  org.winehq.Wine \
  org.inkscape.Inkscape \
  com.jeffser.Alpaca \
  com.github.johnfactotum.Foliate \
  org.zotero.Zotero

echo
echo "=== Vérification des applications installées ==="
flatpak list --app --columns=name,application | head -20

echo
echo "=== Résumé ==="
echo "✅ Applications installées avec succès"
