#!/usr/bin/bash
set -ouex pipefail
source /ctx/build/steps/prelude.sh

# Get akmods + akmods-extra first
fetch_akmods_rpms "ghcr.io/ublue-os/akmods:${KERNEL_FLAVOR}-${FEDORA_MAJOR_VERSION}-${KERNEL_VERSION}" /tmp/akmods
fetch_akmods_rpms "ghcr.io/ublue-os/akmods-extra:${KERNEL_FLAVOR}-${FEDORA_MAJOR_VERSION}-${KERNEL_VERSION}" /tmp/akmods-extra

# Install kernel -- which extracts itself into /tmp/kernel-rpms
dnf5 -y remove --no-autoremove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-tools kernel-tools-libs kernel-uki-virt
dnf5 -y install \
    /tmp/kernel-rpms/kernel-[0-9]*.rpm \
    /tmp/kernel-rpms/kernel-core-*.rpm \
    /tmp/kernel-rpms/kernel-modules-*.rpm \
    /tmp/kernel-rpms/kernel-tools-[0-9]*.rpm \
    /tmp/kernel-rpms/kernel-tools-libs-[0-9]*.rpm \
    /tmp/kernel-rpms/kernel-devel-*.rpm
dnf5 versionlock add kernel kernel-devel kernel-devel-matched kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-tools kernel-tools-libs

# Install kernel modules
sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr_ublue-os-akmods.repo

# Some modules require rpmfusion, so install it first then remove it later
dnf5 -y install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"${FEDORA_MAJOR_VERSION}".noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"${FEDORA_MAJOR_VERSION}".noarch.rpm

dnf5 -y install \
    /tmp/akmods/kmods/*kvmfr*.rpm \
    /tmp/akmods/kmods/*framework-laptop*.rpm \
    /tmp/akmods/kmods/*openrazer*.rpm \
    /tmp/akmods/kmods/*v4l2loopback*.rpm \
    /tmp/akmods/kmods/*xone*.rpm \
    /tmp/akmods-extra/kmods/*ayaneo-platform*.rpm \
    /tmp/akmods-extra/kmods/*ayn-platform*.rpm \
    /tmp/akmods-extra/kmods/*bmi260*.rpm \
    /tmp/akmods-extra/kmods/*gcadapter_oc*.rpm \
    /tmp/akmods-extra/kmods/*nct6687*.rpm \
    /tmp/akmods-extra/kmods/*ryzen-smu*.rpm \
    /tmp/akmods-extra/kmods/*system76*.rpm \
    /tmp/akmods-extra/kmods/*vhba*.rpm \
    /tmp/akmods-extra/kmods/*zenergy*.rpm

dnf5 -y remove rpmfusion-free-release rpmfusion-nonfree-release

# Install NVIDIA driver and kmod if it's the NVIDIA image
# This (intentionally) fails if nvidia-driver and kmod-nvidia don't have matching versions
# This prevents the image from breaking, because they're sometimes out of sync
if [[ $IMAGE_NAME =~ "nvidia" ]]; then
    fetch_akmods_rpms "ghcr.io/ublue-os/akmods-nvidia-open:${KERNEL_FLAVOR}-${FEDORA_MAJOR_VERSION}-${KERNEL_VERSION}" /tmp/akmods-rpms

    curl -Lo /tmp/nvidia-install.sh https://raw.githubusercontent.com/ublue-os/main/refs/heads/main/build_files/nvidia-install.sh
    chmod +x /tmp/nvidia-install.sh
    IMAGE_NAME="kinoite" /tmp/nvidia-install.sh

    dnf5 -y remove xorg-x11-nvidia supergfxctl-plasmoid supergfxctl
    rm -f /usr/share/vulkan/icd.d/nouveau_icd.*.json
    ln -s libnvidia-ml.so.1 /usr/lib64/libnvidia-ml.so
fi

sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/_copr_ublue-os-akmods.repo

# Install some mediatek firmware
mkdir -p /tmp/mediatek-firmware
curl -Lo /tmp/mediatek-firmware/WIFI_MT7922_patch_mcu_1_1_hdr.bin "https://gitlab.com/kernel-firmware/linux-firmware/-/raw/8f08053b2a7474e210b03dbc2b4ba59afbe98802/mediatek/WIFI_MT7922_patch_mcu_1_1_hdr.bin?inline=false"
curl -Lo /tmp/mediatek-firmware/WIFI_RAM_CODE_MT7922_1.bin "https://gitlab.com/kernel-firmware/linux-firmware/-/raw/8f08053b2a7474e210b03dbc2b4ba59afbe98802/mediatek/WIFI_RAM_CODE_MT7922_1.bin?inline=false"
xz --check=crc32 /tmp/mediatek-firmware/WIFI_MT7922_patch_mcu_1_1_hdr.bin
xz --check=crc32 /tmp/mediatek-firmware/WIFI_RAM_CODE_MT7922_1.bin
mv -vf /tmp/mediatek-firmware/* /usr/lib/firmware/mediatek/
rm -rf /tmp/mediatek-firmware
