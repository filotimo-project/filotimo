#!/usr/bin/bash
set -ouex pipefail

# Enable samba for filesharing
systemctl enable smb

# Mask hibernate - usually just causes problems
systemctl mask hibernate.target

# See system_files/usr/lib/systemd/system/

# Install OpenH264 on first boot
sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/fedora-cisco-openh264.repo
systemctl enable postinstall-install-openh264.service

# Workaround immutable SDDM theme directory
systemctl enable usr-share-sddm-themes.mount

# Configure the firefox flatpak
systemctl enable firefox-flatpak-configuration.path
