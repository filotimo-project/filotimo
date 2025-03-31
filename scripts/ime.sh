#!/bin/bash
set -ouex pipefail

dnf5 -y install \
    fcitx5 kcm-fcitx5 \
    fcitx5-m17n \
    fcitx5-chinese-addons \
    fcitx5-lua \
    fcitx5-hangul \
    fcitx5-mozc \
    fcitx5-unikey \
    fcitx5-libthai

dnf5 -y remove im-chooser
