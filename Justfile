export image_name := env("IMAGE_NAME", "filotimo")
export fedora_version := env("FEDORA_VERSION", "42")
export default_tag := env("DEFAULT_TAG", "latest")
export bib_image := env("BIB_IMAGE", "quay.io/centos-bootc/bootc-image-builder:latest")

alias build-vm := build-qcow2
alias rebuild-vm := rebuild-qcow2
alias run-vm := run-vm-qcow2

[private]
default:
    @just --list

# Check Just Syntax
[group('Just')]
check:
    #!/usr/bin/bash
    find . -type f -name "*.just" | while read -r file; do
    	echo "Checking syntax: $file"
    	just --unstable --fmt --check -f $file
    done
    echo "Checking syntax: Justfile"
    just --unstable --fmt --check -f Justfile

# Fix Just Syntax
[group('Just')]
fix:
    #!/usr/bin/bash
    find . -type f -name "*.just" | while read -r file; do
    	echo "Checking syntax: $file"
    	just --unstable --fmt -f $file
    done
    echo "Checking syntax: Justfile"
    just --unstable --fmt -f Justfile || { exit 1; }

# Clean Repo
[group('Utility')]
clean:
    #!/usr/bin/bash
    set -eoux pipefail
    touch _build
    find *_build* -exec rm -rf {} \;
    rm -f previous.manifest.json
    rm -f changelog.md
    rm -f output.env
    rm -f output/

# Sudo Clean Repo
[group('Utility')]
[private]
sudo-clean:
    sudo just clean

# This Justfile recipe builds a container image using Podman.
#
# Arguments:
#   $target_image - The tag you want to apply to the image (default: filotimo).
#   $tag - The tag for the image (default: latest).
#
# just build $target_image $tag
#
# Example usage:
#   just build filotimo-nvidia latest
#
# This will build an image 'filotimo-nvidia:latest'.
#

# Build the image using the specified parameters
build $target_image=image_name $tag=default_tag:
    #!/usr/bin/env bash

    BUILD_ARGS=()
    BUILD_ARGS+=("--build-arg" "FEDORA_MAJOR_VERSION=${fedora_version}")
    BUILD_ARGS+=("--build-arg" "IMAGE_NAME=${target_image}")
    BUILD_ARGS+=("--build-arg" "IMAGE_TAG=${tag}")

    podman build \
        "${BUILD_ARGS[@]}" \
        --pull=newer \
        --tag "${target_image}:${tag}" \
        .

# This Justfile recipe builds an installation ISO using build-container-installer.
#
# Arguments:
#   $target_image - The image you want to create an installer for (default: filotimo).
#   $tag - The tag for the image (default: latest).
#
# Example usage:
#   just build-installer filotimo-nvidia latest
#
# This will build an installer for the image 'filotimo-nvidia:latest'.
#

