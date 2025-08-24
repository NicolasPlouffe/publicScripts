# Guide Complet : Installation et Configuration de Sway sur Ubuntu 24.04 avec GPU NVIDIA

Ce guide détaillé vous accompagnera dans l'installation et la configuration du gestionnaire de fenêtres Sway sur Ubuntu 24.04, spécialement adapté pour un laptop ASUS TUF Gaming avec GPU NVIDIA. Sway est un excellent point d'entrée dans le monde des gestionnaires de fenêtres en mosaïque (tiling window managers), offrant une alternative moderne et efficace aux environnements de bureau traditionnels.[1][2]



## Comprendre Sway et ses Avantages

**Sway** est un compositeur Wayland en mosaïque qui constitue un remplacement direct d'i3 pour X11. Il permet d'organiser les fenêtres de manière logique plutôt que spatiale, les disposant dans une grille qui maximise l'efficacité de l'écran et peut être manipulée rapidement uniquement au clavier.[2][1]

Contrairement aux environnements de bureau traditionnels, Sway offre plusieurs avantages significatifs :
- **Performance optimisée** : Consommation réduite des ressources système
- **Workflow centré clavier** : Navigation et gestion des fenêtres sans souris
- **Compatibilité Wayland native** : Meilleure sécurité et performances graphiques
- **Coexistence avec GNOME** : Possibilité de basculer entre les deux environnements

## Défis Spécifiques avec NVIDIA

L'utilisation de Sway avec les GPU NVIDIA présente des défis particuliers car **tous les pilotes graphiques propriétaires ne sont pas officiellement supportés**. Cependant, depuis la version 495 du pilote NVIDIA, il est possible de faire fonctionner Sway en utilisant le flag `--unsupported-gpu` et en activant le mode KMS (Kernel Mode Setting).[3][4][5]

Les variables d'environnement essentielles pour NVIDIA incluent:[6][3]
- `WLR_NO_HARDWARE_CURSORS=1`
- `WLR_RENDERER_ALLOW_SOFTWARE=1` 
- `LIBVA_DRIVER_NAME=nvidia`
- `GBM_BACKEND=nvidia-drm`

## Installation Automatisée : La Solution Recommandée

Pour simplifier le processus d'installation, j'ai développé un script automatisé qui gère tous les aspects techniques, y compris la configuration spécifique NVIDIA. Ce script détecte automatiquement votre configuration matérielle et applique les optimisations appropriées.
### Préparation du système

Avant de commencer l'installation, assurez-vous que votre système Ubuntu 24.04 est à jour :

```bash
sudo apt update && sudo apt upgrade -y
```

Le script d'installation automatisée installe les paquets essentiels suivants:[7][8]
- **sway** : Le gestionnaire de fenêtres principal
- **waybar** : Barre d'état personnalisable
- **wofi** : Lanceur d'applications moderne
- **foot** : Émulateur de terminal léger
- **mako-notifier** : Système de notifications
- **grimshot** : Outil de capture d'écran
- **brightnessctl** : Contrôle de la luminosité

### Configuration NVIDIA Spécialisée

Le script crée automatiquement un wrapper spécialisé `/usr/local/bin/sway-nvidia` qui configure les variables d'environnement nécessaires et lance Sway avec le flag `--unsupported-gpu`. Cette approche garantit une compatibilité maximale avec votre GPU NVIDIA tout en maintenant la stabilité du système.[3][6]

Les modifications du kernel incluent l'ajout des modules NVIDIA à `/etc/modules-load.d/nvidia.conf` et l'activation du mode KMS via les paramètres GRUB. Ces changements permettent au pilote NVIDIA de fonctionner correctement avec le protocole Wayland.[5]

## Configuration des Fichiers : Personnalisation Avancée

### Configuration Sway Principale

La configuration Sway se trouve dans `~/.config/sway/config` et utilise une syntaxe similaire à i3. Les éléments clés de la configuration incluent :[7]

**Variables essentielles** :
```bash
set $mod Mod4  # Touche Windows
set $term gnome-terminal  # Terminal préféré
set $menu wofi --show drun  # Lanceur d'applications
```

**Support multi-écrans** :
La gestion des écrans multiples est particulièrement importante pour les étudiants qui utilisent occasionnellement un hub externe. La configuration standard pour un laptop avec écran externe est :[9][10]

