#!/usr/bin/bash
set -ouex pipefail
source /ctx/build/steps/prelude.sh

# FIXME: Temporary workaround for no python3-libfuse upstream
dnf5 -y install "https://download.copr.fedorainfracloud.org/results/zawertun/kde-kup/fedora-41-x86_64/08095873-python-libfuse/python3-libfuse-1.0.8-1.fc41.x86_64.rpm"

# Install packages included with system
dnf5 -y install --allowerasing /ctx/packages/*.rpm
dnf5 -y install --allowerasing \
    systemdgenie \
    fedora-logos \
    filotimo-branding \
    filotimo-atychia \
    filotimo-plymouth-theme \
    filotimo-backgrounds \
    msttcore-fonts-installer \
    ublue-brew \
    ublue-polkit-rules \
    ublue-recipes \
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
    kde-kup \
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
    fcitx5-libthai

# Remove irrelevant/conflicting packages
dnf5 -y remove \
    plasma-welcome-fedora \
    ublue-os-update-services \
    toolbox \
    firefox \
    zram-generator-defaults \
    im-chooser
