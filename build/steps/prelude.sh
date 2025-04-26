#!/usr/bin/bash
set -ouex pipefail

# Get Bazzite's pinned kernel version, export it for build
export KERNEL_VERSION=$(curl -fsSL \
        https://raw.githubusercontent.com/ublue-os/bazzite/refs/heads/main/.github/workflows/build.yml | \
        grep -m1 'kernel_version:' | \
        awk '{gsub(/#.*/,""); print $2}' | \
        xargs)
export KERNEL_FLAVOR="bazzite"

function fetch_akmods_rpms() {
    local repo_url=$1
    local output_dir=$2

    skopeo copy --retry-times 3 docker://"$repo_url" dir:"$output_dir"
    local akmods_targz
    akmods_targz=$(jq -r '.layers[].digest' <"$output_dir"/manifest.json | cut -d : -f 2)
    tar -xvzf "$output_dir"/"$akmods_targz" -C /tmp/
    mv /tmp/rpms/* "$output_dir"/
    # Note: kernel-rpms should auto-extract into correct location
}
