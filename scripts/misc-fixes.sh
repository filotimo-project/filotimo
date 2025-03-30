#!/usr/bin/bash
set -ouex pipefail

# Remove plasma-lookandfeel-fedora
rm -rf /usr/share/plasma/look-and-feel/org.fedoraproject.fedora.desktop

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

# Fix misconfigured samba usershares
mkdir -p /var/lib/samba/usershares
chown -R root:usershares /var/lib/samba/usershares
firewall-offline-cmd --service=samba --service=samba-client
setsebool -P samba_enable_home_dirs=1
setsebool -P samba_export_all_ro=1
setsebool -P samba_export_all_rw=1
sed -i '/^\[homes\]/,/^\[/{/^\[homes\]/d;/^\[/!d}' /etc/samba/smb.conf

# Helper for virt-manager
sed -i 's@^Exec=.*@Exec=/usr/libexec/selinux-virt-manager@' /usr/share/applications/virt-manager.desktop

# Fix GTK theming - see system_files/etc/dconf/db/distro.d/00-breeze-theme
dconf update

# Stop tuned touching swappiness
grep -rIl 'vm.swappiness=' /usr/lib/tuned/profiles | xargs sed -i '/^vm.swappiness=[0-9]\+/s/^/# /'

# "default" icon theme inherits from Breeze
sed -i '/^Inherits=/s/Adwaita/Breeze/' /usr/share/icons/default/index.theme

# Make RDP work
firewall-offline-cmd --service=rdp

# Make the splash screen use Filotimo's logo
rm -rf /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/splash/images/plasma.svgz
install -m 644 /usr/share/pixmaps/fedora-logo-sprite.svg /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/splash/images/plasma.svgz

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