```bash
output eDP-1 resolution 1920x1080 position 1920,0
output HDMI-1 resolution 1920x1080 position 0,0
```
**Gestion intelligente du couvercle** :
Pour les laptops, la configuration automatique de la gestion du couvercle est essentielle:[11]
```bash
bindswitch --reload --locked lid:on output eDP-1 disable
bindswitch --reload --locked lid:off output eDP-1 enable
```

### Configuration Waybar : Interface Utilisateur Moderne

Waybar constitue l'élément d'interface principal de Sway, remplaçant la barre d'état traditionnelle. La configuration JSON permet une personnalisation extensive des modules affichés :[8][12]

**Structure de base** :
```json
{
    "layer": "top",
    "position": "top",
    "modules-left": ["sway/workspaces", "sway/mode"],
    "modules-center": ["sway/window"], 
    "modules-right": ["battery", "network", "pulseaudio", "clock"]
}
```

Les modules essentiels pour un environnement d'apprentissage incluent :[12][8]
- **sway/workspaces** : Affichage des espaces de travail avec icônes personnalisées
- **battery** : Monitoring de la batterie avec alertes visuelles
- **network** : État de la connexion WiFi et Ethernet
- **pulseaudio** : Contrôle audio intégré
- **clock** : Horloge avec format personnalisable pour le fuseau horaire canadien

## Raccourcis Clavier : Efficacité Maximale

L'apprentissage des raccourcis clavier constitue la clé de l'efficacité avec Sway. La configuration privilégie la simplicité d'usage tout en offrant la puissance nécessaire pour un workflow professionnel.[13][14]
### Raccourcis Fondamentaux

Les raccourcis de base permettent une prise en main rapide :
- **Super + Return** : Ouvre le terminal par défaut
- **Super + D** : Active le lanceur d'applications Wofi
- **Super + Shift + Q** : Ferme la fenêtre active
- **Super + Shift + C** : Recharge la configuration Sway
- **Super + Shift + E** : Quitte Sway avec confirmation

### Navigation et Gestion des Fenêtres

La navigation utilise les touches directionnelles ou les raccourcis vim-like :
- **Super + ←/→/↑/↓** : Déplace le focus entre les fenêtres
- **Super + Shift + ←/→/↑/↓** : Déplace la fenêtre active
- **Super + R** : Active le mode redimensionnement interactif

### Espaces de Travail Multiples

La gestion des espaces de travail permet d'organiser efficacement les applications:[11]
- **Super + 1,2,3...** : Bascule vers l'espace de travail numéroté
- **Super + Shift + 1,2,3...** : Déplace la fenêtre vers l'espace spécifié

## Coexistence avec GNOME : Flexibilité Maximale

Ubuntu 24.04 permet de conserver GNOME tout en ajoutant Sway, offrant la possibilité de basculer entre les environnements selon les besoins. Cette approche progressive permet d'apprendre Sway sans abandon immédiat de l'interface familière.[15][16]

### Basculement Entre Sessions

Le gestionnaire de connexion GDM affiche les options suivantes après installation:[16][15]
- **GNOME** : Session Wayland par défaut
- **GNOME sur Xorg** : Session X11 traditionnelle  
- **Sway** ou **Sway (NVIDIA)** : Sessions Sway selon la configuration

Cette flexibilité est particulièrement avantageuse pour les étudiants qui peuvent adapter leur environnement selon les cours ou projets.[17][18]

## Configuration Multi-Écrans : Optimisation pour l'École

La configuration multi-écrans est essentielle pour les étudiants qui utilisent régulièrement des hubs externes dans leur établissement. Sway gère nativement cette configuration via des commandes simples.[19][9]

### Détection et Configuration Automatique

Pour identifier les écrans disponibles :
```bash
swaymsg -t get_outputs
```

Cette commande affiche tous les écrans connectés avec leurs caractéristiques techniques. La configuration typique pour un setup étudiant inclut :[10]
- **Écran laptop principal** : eDP-1 (1920x1080)
- **Écran externe via hub** : HDMI-1 ou DisplayPort

### Configuration Dynamique

Sway permet la reconfiguration à la volée des écrans sans redémarrage. Les commandes peuvent être intégrées dans des raccourcis clavier pour basculer rapidement entre configurations :[20][21]

```bash
# Mode écran unique (laptop seulement)
bindsym $mod+F1 exec swaymsg "output HDMI-1 disable"

# Mode dual-screen
bindsym $mod+F2 exec swaymsg "output HDMI-1 enable"
```

## Applications Essentielles et Intégration

