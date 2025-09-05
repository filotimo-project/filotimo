#!/usr/bin/bash
set -ouex pipefail
source /ctx/build/steps/prelude.sh

# Install packages included with system
dnf5 -y install --allowerasing "https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher-2.2.0-travis995.0f91801.x86_64.rpm"
dnf5 -y remove kdenetwork-filesharing # FIXME why is this necessary?
# TODO merged the patches above upstream so this should be removed soon
dnf5 -y install --refresh --allowerasing \
    systemdgenie \
    fedora-logos \
    filotimo-branding \
    filotimo-atychia \
    filotimo-appcompatibilityhelper \
    filotimo-plymouth-theme \
    filotimo-backgrounds \
    msttcore-fonts-installer \
    kdenetwork-filesharing \
    ublue-brew \
    ublue-polkit-rules \
    ublue-recipes \
    ublue-setup-services \
    ublue-os-libvirt-workarounds \
    plasma-discover-rpm-ostree \
    git \
    gh \
    glab \
    nodejs-bash-language-server \
    kleopatra \
    kio-onedrive \
    python3-pip \
    p7zip \
    gstreamer1-plugin-vaapi \
    x265 \
    kde-cdemu-manager-kf6 \
    pipewire-v4l2 \
    libcamera-v4l2 \
    rclone \
    android-tools \
    ifuse \
    printer-driver-brlaser \
    foomatic \
    foomatic-db-ppds \
    foo2zjs \
    freeipa-client \
    samba-dcerpc \
    samba-ldb-ldap-modules \
    samba-winbind-clients \
    samba-winbind-modules \
    samba \
    sssd-ad \
    sssd-ipa \
    sssd-krb5 \
    sssd-nfs-idmap \
    setools-console \
    virt-manager \
    docker \
    fish \
    zsh \
    tldr \
    libreoffice-impress \
    libreoffice-writer \
    libreoffice-calc \
    libreoffice-kf6 \
    steam-devices \
    lm_sensors \
    rsms-inter-fonts \
    rsms-inter-vf-fonts \
    ibm-plex-fonts-all \
    adobe-source-code-pro-fonts \
    adobe-source-han-code-jp-fonts \
    google-noto-color-emoji-fonts \
    google-noto-emoji-fonts \
    google-noto-fonts-all \
    ibmplexmono-nerd-fonts \
    fcitx5 \
    kcm-fcitx5 \
    fcitx5-m17n \
    fcitx5-chinese-addons \
    fcitx5-lua \
    fcitx5-hangul \
    fcitx5-mozc \
    fcitx5-unikey \
    fcitx5-libthai \
    sudo-rs

# Link sudo-rs to the correct places
ln -sf /usr/bin/su-rs /usr/bin/su
ln -sf /usr/bin/sudo-rs /usr/bin/sudo
ln -sf /usr/bin/visudo-rs /usr/bin/visudo

# Remove irrelevant/conflicting packages
# plasma-vault is pretty broken, don't ship this
dnf5 -y remove \
    plasma-welcome-fedora \
    plasma-vault \
    fedora-bookmarks \
    fedora-chromium-config \
    ublue-os-update-services \
    toolbox \
    firefox \
    zram-generator-defaults \
    im-chooser \
    plasma-discover-kns
