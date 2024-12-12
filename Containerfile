ARG IMAGE_NAME="${IMAGE_NAME:-filotimo}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-41}"
ARG KERNEL_FLAVOR="${KERNEL_FLAVOR:-bazzite}"
# Fetch this dynamically outside the containerfile - use the build script
ARG KERNEL_VERSION="${KERNEL_VERSION:-6.11.4-301.bazzite.fc41.x86_64}"
ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-kinoite-main}"
ARG SOURCE_ORG="${SOURCE_ORG:-ublue-os}"
ARG BASE_IMAGE="ghcr.io/${SOURCE_ORG}/${BASE_IMAGE_NAME}"
ARG IMAGE_VENDOR="${IMAGE_VENDOR:-filotimo}"
ARG IMAGE_TAG="${IMAGE_TAG:-latest}"

FROM ghcr.io/ublue-os/${KERNEL_FLAVOR}-kernel:${FEDORA_MAJOR_VERSION}-${KERNEL_VERSION} AS kernel
FROM ghcr.io/ublue-os/akmods:${KERNEL_FLAVOR}-${FEDORA_MAJOR_VERSION}-${KERNEL_VERSION} AS akmods
FROM ghcr.io/ublue-os/akmods-extra:${KERNEL_FLAVOR}-${FEDORA_MAJOR_VERSION}-${KERNEL_VERSION} AS akmods-extra

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} as filotimo

ARG IMAGE_NAME="${IMAGE_NAME:-filotimo}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-41}"
ARG KERNEL_FLAVOR="${KERNEL_FLAVOR:-bazzite}"
# Fetch this dynamically outside the containerfile - use the build script
ARG KERNEL_VERSION="${KERNEL_VERSION:-6.11.4-301.bazzite.fc41.x86_64}"
ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-kinoite-main}"
ARG SOURCE_ORG="${SOURCE_ORG:-ublue-os}"
ARG BASE_IMAGE="ghcr.io/${SOURCE_ORG}/${BASE_IMAGE_NAME}"
ARG IMAGE_VENDOR="${IMAGE_VENDOR:-filotimo}"
ARG IMAGE_TAG="${IMAGE_TAG:-latest}"

# Fix build skew
RUN --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=cache,dst=/var/cache/rpm-ostree \
    dnf5 -y upgrade \
        --repo=updates \
        qt6-qtbase \
        qt6-qtbase-common \
        qt6-qtbase-mysql \
        qt6-qtbase-gui || true && \
    dnf5 -y upgrade \
        --repo=updates \
        elfutils-libelf \
        elfutils-libs || true && \
    dnf5 -y upgrade \
        --repo=updates \
        glibc || true && \
    ostree container commit

# Install kernel
RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=kernel,src=/tmp/rpms,dst=/tmp/fsync-rpms \
    rpm-ostree cliwrap install-to-root / && \
    rpm-ostree override replace \
    --experimental \
        /tmp/fsync-rpms/kernel-[0-9]*.rpm \
        /tmp/fsync-rpms/kernel-core-*.rpm \
        /tmp/fsync-rpms/kernel-modules-*.rpm \
        /tmp/fsync-rpms/kernel-devel-*.rpm \
        /tmp/fsync-rpms/kernel-uki-virt-*.rpm && \
    ostree container commit