### Terminal et Outils de Développement

Pour un étudiant en informatique, l'intégration avec les outils de développement est cruciale. La configuration par défaut privilégie :[22][23]
- **Terminal** : gnome-terminal pour la compatibilité, foot pour la performance
- **Éditeur** : Intégration native avec VS Code, Neovim, ou autres IDE
- **Navigateur** : Firefox avec support Wayland natif

### Outils Système Intégrés

Les outils système essentiels incluent:[24]
- **Gestionnaire de fichiers** : Nautilus avec support Wayland
- **Contrôle audio** : PavuControl avec raccourcis clavier
- **Gestion réseau** : NetworkManager via nm-applet
- **Notifications** : Mako avec style personnalisable

## Résolution des Problèmes Courants

### Problèmes NVIDIA Spécifiques

Les problèmes les plus fréquents avec les GPU NVIDIA incluent:[25][5]
- **Scintillement d'écran** : Résolu par `WLR_NO_HARDWARE_CURSORS=1`
- **Performance réduite** : Optimisée par les variables d'environnement appropriées
- **Applications qui ne se lancent pas** : Corrigé par la configuration Xwayland

### Debugging et Logs

Pour diagnostiquer les problèmes, Sway fournit des logs détaillés accessibles via :
```bash
journalctl --user -u sway-session.target
```

### Support de la Communauté

La communauté Sway est active et fournit un support technique via:[26][24]
- **Documentation officielle** : man pages complètes
- **Wiki communautaire** : Exemples de configurations
- **Forums spécialisés** : Reddit r/swaywm, forums distributions

## Configurations Prédéfinies et Dotfiles

### Configurations Populaires

Plusieurs configurations prédéfinies facilitent l'adoption de Sway:[27][26]
- **Ubuntu Sway Remix** : Distribution complète avec Sway pré-configuré[28]
- **Configurations GitHub** : Dotfiles communautaires avec thèmes avancés[27][11]
- **Templates minimalistes** : Configurations de base pour débutants[22][26]

### Personnalisation Progressive

L'approche recommandée consiste à commencer avec une configuration simple et l'enrichir progressivement. Les éléments à personnaliser incluent :[23][22]
- **Thèmes visuels** : Couleurs, polices, icônes
- **Raccourcis spécialisés** : Adaptés aux besoins spécifiques
- **Intégration applications** : Optimisation workflow personnel

## Optimisation Performance et Batterie

### Gestion Énergétique

Sway offre d'excellentes performances énergétiques comparé aux environnements de bureau lourds. Les optimisations incluent :[13][22]
- **Suspension intelligente** : via swayidle
- **Contrôle luminosité** : brightnessctl avec raccourcis
- **Gestion CPU** : Scaling automatique selon la charge

### Monitoring Système

L'intégration de monitoring système via Waybar permet un suivi en temps réel:[8][12]
- **Usage CPU et RAM** : Modules dédiés avec alertes
- **État batterie** : Affichage pourcentage avec animation critique
- **Température** : Monitoring thermique pour gaming laptops

## Conclusion et Recommandations

L'adoption de Sway sur Ubuntu 24.04 avec GPU NVIDIA nécessite une approche méthodique mais offre des bénéfices significatifs pour les étudiants en informatique. La configuration proposée privilégie la simplicité d'usage tout en conservant la puissance et la flexibilité nécessaires pour un environnement d'apprentissage professionnel.[2][7]

### Points Clés de Réussite

1. **Utilisation du script automatisé** : Évite les erreurs de configuration manuelle
2. **Apprentissage progressif** : Maîtrise graduelle des raccourcis et fonctionnalités
3. **Configuration hybride** : Conservation de GNOME comme fallback
4. **Personnalisation adaptée** : Ajustements selon les besoins spécifiques d'études

### Perspective d'Évolution

Sway représente l'avenir des environnements de bureau Linux avec son approche Wayland native et sa philosophie minimaliste. Pour un étudiant en informatique, cette expérience constitue un excellent apprentissage des technologies modernes tout en optimisant la productivité quotidienne.[23][7]

L'investissement initial en temps d'apprentissage est largement compensé par les gains d'efficacité à long terme, particulièrement pour les workflows de développement intensifs nécessitant une gestion optimale de l'espace d'écran et des ressources système.

