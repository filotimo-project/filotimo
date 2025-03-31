#!/usr/bin/bash
set -ouex pipefail

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