# Build an installation ISO using build-container-installer
build-installer $target_image=image_name $tag=default_tag:
    #!/usr/bin/env bash

    cd "$(git rev-parse --show-toplevel)"

    curl -fSsO "https://copr.fedorainfracloud.org/coprs/tduck973564/filotimo-packages/repo/fedora-${fedora_version}/tduck973564-filotimo-packages-fedora-${fedora_version}.repo"
    sed -i '/^priority=50$/s/50/1/' tduck973564-filotimo-packages-fedora-${fedora_version}.repo

    image="ghcr.io/filotimo-project/$target_image:latest"

    # Make temp space
    TEMP_FLATPAK_INSTALL_DIR=$(mktemp -d -p "$(pwd)" flatpak.XXX)

    # Get list of refs from directory
    FLATPAK_REFS_DIR="$(pwd)"/flatpaks
    FLATPAK_REFS_DIR_LIST=$(cat ${FLATPAK_REFS_DIR}/* | tr '\n' ' ' )

    # Generate install script
    echo "cat /temp_flatpak_install_dir/script.sh" > ${TEMP_FLATPAK_INSTALL_DIR}/script.sh
    echo "mkdir -p /flatpak/flatpak /flatpak/triggers" >> ${TEMP_FLATPAK_INSTALL_DIR}/script.sh
    echo "mkdir /var/tmp || true" >> ${TEMP_FLATPAK_INSTALL_DIR}/script.sh
    echo "chmod -R 1777 /var/tmp" >> ${TEMP_FLATPAK_INSTALL_DIR}/script.sh
    echo "flatpak config --system --set languages \"*\"" >> ${TEMP_FLATPAK_INSTALL_DIR}/script.sh
    echo "flatpak remote-delete --system fedora || true" >> ${TEMP_FLATPAK_INSTALL_DIR}/script.sh
    echo "flatpak remote-add --system flathub https://dl.flathub.org/repo/flathub.flatpakrepo" >> ${TEMP_FLATPAK_INSTALL_DIR}/script.sh
    echo "flatpak install --system -y ${FLATPAK_REFS_DIR_LIST}" >> ${TEMP_FLATPAK_INSTALL_DIR}/script.sh
    echo "ostree refs --repo=\${FLATPAK_SYSTEM_DIR}/repo | grep '^deploy/' | grep -v 'org\\.freedesktop\\.Platform\\.openh264' | sed 's/^deploy\\///g' > /output/flatpaks-with-deps" >> ${TEMP_FLATPAK_INSTALL_DIR}/script.sh

    sudo podman run --rm --privileged \
    --entrypoint bash \
    -e FLATPAK_SYSTEM_DIR=/flatpak/flatpak \
    -e FLATPAK_TRIGGERSDIR=/flatpak/triggers \
    --volume ${FLATPAK_REFS_DIR}:/output \
    --volume ${TEMP_FLATPAK_INSTALL_DIR}:/temp_flatpak_install_dir \
    ${image} /temp_flatpak_install_dir/script.sh
    sudo podman rmi ${image}
    rm -rf "$TEMP_FLATPAK_INSTALL_DIR"

    # FIXME put proper version back if/when anaconda starts working again
    sudo podman run --name=container-installer --replace --privileged \
        --volume "$(pwd)":"/github/workspace/" ghcr.io/jasonn3/build-container-installer:d9934090914f1937b167dae98b16a09fe99da48b \
        ADDITIONAL_TEMPLATES="/github/workspace/lorax_templates/remove_root_password_prompt.tmpl" \
        ARCH="x86_64" \
        ENABLE_CACHE_DNF="false" \
        ENABLE_CACHE_SKOPEO="false" \
        IMAGE_NAME="$target_image" \
        IMAGE_REPO="ghcr.io/filotimo-project" \
        IMAGE_TAG="$tag" \
        VERSION="41" \
        VARIANT="kinoite" \
        ISO_NAME="$target_image-$tag.iso" \
        SECURE_BOOT_KEY_URL="https://github.com/ublue-os/akmods/raw/main/certs/public_key.der" \
        ENROLLMENT_PASSWORD="universalblue" \
        FLATPAK_REMOTE_NAME="flathub" \
        FLATPAK_REMOTE_URL="https://dl.flathub.org/repo/flathub.flatpakrepo" \
        FLATPAK_REMOTE_REFS_DIR="/github/workspace/flatpaks" \
        ENABLE_FLATPAK_DEPENDENCIES="false" \
        REPOS="/github/workspace/tduck973564-filotimo-packages-fedora-$fedora_version.repo /etc/yum.repos.d/fedora.repo /etc/yum.repos.d/fedora-updates.repo"

    rm -f ./tduck973564-filotimo-packages-fedora-$fedora_version.repo

    sudo podman cp container-installer:/build-container-installer/"$target_image"-$tag.iso ./
    sudo podman cp container-installer:/build-container-installer/"$target_image"-$tag.iso-CHECKSUM ./

# Command: _rootful_load_image
# Description: This script checks if the current user is root or running under sudo. If not, it attempts to resolve the image tag using podman inspect.
#              If the image is found, it loads it into rootful podman. If the image is not found, it pulls it from the repository.
#
# Parameters:
#   $target_image - The name of the target image to be loaded or pulled.
#   $tag - The tag of the target image to be loaded or pulled. Default is 'default_tag'.
#
# Example usage:
#   _rootful_load_image my_image latest
#
# Steps:
# 1. Check if the script is already running as root or under sudo.
# 2. Check if target image is in the non-root podman container storage)
# 3. If the image is found, load it into rootful podman using podman scp.
# 4. If the image is not found, pull it from the remote repository into reootful podman.

_rootful_load_image $target_image=image_name $tag=default_tag:
    #!/usr/bin/bash
    set -eoux pipefail

    # Check if already running as root or under sudo
    if [[ -n "${SUDO_USER:-}" || "${UID}" -eq "0" ]]; then
        echo "Already root or running under sudo, no need to load image from user podman."
        exit 0
    fi

    # Try to resolve the image tag using podman inspect
    set +e
    resolved_tag=$(podman inspect -t image "${target_image}:${tag}" | jq -r '.[].RepoTags.[0]')
    return_code=$?
    set -e

    USER_IMG_ID=$(podman images --filter reference="${target_image}:${tag}" --format "'{{ '{{.ID}}' }}'")

    if [[ $return_code -eq 0 ]]; then
        # If the image is found, load it into rootful podman
        ID=$(sudo podman images --filter reference="${target_image}:${tag}" --format "'{{ '{{.ID}}' }}'")
        if [[ "$ID" != "$USER_IMG_ID" ]]; then
            # If the image ID is not found or different from user, copy the image from user podman to root podman
            COPYTMP=$(mktemp -p "${PWD}" -d -t _build_podman_scp.XXXXXXXXXX)
            sudo TMPDIR=${COPYTMP} podman image scp ${UID}@localhost::"${target_image}:${tag}" root@localhost::"${target_image}:${tag}"
            rm -rf "${COPYTMP}"
        fi
    else
        # If the image is not found, pull it from the repository
        sudo podman pull "${target_image}:${tag}"
    fi

# Build a bootc bootable image using Bootc Image Builder (BIB)
# Converts a container image to a bootable image
# Parameters:
#   target_image: The name of the image to build (ex. localhost/fedora)
#   tag: The tag of the image to build (ex. latest)
#   type: The type of image to build (ex. qcow2, raw, iso)
#   config: The configuration file to use for the build (default: bib_image_config.toml)

# Example: just _rebuild-bib localhost/fedora latest qcow2 bib_image_config.toml
_build-bib $target_image $tag $type $config: (_rootful_load_image target_image tag)
    #!/usr/bin/env bash
    set -euo pipefail

    args="--type ${type} "
    args+="--use-librepo=True "
    args+="--rootfs=btrfs"

    if [[ $target_image == localhost/* ]]; then
        args+=" --local"
    fi

    BUILDTMP=$(mktemp -p "${PWD}" -d -t _build-bib.XXXXXXXXXX)

    sudo podman run \
      --rm \
      -it \
      --privileged \
      --pull=newer \
      --net=host \
      --security-opt label=type:unconfined_t \
      -v $(pwd)/${config}:/config.toml:ro \
      -v $BUILDTMP:/output \
      -v /var/lib/containers/storage:/var/lib/containers/storage \
      "${bib_image}" \
      ${args} \
      "${target_image}:${tag}"

    mkdir -p output
    sudo mv -f $BUILDTMP/* output/
    sudo rmdir $BUILDTMP
    sudo chown -R $USER:$USER output/

# Podman builds the image from the Containerfile and creates a bootable image
# Parameters:
#   target_image: The name of the image to build (ex. localhost/fedora)
#   tag: The tag of the image to build (ex. latest)
#   type: The type of image to build (ex. qcow2, raw, iso)
#   config: The configuration file to use for the build (deafult: bib_image_config.toml)

# Example: just _rebuild-bib localhost/fedora latest qcow2 bib_image_config.toml
_rebuild-bib $target_image $tag $type $config: (build target_image tag) && (_build-bib target_image tag type config)

# Build a QCOW2 virtual machine image
[group('Build Virtal Machine Image')]
build-qcow2 $target_image=("localhost/" + image_name) $tag=default_tag: && (_build-bib target_image tag "qcow2" "bib_image_config.toml")

# Build a RAW virtual machine image
[group('Build Virtal Machine Image')]
build-raw $target_image=("localhost/" + image_name) $tag=default_tag: && (_build-bib target_image tag "raw" "bib_image_config.toml")

# Build an ISO virtual machine image
[group('Build Virtal Machine Image')]
build-iso $target_image=("localhost/" + image_name) $tag=default_tag: && (_build-bib target_image tag "iso" "bib_iso_config.toml")

# Rebuild a QCOW2 virtual machine image
[group('Build Virtal Machine Image')]
rebuild-qcow2 $target_image=("localhost/" + image_name) $tag=default_tag: && (_rebuild-bib target_image tag "qcow2" "bib_image_config.toml")

# Rebuild a RAW virtual machine image
[group('Build Virtal Machine Image')]
rebuild-raw $target_image=("localhost/" + image_name) $tag=default_tag: && (_rebuild-bib target_image tag "raw" "bib_image_config.toml")

# Rebuild an ISO virtual machine image
[group('Build Virtal Machine Image')]
rebuild-iso $target_image=("localhost/" + image_name) $tag=default_tag: && (_rebuild-bib target_image tag "iso" "bib_iso_config.toml")

# Run a virtual machine with the specified image type and configuration
_run-vm $target_image $tag $type $config:
    #!/usr/bin/bash
    set -eoux pipefail

    # Determine the image file based on the type
    image_file="output/${type}/disk.${type}"
    if [[ $type == iso ]]; then
        image_file="output/bootiso/install.iso"
    fi

    # Build the image if it does not exist
    if [[ ! -f "${image_file}" ]]; then
        just "build-${type}" "$target_image" "$tag"
    fi

    # Determine an available port to use
    port=8006
    while grep -q :${port} <<< $(ss -tunalp); do
        port=$(( port + 1 ))
    done
    echo "Using Port: ${port}"
    echo "Connect to http://localhost:${port}"

    # Set up the arguments for running the VM
    run_args=()
    run_args+=(--rm --privileged)
    run_args+=(--pull=newer)
    run_args+=(--publish "127.0.0.1:${port}:8006")
    run_args+=(--env "CPU_CORES=4")
    run_args+=(--env "RAM_SIZE=8G")
    run_args+=(--env "DISK_SIZE=64G")
    run_args+=(--env "TPM=Y")
    run_args+=(--env "GPU=Y")
    run_args+=(--device=/dev/kvm)
    run_args+=(--volume "${PWD}/${image_file}":"/boot.${type}")
    run_args+=(docker.io/qemux/qemu-docker)

    # Run the VM and open the browser to connect
    (sleep 30 && xdg-open http://localhost:"$port") &
    podman run "${run_args[@]}"

# Run a virtual machine from a QCOW2 image
[group('Run Virtal Machine')]
run-vm-qcow2 $target_image=("localhost/" + image_name) $tag=default_tag: && (_run-vm target_image tag "qcow2" "bib_image_config.toml")

# Run a virtual machine from a RAW image
[group('Run Virtal Machine')]
run-vm-raw $target_image=("localhost/" + image_name) $tag=default_tag: && (_run-vm target_image tag "raw" "bib_image_config.toml")

# Run a virtual machine from an ISO
[group('Run Virtal Machine')]
run-vm-iso $target_image=("localhost/" + image_name) $tag=default_tag: && (_run-vm target_image tag "iso" "bib_iso_config.toml")

# Run a virtual machine using systemd-vmspawn
[group('Run Virtal Machine')]
spawn-vm rebuild="0" type="qcow2" ram="6G":
    #!/usr/bin/env bash

    set -euo pipefail

    [ "{{ rebuild }}" -eq 1 ] && echo "Rebuilding the ISO" && just build-vm {{ rebuild }} {{ type }}

    systemd-vmspawn \
      -M "bootc-image" \
      --console=gui \
      --cpus=2 \
      --ram=$(echo {{ ram }}| /usr/bin/numfmt --from=iec) \
      --network-user-mode \
      --vsock=false --pass-ssh-key=false \
      -i ./output/**/*.{{ type }}

# Runs shell check on all Bash scripts
lint:
    /usr/bin/find . -iname "*.sh" -type f -exec shellcheck "{}" ';'

# Runs shfmt on all Bash scripts
format:
    /usr/bin/find . -iname "*.sh" -type f -exec shfmt --write "{}" ';'
