#!/usr/bin/bash
set -ouex pipefail
source /ctx/build/steps/prelude.sh

# Remove plasma-lookandfeel-fedora
rm -rf /usr/share/plasma/look-and-feel/org.fedoraproject.fedora.desktop

# "default" icon theme inherits from Breeze
sed -i '/^Inherits=/s/Adwaita/breeze_cursors,breeze,breeze-dark,Breeze/' /usr/share/icons/default/index.theme

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

# Remove appimagelauncher settings
rm -rf /usr/share/applications/appimagelaunchersettings.desktop

# Make fcitx icon same as keyboard preferences icon
for size in 22 24 32; do
    mkdir -p /usr/share/icons/filotimo/preferences/$size
    ln -sf /usr/share/icons/breeze/preferences/$size/preferences-desktop-keyboard.svg \
          /usr/share/icons/filotimo/preferences/$size/fcitx.svg
    mkdir -p /usr/share/icons/filotimo-dark/preferences/$size
    ln -sf /usr/share/icons/breeze-dark/preferences/$size/preferences-desktop-keyboard.svg \
          /usr/share/icons/filotimo-dark/preferences/$size/fcitx.svg
done

# Change AppImageLauncher icon to appimage application icon
for size in 16 22 24 32 48 64; do
    if [ "$size" -eq 48 ]; then
        mkdir -p /usr/share/icons/filotimo/apps/48
        ln -sf /usr/share/icons/breeze/mimetypes/64/application-vnd.appimage.svg \
              /usr/share/icons/filotimo/apps/48/AppImageLauncher.svg
        mkdir -p /usr/share/icons/filotimo-dark/apps/48
        ln -sf /usr/share/icons/breeze-dark/mimetypes/64/application-vnd.appimage.svg \
              /usr/share/icons/filotimo-dark/apps/48/AppImageLauncher.svg
    else
        mkdir -p /usr/share/icons/filotimo/apps/${size}
        ln -sf /usr/share/icons/breeze/mimetypes/${size}/application-vnd.appimage.svg \
              /usr/share/icons/filotimo/apps/${size}/AppImageLauncher.svg
        mkdir -p /usr/share/icons/filotimo-dark/apps/${size}
        ln -sf /usr/share/icons/breeze-dark/mimetypes/${size}/application-vnd.appimage.svg \
              /usr/share/icons/filotimo-dark/apps/${size}/AppImageLauncher.svg
    fi
done
