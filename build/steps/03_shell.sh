#!/usr/bin/bash
set -ouex pipefail
source /ctx/build/steps/prelude.sh

# Note: see root/usr/bin/fishlogin

# Set fish as default shell
sed -i 's@^SHELL=.*@SHELL=/usr/bin/fishlogin@' /etc/default/useradd

# Remove normal fish from /etc/shells to avoid people breaking their system - replace with fishlogin
sed -i '/\/usr\/bin\/fish/d' /etc/shells
sed -i '/\/bin\/fish/d' /etc/shells
echo "/usr/bin/fishlogin" >> /etc/shells

# Remove the intro message, we already have user-motd
echo 'set -U fish_greeting ""' >> /usr/share/fish/config.fish
