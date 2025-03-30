#!/usr/bin/bash
set -ouex pipefail

dnf5 -y install \
    rsms-inter-fonts \
    rsms-inter-vf-fonts \
    ibm-plex-fonts-all \
    adobe-source-code-pro-fonts \
    adobe-source-han-code-jp-fonts \
    google-noto-color-emoji-fonts \
    google-noto-emoji-fonts \
    google-noto-fonts-all

dnf5 -y copr enable che/nerd-fonts
dnf5 -y install nerd-fonts
dnf5 -y copr disable che/nerd-fonts
