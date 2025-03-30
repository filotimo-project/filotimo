#!/usr/bin/bash
set -ouex pipefail

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
