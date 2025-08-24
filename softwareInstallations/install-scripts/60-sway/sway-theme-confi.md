# Configurations "Rice" Sway Prêtes à l'Emploi pour Ubuntu 24.04

Pour votre recherche de configurations Sway esthétiques et fonctionnelles, voici les **meilleures options marketplace** disponibles avec des conseils spécifiques pour votre usage développeur et multi-moniteur.

## Dotfiles Recommandés - "Marketplace" Sway

### 1. **Garuda Sway Dotfiles** - Choix #1 pour Débutants
**Créateur** : Yurihikari[1][2]
**Installation** : Script automatisé  
**Spécialités** : Catppuccin, développeur-friendly

```bash
git clone https://github.com/yurihikari/garuda-sway-config.git
cd garuda-sway-config
./install.sh
```

**Avantages pour vous** :[2][1]
- **Waybar pré-configurée** avec modules utiles (CPU, mémoire, réseau)
- **Support multi-moniteur** intégré
- **Thème Catppuccin** (idéal pour développeurs)
- **Conservation GNOME** : compatible dual-session
- **421 étoiles GitHub** - très populaire

### 2. **ML4W Dotfiles** - Pour Plus Tard
**Créateur** : Stephan Raabe[3][4]
**Spécialité** : Configuration avancée avec applications intégrées

```bash
# Installation via Flatpak Dotfiles Installer
# URL : https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/hyprland-dotfiles.dotinst
```

**Note** : Principalement pour Hyprland, mais contient d'excellents concepts Waybar utilisables avec Sway.[5][6]

### 3. **HiDay Sway Dotfiles** - Configuration Solide
**GitHub** : hidayry/swaywm-dotfiles[7]
**Compatibilité** : Debian 12 (compatible Ubuntu 24.04)

```bash
git clone https://github.com/hidayry/swaywm-dotfiles.git
cd swaywm-dotfiles
cp -r .config/* ~/.config/
```

**Inclut** : Rofi, Waybar, Foot terminal, configuration multi-moniteur

## Configuration Multi-Moniteur pour Développeurs

### Détection de vos Moniteurs
```bash
swaymsg -t get_outputs
```

### Configuration Sway Multi-Monitor[8][9][10]
Ajoutez dans `~/.config/sway/config` :

```bash
# Monitor principal (laptop)
output eDP-1 position 0,0 scale 1.0

# Monitor externe (développement)  
output HDMI-A-1 position 1920,0 scale 1.0

# Troisième monitor (optionnel)
output DP-1 position 3840,0 scale 1.0

# Workspaces spécifiques par moniteur
workspace 1 output eDP-1
workspace 2 output HDMI-A-1  
workspace 3 output HDMI-A-1
workspace 4 output DP-1
```

### Raccourcis Dynamiques Multi-Monitor[11]
```bash
# Basculer moniteurs
bindsym $mod+Shift+m exec swaymsg 'output HDMI-A-1 toggle'

# Réorganiser layout
bindsym $mod+Shift+r exec "swaymsg 'output eDP-1 pos 0 0' ; swaymsg 'output HDMI-A-1 pos 1920 0'"
```

## Personnalisation Waybar pour Développeurs

### Modules Utiles pour Devs[12][13]
```json
{
    "modules-left": ["sway/workspaces", "sway/mode"],
    "modules-center": ["sway/window"],
    "modules-right": ["cpu", "memory", "disk", "network", "battery", "clock"],
    
    "cpu": {
        "interval": 1,
        "format": " {usage}%"
    },
    "memory": {
        "format": " {used}GB/{total}GB"
    },
    "disk": {
        "interval": 30,
        "format": " {percentage_used}%",
        "path": "/"
    }
}
```

### Thème Catppuccin Waybar[12]
```bash
# Installation thème
wget https://github.com/catppuccin/waybar/releases/latest/download/mocha.css
mv mocha.css ~/.config/waybar/
```

**Dans style.css** :
```css
@import "mocha.css";

* {
    color: @text;
}

window#waybar {
    background-color: shade(@base, 0.9);
}
```

## Conservation GNOME + Sway

### Configuration Dual-Session
1. **Au login GDM** : Choisissez entre "GNOME" et "Sway"
2. **Variables d'environnement** pour Alacritty :
```bash
# Dans ~/.bashrc
if [ "$XDG_CURRENT_DESKTOP" = "sway" ]; then
    export TERMINAL=alacritty
fi
```

3. **Sway utilise déjà Alacritty** par défaut - parfait pour vous !

### Application Terminal dans Sway
```bash
# Dans sway/config
set $term alacritty
bindsym $mod+Return exec $term
```

## Installation Recommandée - Étapes

1. **Sauvegardez vos configs actuelles** :
```bash
cp -r ~/.config ~/.config-backup
```