# Install akmod rpms for various firmware and features
# https://github.com/ublue-os/bazzite/blob/main/Containerfile#L309
RUN --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=akmods,src=/rpms,dst=/tmp/akmods-rpms \
    --mount=type=bind,from=akmods-extra,src=/rpms,dst=/tmp/akmods-extra-rpms \
    sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr_ublue-os-akmods.repo && \
    dnf5 -y copr enable rok/cdemu && \
    dnf5 -y install \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    dnf5 -y install \
        /tmp/akmods-rpms/kmods/*xone*.rpm \
        /tmp/akmods-rpms/kmods/*openrazer*.rpm \
        /tmp/akmods-rpms/kmods/*v4l2loopback*.rpm \
        /tmp/akmods-rpms/kmods/*wl*.rpm \
        /tmp/akmods-extra-rpms/kmods/*gcadapter_oc*.rpm \
        /tmp/akmods-extra-rpms/kmods/*nct6687*.rpm \
        /tmp/akmods-extra-rpms/kmods/*zenergy*.rpm \
        /tmp/akmods-extra-rpms/kmods/*vhba*.rpm \
        /tmp/akmods-extra-rpms/kmods/*ayaneo-platform*.rpm \
        /tmp/akmods-extra-rpms/kmods/*ayn-platform*.rpm \
        /tmp/akmods-extra-rpms/kmods/*bmi260*.rpm \
        /tmp/akmods-extra-rpms/kmods/*ryzen-smu*.rpm \
        /tmp/akmods-extra-rpms/kmods/*evdi*.rpm && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_ublue-os-akmods.repo && \
    dnf5 -y remove \
        rpmfusion-free-release \
        rpmfusion-nonfree-release && \
    ostree container commit

# Some mediatek firmware that I don't really know about
# https://github.com/ublue-os/bluefin/blob/main/build_files/firmware.sh
RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    mkdir -p /tmp/mediatek-firmware && \
    curl -Lo /tmp/mediatek-firmware/WIFI_MT7922_patch_mcu_1_1_hdr.bin "https://gitlab.com/kernel-firmware/linux-firmware/-/raw/8f08053b2a7474e210b03dbc2b4ba59afbe98802/mediatek/WIFI_MT7922_patch_mcu_1_1_hdr.bin?inline=false" && \
    curl -Lo /tmp/mediatek-firmware/WIFI_RAM_CODE_MT7922_1.bin "https://gitlab.com/kernel-firmware/linux-firmware/-/raw/8f08053b2a7474e210b03dbc2b4ba59afbe98802/mediatek/WIFI_RAM_CODE_MT7922_1.bin?inline=false" && \
    xz --check=crc32 /tmp/mediatek-firmware/WIFI_MT7922_patch_mcu_1_1_hdr.bin && \
    xz --check=crc32 /tmp/mediatek-firmware/WIFI_RAM_CODE_MT7922_1.bin && \
    mv -vf /tmp/mediatek-firmware/* /usr/lib/firmware/mediatek/ && \
    rm -rf /tmp/mediatek-firmware && \
    ostree container commit

# Install important repos
RUN --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=cache,dst=/var/cache/rpm-ostree \
    echo "${FEDORA_MAJOR_VERSION}" && \
    curl -Lo /etc/yum.repos.d/klassy.repo https://download.opensuse.org/repositories/home:/paul4us/Fedora_"${FEDORA_MAJOR_VERSION}"/home:paul4us.repo && \
    curl -Lo /etc/yum.repos.d/terra.repo https://terra.fyralabs.com/terra.repo && \
    dnf5 -y copr enable rodoma92/kde-cdemu-manager && \
    dnf5 -y copr enable tduck973564/filotimo-packages && \
    ostree container commit

COPY temp_packages /tmp/temp_packages
# Install Filotimo packages
RUN --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=cache,dst=/var/cache/rpm-ostree \
    dnf5 -y install --allowerasing /tmp/temp_packages/*.rpm && \
    dnf5 -y install --allowerasing \
        onedriver \
        filotimo-branding \
        filotimo-atychia && \
    dnf5 -y remove plasma-welcome-fedora && \
    rm -rf /tmp/temp_packages && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/terra.repo && \
    dnf5 -y copr disable tduck973564/filotimo-packages && \
    ostree container commit

# Install misc. packages
RUN --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=cache,dst=/var/cache/rpm-ostree \
    dnf5 -y remove \
        ublue-os-update-services \
        toolbox kcron \
        firefox && \
    dnf5 -y install \
        plasma-discover-rpm-ostree \
        distrobox \
        git gh glab \
        nodejs-bash-language-server \
        kdenetwork-filesharing \
        ark \
        kio-admin \
        kleopatra \
        firewall-config \
        openssl openssl-libs \
        python3-pip \
        i2c-tools \
        p7zip \
        unzip \
        unrar \
        gstreamer1-plugins-good gstreamer1-plugin-vaapi gstreamer1-plugin-libav \
        x265 \
        ffmpeg \
        kde-cdemu-manager-kf6 \
        v4l2loopback pipewire-v4l2 libcamera-v4l2 \
        samba samba-usershares samba-dcerpc samba-ldb-ldap-modules samba-winbind-clients samba-winbind-modules \
        rclone \
        mesa-libGLU \
        usbmuxd \
        stress-ng \
        epson-inkjet-printer-escpr \
        epson-inkjet-printer-escpr2 \
        foomatic \
        foomatic-db-ppds \
        gutenprint \
        hplip \
        libimobiledevice \
        android-tools \
        htop \
        virt-manager \
        podman docker \
        fish zsh tldr \
        libreoffice && \
    dnf5 -y copr disable rodoma92/kde-cdemu-manager && \
    dnf5 -y copr disable rok/cdemu && \
    ostree container commit

# Consolidate and install justfiles
COPY just /tmp/just
RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    find /tmp/just -iname '*.just' -exec printf "\n\n" \; -exec cat {} \; >> /usr/share/ublue-os/just/60-custom.just

# Copy in added system files
COPY system_files /tmp/system_files
RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    rsync -rvK /tmp/system_files/ /

# Add modifications and finalize
COPY scripts /tmp/scripts
RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    mkdir -p /var/lib/alternatives && \
    cd /tmp/scripts && \
    ./build-base.sh && \
    ./build-initramfs.sh && \
    IMAGE_FLAVOR="main" ./image-info.sh && \
    ostree container commit

# Generate NVIDIA image
FROM ghcr.io/ublue-os/akmods-nvidia:${KERNEL_FLAVOR}-${FEDORA_MAJOR_VERSION}-${KERNEL_VERSION} AS nvidia-akmods

FROM filotimo as filotimo-nvidia

ARG IMAGE_NAME="${IMAGE_NAME:-filotimo}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-41}"
ARG KERNEL_FLAVOR="${KERNEL_FLAVOR:-bazzite}"
# Fetch this dynamically outside the containerfile - use the build script
ARG KERNEL_VERSION="${KERNEL_VERSION:-6.11.4-301.bazzite.fc41.x86_64}"
ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-kinoite-main}"
ARG SOURCE_ORG="${SOURCE_ORG:-ublue-os}"
ARG BASE_IMAGE="ghcr.io/${SOURCE_ORG}/${BASE_IMAGE_NAME}"
ARG IMAGE_VENDOR="${IMAGE_VENDOR:-filotimo}"
ARG IMAGE_TAG="${IMAGE_TAG:-latest}"

# Install NVIDIA driver, use different copr repo for kf6 supergfxctl plasmoid
# TODO only install supergfxctl on hybrid systems or find some way to only show it on hybrid systems
# it's confusing visual noise outside of that context
# https://github.com/ublue-os/hwe/
# https://github.com/ublue-os/bazzite/blob/main/Containerfile#L950
RUN --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=nvidia-akmods,src=/rpms,dst=/tmp/akmods-rpms \
    dnf5 -y copr enable jhyub/supergfxctl-plasmoid && \
    sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/negativo17-fedora-multimedia.repo && \
    dnf5 -y install \
        mesa-vdpau-drivers.x86_64 \
        mesa-vdpau-drivers.i686 && \
    curl -Lo /tmp/nvidia-install.sh https://raw.githubusercontent.com/ublue-os/hwe/main/nvidia-install.sh && \
    chmod +x /tmp/nvidia-install.sh && \
    IMAGE_NAME="kinoite" /tmp/nvidia-install.sh && \
    dnf5 -y install nvidia-vaapi-driver && \
    systemctl enable supergfxd && \
    dnf5 -y copr disable jhyub/supergfxctl-plasmoid && \
    ostree container commit

COPY scripts /tmp/scripts

# Finalize
RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    cd /tmp/scripts && \
    ./build-initramfs.sh && \
    IMAGE_FLAVOR="nvidia" ./image-info.sh && \
    ./integrate-supergfxctl-plasmoid.sh && \
    ostree container commit
