#!/usr/bin/bash
set -ouex pipefail
source /ctx/build/steps/prelude.sh

# Remove plasma-lookandfeel-fedora
rm -rf /usr/share/plasma/look-and-feel/org.fedoraproject.fedora.desktop

# "default" icon theme inherits from Breeze
sed -i '/^Inherits=/s/Adwaita/Breeze/' /usr/share/icons/default/index.theme

# Make the splash screen use Filotimo's logo
rm -rf /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/splash/images/plasma.svgz
install -m 644 /usr/share/pixmaps/fedora-logo-sprite.svg /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/splash/images/plasma.svgz

# Fix GTK theming - see system_files/etc/dconf/db/distro.d/00-breeze-theme
dconf update

# Set Konsole default profile
echo "[Desktop Entry]
DefaultProfile=Filotimo.profile" >> /etc/xdg/konsolerc

# Hide nvtop and htop desktop entries
sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nHidden=true@g' /usr/share/applications/htop.desktop
sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nHidden=true@g' /usr/share/applications/nvtop.desktop
sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nHidden=true@g' /usr/share/applications/nvidia-settings.desktop || true

# Remove fcitx default icons
rm -rf /usr/share/icons/breeze/status/22/fcitx.svg
rm -rf /usr/share/icons/breeze/status/24/fcitx.svg
rm -rf /usr/share/icons/breeze-dark/status/22/fcitx.svg
rm -rf /usr/share/icons/breeze-dark/status/24/fcitx.svg

# Make fcitx icon same as keyboard preferences icon
for size in 22 24 32; do
    ln -sf /usr/share/icons/breeze/preferences/$size/preferences-desktop-keyboard.svg \
          /usr/share/icons/breeze/preferences/$size/fcitx.svg
    ln -sf /usr/share/icons/breeze-dark/preferences/$size/preferences-desktop-keyboard.svg \
          /usr/share/icons/breeze-dark/preferences/$size/fcitx.svg
done

# Change AppImageLauncher icon to appimage application icon
for size in 16 22 24 32 48 64; do
    if [ "$size" -eq 48 ]; then
        ln -sf /usr/share/icons/breeze/mimetypes/64/application-vnd.appimage.svg \
              /usr/share/icons/breeze/apps/48/AppImageLauncher.svg
        ln -sf /usr/share/icons/breeze-dark/mimetypes/64/application-vnd.appimage.svg \
              /usr/share/icons/breeze-dark/apps/48/AppImageLauncher.svg
    else
        ln -sf /usr/share/icons/breeze/mimetypes/${size}/application-vnd.appimage.svg \
              /usr/share/icons/breeze/apps/${size}/AppImageLauncher.svg
        ln -sf /usr/share/icons/breeze-dark/mimetypes/${size}/application-vnd.appimage.svg \
              /usr/share/icons/breeze-dark/apps/${size}/AppImageLauncher.svg
    fi
done

# TODO figure out why this doesn't work for Breeze Light
# Install custom Discover icon
#rm -rf /usr/share/icons/breeze/apps/48/muondiscover.svg
#rm -rf /usr/share/icons/breeze-dark/apps/48/muondiscover.svg
#rm -rf /usr/share/icons/hicolor/scalable/apps/plasmadiscover.svg
#cp /ctx/build/steps/discover-icons/muondiscover.svg /usr/share/icons/breeze/apps/48/muondiscover.svg
#cp /ctx/build/steps/discover-icons/muondiscover.svg /usr/share/icons/breeze-dark/apps/48/muondiscover.svg
#cp /ctx/build/steps/discover-icons/muondiscover.svg /usr/share/icons/hicolor/scalable/apps/plasmadiscover.svg
#sizes=("128x128" "16x16" "22x22" "32x32" "48x48")
#for size in "${sizes[@]}"; do
#    dir="/usr/share/icons/hicolor/${size}/apps"
#    width="${size%%x*}"
#    png_file="$dir/plasmadiscover.png"

#    # Remove the original PNG file if it exists
#    if [ -f "$png_file" ]; then
#        rm "$png_file"
#    fi

#    convert -background none -density "$width" "/ctx/build/steps/discover-icons/muondiscover.svg" -resize "${width}x${width}" "$png_file"
#done
