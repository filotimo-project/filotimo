#!/usr/bin/bash
set -ouex pipefail

export copr_repositories=(
    "rok/cdemu"
    "ssweeny/system76-hwe"
    "ublue-os/packages"
    "tduck973564/filotimo-packages"
    "rodoma92/kde-cdemu-manager"
    "zawertun/kde-kup"
    "bernardogn/kio-onedrive"
    "che/nerd-fonts"
    "hikariknight/looking-glass-kvmfr"
)
# URL-based repositories
export url_repositories=(
    "https://terra.fyralabs.com/terra.repo"
)
