#!/usr/bin/bash
set -ouex pipefail

# See https://github.com/ublue-os/packages/blob/main/packages/ublue-setup-services
source /usr/lib/ublue/setup-services/libsetup.sh
version-script flatpak user 1 || exit 0

# More consistent Qt/GTK themes for Flatpaks
flatpak override --user --filesystem="xdg-config/gtk-3.0:ro"
flatpak override --user --filesystem="xdg-config/gtk-4.0:ro"
flatpak override --user --filesystem="xdg-data/themes"
flatpak override --user --filesystem="xdg-data/icons"
flatpak override --user --filesystem="~/.themes"
flatpak override --user --filesystem="~/.icons"

# TODO: re-evaluate with Fedora 42
# Setting this variable to anything other than `xdgdesktopportal`
# will break the XDG Desktop Portal inside the sandbox
# See https://github.com/ublue-os/aurora/issues/224
flatpak override --user --unset-env="QT_QPA_PLATFORMTHEME"

# Disable WebKit compositing mode for NVIDIA users
if ! nvidia-smi &>/dev/null; then
    flatpak override --user --env="WEBKIT_DISABLE_COMPOSITING_MODE=1"
fi

# Application-specific overrides
flatpak override --user --nosocket="wayland" dev.vencord.Vesktop
flatpak override --user --filesystem="home:ro" dev.vencord.Vesktop

flatpak override --user --nosocket="wayland" com.discordapp.Discord
flatpak override --user --filesystem="home:ro" com.discordapp.Discord

flatpak override --user --filesystem="home" com.visualstudio.code
flatpak override --user --filesystem="xdg-run/podman" com.visualstudio.code
