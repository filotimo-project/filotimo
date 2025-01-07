#!/usr/bin/bash
set -ouex pipefail

# Enable samba for filesharing
systemctl enable smb

# Mask hibernate - usually just causes problems
systemctl mask hibernate.target

# See system_files/usr/lib/systemd/system/

# Workaround immutable SDDM theme directory
systemctl enable usr-share-sddm-themes.mount

# Configure the firefox flatpak
systemctl enable firefox-flatpak-configuration.path

# Other tweaks
systemctl enable adbusers-append.service
systemctl enable dirty-centisecs.service
systemctl enable memory-tweaks.service
systemctl enable plugdev-append.service
systemctl enable postinstall-hardware-setup.service
