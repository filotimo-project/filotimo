#!/usr/bin/bash
set -ouex pipefail
source /ctx/build/steps/prelude.sh

# Mask hibernate - usually just causes problems
systemctl mask hibernate.target

# See /usr/lib/systemd/ in root

# Workaround immutable SDDM theme directory
systemctl enable usr-share-sddm-themes.mount

# Configure the firefox flatpak
systemctl enable firefox-flatpak-configuration.path

# Services
systemctl --global enable check-windows-dualboot.service
systemctl enable smb.service
systemctl enable adbusers-append.service
systemctl enable dirty-centisecs.service
systemctl enable memory-tweaks.service
systemctl enable plugdev-append.service
systemctl enable postinstall-hardware-setup.service
systemctl enable set-grub-visibility.service
systemctl disable flatpak-add-fedora-repos.service
