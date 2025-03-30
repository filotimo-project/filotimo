#!/usr/bin/bash
set -ouex pipefail

./ime.sh
./fonts.sh
./systemd-services.sh
./misc-fixes.sh
./icon-changes.sh
./fish-shell.sh
./brew.sh
