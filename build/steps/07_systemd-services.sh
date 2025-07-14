#!/usr/bin/bash
set -ouex pipefail
source /ctx/build/steps/prelude.sh

# Mask hibernate - usually just causes problems
systemctl mask hibernate.target

# See /usr/lib/systemd/ in root

# Workaround immutable SDDM theme directory
systemctl enable usr-share-sddm-themes.mount

# Services
systemctl --global enable check-windows-dualboot.service
systemctl enable smb.service
systemctl enable adbusers-append.service
systemctl enable btrfs-dynamic-reclaim.service
systemctl enable dirty-centisecs.service
systemctl enable memory-tweaks.service
systemctl enable plugdev-append.service
systemctl enable set-grub-visibility.service
systemctl enable ublue-os-libvirt-workarounds.service
systemctl disable flatpak-add-fedora-repos.service

# Setup hook runners
# FIXME: workaround for it being fucked upstream
sed -i '/^\[Service\]$/a User=root' /usr/lib/systemd/system/ublue-system-setup.service
systemctl enable ublue-system-setup.service
systemctl --global enable ublue-user-setup.service
