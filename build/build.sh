#!/usr/bin/bash
set -ouex pipefail

# Copy system files into the image
rsync -lrvK /ctx/root/ /

# Consolidate and install system justfiles
find /ctx/just -iname '*.just' -exec printf "\n\n" \; -exec cat {} \; >> /usr/share/ublue-os/just/60-custom.just

# Execute all shell scripts starting with a number in order
shopt -s nullglob
for script in /ctx/build/steps/[0-9][0-9]_*.sh; do
    if [[ -x "$script" ]]; then
        echo "::group:: ===$(basename "$script")==="
        "$script"
        echo "::endgroup::"
    else
        echo "$script is not executable!"
        exit 1
    fi
done

# Finish up
ostree container commit