[1](https://llandy3d.github.io/sway-on-ubuntu/)
[2](https://www.reddit.com/r/swaywm/comments/151uqvk/how_to_run_sway_with_proprietary_nvidia_drivers/)
[3](https://www.youtube.com/watch?v=e7bezUA6G4g)
[4](https://linuxiac.com/ubuntu-sway-remix-24-04-released/)
[5](https://forum.endeavouros.com/t/sway-with-nvidia-tutorial/23733)
[6](https://www.dwarmstrong.org/sway/)
[7](https://llandy3d.github.io/sway-on-ubuntu/simple_install/)
[8](https://forum.garudalinux.org/t/sway-nvidia/25142)
[9](https://forum.endeavouros.com/t/a-new-desktop-environment-and-window-manager-combination/21715)
[10](https://shinglyu.com/web/2024/09/17/my-wayland-adventure.html)
[11](https://github.com/crispyricepc/sway-nvidia)
[12](https://docs.fedoraproject.org/en-US/quick-docs/switching-desktop-environments/)
[13](https://www.youtube.com/watch?v=z6LQU_aozj8)
[14](https://bbs.archlinux.org/viewtopic.php?id=282565)
[15](https://forums.developer.nvidia.com/t/nvidia-495-on-sway-tutorial-questions-arch-based-distros/192212)
[16](https://www.youtube.com/watch?v=rDUI39isAKg)
[17](https://github.com/SocketByte/.dotfiles-sway)
[18](https://www.reddit.com/r/swaywm/comments/13t2s8z/how_to_switch_to_user_in_sway_on_ubuntu_2202/)
[19](https://fedoramagazine.org/how-to-setup-multiple-monitors-in-sway/)
[20](https://www.youtube.com/watch?v=MyQ_SKmhM48)
[21](https://github.com/RobinBoers/sway-gnome)
[22](https://www.reddit.com/r/swaywm/comments/1gxcrx6/need_help_with_configuring_dual_monitors_sway/)
[23](https://github.com/ldelossa/dotfiles/blob/master/config/sway/config)
[24](https://github.com/Drakulix/sway-gnome/blob/master/README.md)
[25](https://bbs.archlinux.org/viewtopic.php?id=245038)
[26](https://www.youtube.com/watch?v=dZkEU2De7-U)
[27](https://bbs.archlinux.org/viewtopic.php?id=271774)
[28](https://www.autodidacts.io/switching-to-sway-wayland-from-i3-x11-ubuntu/)
[29](https://www.youtube.com/watch?v=pdmqAdvLGgw)
[30](https://linuxconfig.org/how-to-install-configure-and-customize-waybar-on-linux)
[31](https://swaywm.org)
[32](https://www.reddit.com/r/swaywm/comments/pbz7cu/simple_sway_config_for_easy_arch_deployment/)
[33](https://man.archlinux.org/man/waybar.5.en)
[34](https://www.youtube.com/watch?v=3R-pc4ABrQc)
[35](https://wiki.hypr.land/Useful-Utilities/Status-Bars/)
[36](https://fedoramagazine.org/setting-up-the-sway-window-manager-on-fedora/)
[37](https://simondalvai.org/blog/debian-sway-v1/)
[38](https://github.com/Alexays/Waybar)
[39](https://www.faskatech.net/2020/06/27/window-manager-for-linux-switching-to-sway-and-customizing-it/)
[40](https://technat.ch/posts/sway-de/)
[41](https://www.reddit.com/r/swaywm/comments/mwcj9t/sway_essentials_tools/)
[42](https://www.youtube.com/watch?v=1X9dyK4LOlE)
[43](https://www.youtube.com/watch?v=OrYYQvPilSk)
[44](https://ppl-ai-code-interpreter-files.s3.amazonaws.com/web/direct-files/69b42507190d7abba4f6386007f618d7/06cfcd94-3427-46b6-bdfc-c4b4e5932616/086c3c9e.txt)
[45](https://ppl-ai-code-interpreter-files.s3.amazonaws.com/web/direct-files/69b42507190d7abba4f6386007f618d7/7c51c082-39d0-48d3-8ab1-7599b22c023e/979a95d8.json)
[46](https://ppl-ai-code-interpreter-files.s3.amazonaws.com/web/direct-files/69b42507190d7abba4f6386007f618d7/7c51c082-39d0-48d3-8ab1-7599b22c023e/cfab7108.css)
[47](https://ppl-ai-code-interpreter-files.s3.amazonaws.com/web/direct-files/69b42507190d7abba4f6386007f618d7/6d32ea0e-2da7-4bfa-a812-062166302681/cd39bf90.sh)