#!/usr/bin/env bash
set -euo pipefail

# Script maître pour exécuter tous les modules de désinstallation
SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
for s in 00-system-update-remove.sh 10-base-packages-remove.sh 20-flatpak-apps-remove.sh 30-ppa-hyprland-remove.sh 40-hyprland-config-remove.sh 50-vscode-flatpak-remove.sh 90-cleanup-remove.sh; do
  echo "=== Désinstallation via \$s ==="
  bash "\$SCRIPTS_DIR/\$s"
done

echo "Désinstallation terminée."
