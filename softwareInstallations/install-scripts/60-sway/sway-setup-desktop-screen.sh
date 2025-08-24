#!/usr/bin/env bash
set -e

# Création du dossier ~/scripts
mkdir -p "$HOME/scripts"

echo "Installation de kanshi…"
sudo apt update
sudo apt install -y kanshi

echo "Création de ~/.config/kanshi/config…"
mkdir -p "$HOME/.config/kanshi"
cat > "$HOME/.config/kanshi/config" << 'CONF'
profile desktop {
    output eDP-1 disable
    output HDMI-0 enable mode 1920x1080 position 0,488
    output DVI-D-0 enable mode 1920x1080 position 1920,488
    output DP-0 enable mode 1080x1920 position 3840,0 transform 90
}
CONF

echo "Mise à jour de ~/.config/sway/config…"
SWAY_CONF="$HOME/.config/sway/config"
mkdir -p "$(dirname "$SWAY_CONF")"
if ! grep -q 'exec_always kanshi' "$SWAY_CONF" 2>/dev/null; then
    echo -e "\n# Lancement automatique de kanshi\nexec_always kanshi" >> "$SWAY_CONF"
fi
if ! grep -q 'bindsym.*apply-sway-desktop.sh' "$SWAY_CONF" 2>/dev/null; then
    echo -e "\n# Raccourci pour profil desktop\nbindsym \$mod+Shift+d exec ~/scripts/apply-sway-desktop.sh" >> "$SWAY_CONF"
fi

echo "Création du script de secours ~/scripts/apply-sway-desktop.sh…"
cat > "$HOME/scripts/apply-sway-desktop.sh" << 'SCR'
#!/usr/bin/env bash
kanshi --only-profile desktop
notify-send "Sway Setup" "Profil desktop appliqué"
SCR
chmod +x "$HOME/scripts/apply-sway-desktop.sh"

echo "Terminé ! Exécutez maintenant :"
echo "  ~/scripts/apply-sway-desktop.sh"
echo "Ou, dans Sway, pressez Mod+Shift+d après avoir rechargé la config."
