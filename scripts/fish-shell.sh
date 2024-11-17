#!/usr/bin/bash
set -ouex pipefail

# Setup fish to inherit profile correctly
echo '#!/bin/bash -l
bash --norc --noprofile /etc/profile.d/user-motd.sh
exec env UID=$(id -u -r) EUID=$(id -u) GID=$(id -g) fish -l "$@"' > /usr/bin/fishlogin
chmod +x /usr/bin/fishlogin

# Set fish as default shell
sed -i 's@^SHELL=.*@SHELL=/usr/bin/fishlogin@' /etc/default/useradd

# Remove normal fish from /etc/shells to avoid people breaking their system - replace with fishlogin
sed -i '/\/usr\/bin\/fish/d' /etc/shells
sed -i '/\/bin\/fish/d' /etc/shells
echo "/usr/bin/fishlogin" >> /etc/shells

# Remove the intro message, we already have user-motd
echo 'set -U fish_greeting ""' >> /usr/share/fish/config.fish

# Alias sudo to run0 only on fish
echo 'alias sudo="run0 "' >> /usr/share/fish/config.fish

# Hide the desktop entry
sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nHidden=true@g' /usr/share/applications/fish.desktop
