#!/usr/bin/bash
set -ouex pipefail

./systemd-services.sh
./misc-fixes.sh
./fish-shell.sh
./brew.sh
