# Create a new distrobox containing a KDE development environment.
setup-kde-dev:
    #!/usr/bin/bash
    set -e
    printf "A distrobox will be created with the name kde-dev.\n"
    printf "You will be placed in this distrobox on completion of this recipe.\n\n"
    sleep 2
    distrobox create --name kde-dev --init --additional-packages "systemd" --image ghcr.io/ublue-os/fedora-toolbox:latest
    podman start kde-dev
    sleep 20
    podman exec -it --user "$USER" kde-dev bash -c '
    sudo dnf install -y --no-gpgchecks librsvg2-devel hunspell-devel clang-tools-extra clang cmake make gdb ninja git git-clang-format qt6-*-devel qt5-*-devel opencv-devel mpv-libs-devel openh264 "pkgconfig(libavcodec)" "pkgconfig(libavfilter)" "pkgconfig(libavformat)" rsms-inter-fonts rsms-inter-vf-fonts ibm-plex-fonts-all plasma-breeze

    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> ~/.zshrc
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> ~/.bashrc
    fi
    source ~/.bashrc
    export PATH="$HOME/.local/bin:$PATH"
    cd ~
    curl "https://invent.kde.org/sdk/kde-builder/-/raw/master/scripts/initial_setup.sh?ref_type=heads" > initial_setup.sh
    yes | bash initial_setup.sh
    rm initial_setup.sh
    yes | kde-builder --generate-config
    yes | kde-builder --install-distro-packages
    printf "Plasma Desktop will now be built from master. This may take a while.\n\n"
    sleep 2
    yes | kde-builder workspace
    printf "Complete! Run ujust install-kde-session outside the distrobox to install the session file to allow you to enter the Plasma development workspace.\n"'

# Installs the session file to run a KDE development environment from SDDM. Requires setup-kde-dev
install-kde-dev-session:
    #!/usr/bin/bash
    podman container start kde-dev
    if ! podman container exec kde-dev test -f /usr/local/share/wayland-sessions/plasmawayland-dev6.desktop; then
        printf "The file '/usr/local/share/wayland-sessions/plasmawayland-dev6.desktop' does not exist in the KDE development container distrobox.\nYou will need to run ujust setup-kde-dev first.\n"
        exit 1
    fi
    printf "This will set up an overlayfs over /usr, making it temporarily mutable until the next reboot. This recipe will need to be run again on every reboot.\n"
    sudo bootc usr-overlay
    echo 'chown -f -R $USER:$USER /tmp/.X11-unix' | sudo tee /etc/profile.d/set_tmp_x11_permissions.sh > /dev/null
    podman container cp kde-dev:/usr/local/share/wayland-sessions/plasmawayland-dev6.desktop ~/
    sed -i "s@^Exec=.*@Exec=$HOME/.local/bin/start-plasma-dev-session@" ~/plasmawayland-dev6.desktop
    sudo mv ~/plasmawayland-dev6.desktop /usr/share/wayland-sessions
    echo "$HOME/kde/usr/lib64/libexec/kactivitymanagerd & disown
    $HOME/kde/usr/lib64/libexec/plasma-dbus-run-session-if-needed $HOME/kde/usr/lib64/libexec/startplasma-dev.sh -wayland" > ~/.local/bin/start-plasma-dev-session
    chmod +x ~/.local/bin/start-plasma-dev-session
    printf "Complete! Log out to see the Plasma development session in SDDM.\n"

reinstall-system-flatpaks:
    #!/usr/bin/bash
    flatpak remote-delete --system fedora || true
    flatpak remote-delete --system fedora-testing || true
    flatpak remote-add --system --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true
    FLATPAK_LIST="$(curl https://raw.githubusercontent.com/filotimo-project/filotimo/refs/heads/main/flatpaks/flatpaks | sed 's/x86_64/$(arch)/g' | tr '\n' ' ')"
    flatpak --system -y install --or-update ${FLATPAK_LIST}
