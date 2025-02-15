#!/usr/bin/bash
set -ouex pipefail

# Fix podman complaining about some database thing
mkdir -p /etc/skel/.local/share/containers/storage/volumes

# Hide nvtop and htop desktop entries
sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nHidden=true@g' /usr/share/applications/htop.desktop
sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nHidden=true@g' /usr/share/applications/nvtop.desktop
sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nHidden=true@g' /usr/share/applications/nvidia-settings.desktop || true

# Set Konsole default profile
echo "[Desktop Entry]
DefaultProfile=Filotimo.profile" >> /etc/xdg/konsolerc

# Set rpm-ostree to check for updates automatically, not stage automatically
# Updates will be done automatically by Discover
sed -i "s/^AutomaticUpdatePolicy=.*/AutomaticUpdatePolicy=check/" /etc/rpm-ostreed.conf

# Remove fcitx default icons
rm -rf /usr/share/icons/breeze/status/22/fcitx.svg
rm -rf /usr/share/icons/breeze/status/24/fcitx.svg
rm -rf /usr/share/icons/breeze-dark/status/22/fcitx.svg
rm -rf /usr/share/icons/breeze-dark/status/24/fcitx.svg

# Fix misconfigured samba usershares
mkdir -p /var/lib/samba/usershares
chown -R root:usershares /var/lib/samba/usershares
firewall-offline-cmd --service=samba --service=samba-client

# Helper for virt-manager
sed -i 's@^Exec=.*@Exec=/usr/libexec/selinux-virt-manager@' /usr/share/applications/virt-manager.desktop

# Fix GTK theming - see system_files/etc/dconf/db/distro.d/00-breeze-theme
dconf update

# Stop tuned touching swappiness
grep -rIl 'vm.swappiness=' /usr/lib/tuned/profiles | xargs sed -i '/^vm.swappiness=[0-9]\+/s/^/# /'

# Remove Klassy themes, they add clutter and don't really serve a purpose
rm -rf /usr/share/plasma/look-and-feel/org.kde.klassy*
rm -rf /usr/share/color-schemes/Klassy*

# "default" icon theme inherits from Breeze
sed -i '/^Inherits=/s/Adwaita/Breeze/' /usr/share/icons/default/index.theme

# TODO figure out why this doesn't work for Breeze Light
# Install custom Discover icon
#rm -rf /usr/share/icons/breeze/apps/48/muondiscover.svg
#rm -rf /usr/share/icons/breeze-dark/apps/48/muondiscover.svg
#rm -rf /usr/share/icons/hicolor/scalable/apps/plasmadiscover.svg
#cp ./discover-icons/muondiscover.svg /usr/share/icons/breeze/apps/48/muondiscover.svg
#cp ./discover-icons/muondiscover.svg /usr/share/icons/breeze-dark/apps/48/muondiscover.svg
#cp ./discover-icons/muondiscover.svg /usr/share/icons/hicolor/scalable/apps/plasmadiscover.svg
#sizes=("128x128" "16x16" "22x22" "32x32" "48x48")
#for size in "${sizes[@]}"; do
#    dir="/usr/share/icons/hicolor/${size}/apps"
#    width="${size%%x*}"
#    png_file="$dir/plasmadiscover.png"

#    # Remove the original PNG file if it exists
#    if [ -f "$png_file" ]; then
#        rm "$png_file"
#    fi

#    convert -background none -density "$width" "./discover-icons/muondiscover.svg" -resize "${width}x${width}" "$png_file"
#done

# Fix powerdevil infinitely restarting with some monitors and causing stutters
sed -i \
      -e '/^\[Unit\]$/a StartLimitIntervalSec=60' \
      -e '/^\[Unit\]$/a StartLimitBurst=5' \
      -e '/^\[Service\]$/a RestartSec=5' \
      /usr/lib/systemd/user/plasma-powerdevil.service

