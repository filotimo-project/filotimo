cat /temp_flatpak_install_dir/script.sh
mkdir -p /flatpak/flatpak /flatpak/triggers
mkdir /var/tmp || true
chmod -R 1777 /var/tmp
flatpak config --system --set languages "*"
flatpak remote-add --system flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --system -y app/org.mozilla.Thunderbird/x86_64/stable app/org.mozilla.firefox/x86_64/stable app/com.github.wwmm.easyeffects/x86_64/stable app/org.videolan.VLC/x86_64/stable app/org.kde.isoimagewriter/x86_64/stable app/org.kde.kclock/x86_64/stable app/org.kde.kweather/x86_64/stable app/org.kde.francis/x86_64/stable app/org.kde.skanpage/x86_64/stable app/org.kde.gwenview/x86_64/stable app/org.kde.kamoso/x86_64/stable app/org.kde.elisa/x86_64/stable app/org.kde.kolourpaint/x86_64/stable app/org.kde.kcolorchooser/x86_64/stable app/org.kde.ktorrent/x86_64/stable app/org.kde.klevernotes/x86_64/stable app/org.kde.kcalc/x86_64/stable app/org.kde.krdc/x86_64/stable app/org.kde.okular/x86_64/stable app/org.kde.arianna/x86_64/stable 
ostree refs --repo=${FLATPAK_SYSTEM_DIR}/repo | grep '^deploy/' | grep -v 'org\.freedesktop\.Platform\.openh264' | sed 's/^deploy\///g' > /output/flatpaks_with_deps