2. **Installez Garuda Sway Dotfiles** (recommandé) :
```bash
git clone https://github.com/yurihikari/garuda-sway-config.git
cd garuda-sway-config
./install.sh
```

3. **Configurez multi-moniteur** selon vos besoins

4. **Testez** : Logout → Login → Sélectionner "Sway"

## Avantages pour Développeurs

- **Tiling automatique** : Fenêtres arrangées logiquement[14]
- **Multi-workspace** : Séparez projets par workspace
- **Waybar personnalisable** : Infos système en temps réel
- **Compatible Alacritty** : Terminal déjà optimisé
- **Conservation GNOME** : Flexibilité selon le contexte

Cette approche vous donne une **configuration professionnelle** immédiatement utilisable tout en préservant votre environnement GNOME existant.[15][16]

[1](https://github.com/yurihikari/garuda-hyprdots)
[2](https://dotfiles.lightcrimson.com)
[3](https://www.ml4w.com)
[4](https://github.com/mylinuxforwork/dotfiles)
[5](https://www.youtube.com/watch?v=ZYlRfTq4QDs)
[6](https://www.youtube.com/watch?v=rW3JKs1_oVI)
[7](https://github.com/hidayry/swaywm-dotfiles)
[8](https://www.youtube.com/watch?v=rDUI39isAKg)
[9](https://fedoramagazine.org/how-to-setup-multiple-monitors-in-sway/)
[10](https://www.lorenzobettini.it/2024/09/sway-monitor-configuration-for-different-computers/)
[11](https://bbs.archlinux.org/viewtopic.php?id=271774)
[12](https://github.com/catppuccin/waybar)
[13](https://hydeproject.pages.dev/fr/configuring/waybar/)
[14](https://swaywm.org)
[15](https://forum.garudalinux.org/t/sway-initial-dotfiles/38895)
[16](https://gitlab.com/garuda-linux/themes-and-settings/settings/garuda-sway-settings)
[17](https://forum.manjaro.org/t/how-to-change-theme-in-sway-also-add-the-instruction-to-change-themes-in-the-readme-file-in-sway/77242)
[18](https://github.com/finxol/sway-dotfiles)
[19](https://www.reddit.com/r/swaywm/comments/gl391h/how_do_you_configure_themes_in_sway/)
[20](https://discourse.nixos.org/t/customizing-waybar-theme-catppuccin-for-the-first-time-for-sway/57443)
[21](https://github.com/topics/sway-dotfiles?l=css)
[22](https://wiki.archlinux.org/title/Sway)
[23](https://github.com/Yaroslav-95/swayrice)
[24](https://forum.garudalinux.org/t/my-sway-theme-with-manual/17629)
[25](https://github.com/LoneWolf4713/new-wave)
[26](https://forum.manjaro.org/t/a-few-theme-problems-in-sway/67238)
[27](https://www.reddit.com/r/hyprland/comments/1ibj7mp/how_to_edit_waybar/)
[28](https://github.com/smravec/.dotfiles-swayfx)
[29](https://github.com/Difrex/sway)
[30](https://github.com/JohnathanFL/rice)
[31](https://www.youtube.com/watch?v=MyQ_SKmhM48)
[32](https://github.com/JosefLitos/dotfiles)
[33](https://github.com/SocketByte/.dotfiles-sway)
[34](https://www.youtube.com/watch?v=e7bezUA6G4g)
[35](https://github.com/harilvfs/swaydotfiles)
[36](https://www.youtube.com/watch?v=pdmqAdvLGgw)
[37](https://github.com/amatsagu/dotfiles)
[38](https://github.com/swaywm/sway/issues/4928)
[39](https://yutkat.github.io/dotfiles/)
[40](https://github.com/JaKooLit/Sway-dotfiles)
[41](https://www.reddit.com/r/swaywm/comments/1fl30ge/any_good_dotfiles_for_a_working_setup/)
[42](https://github.com/sidicer/dotfiles)
[43](https://github.com/mbrignall/sway-dotfiles)
[44](https://blog.sakuragawa.moe/working-on-fedora-sway-spin/)
[45](https://docs.fedoraproject.org/en-US/fedora-sericea/configuration-guide/)
[46](https://www.youtube.com/watch?v=2sNzVABBqkw)
[47](https://www.youtube.com/watch?v=jVDwMCFl3_w)
[48](https://www.youtube.com/watch?v=yA7Omw64g-M)
[49](https://github.com/chikenpotpi/garuda-sway-nord-dotfiles)
[50](https://fedoramagazine.org/setting-up-the-sway-window-manager-on-fedora/)
[51](https://www.youtube.com/watch?v=KHwJxpV_L1g)
[52](https://www.lorenzobettini.it/2024/07/a-first-look-at-fedora-40-sway/)
[53](https://www.reddit.com/r/unixporn/comments/1bomhvl/hyprland_updated_my_dotfiles_since_last_year_also/)
