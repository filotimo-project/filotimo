#!/usr/bin/bash
set -ouex pipefail

dnf5 -y copr enable che/nerd-fonts
dnf5 -y install nerd-fonts
