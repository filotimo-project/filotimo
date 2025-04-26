#!/usr/bin/bash
set -ouex pipefail
source /ctx/build/steps/prelude.sh

# Un-cliwrap rpm-ostree - may not be necessary anymore
# there is no 'rpm-ostree cliwrap uninstall-from-root', but this is close enough. See:
# https://github.com/coreos/rpm-ostree/blob/6d2548ddb2bfa8f4e9bafe5c6e717cf9531d8001/rust/src/cliwrap.rs#L25-L32
if [ -d /usr/libexec/rpm-ostree/wrapped ]; then
    # binaries which could be created if they did not exist thus may not be in wrapped dir
    rm -f \
        /usr/bin/yum \
        /usr/bin/dnf \
        /usr/bin/kernel-install
    # binaries which were wrapped
    mv -f /usr/libexec/rpm-ostree/wrapped/* /usr/bin
    rm -fr /usr/libexec/rpm-ostree
fi

# Fix build skew
dnf5 -y upgrade \
    --repo=updates \
    glib2 || true
dnf5 -y upgrade \
    --repo=updates \
    qt6-qtbase \
    qt6-qtbase-common \
    qt6-qtbase-mysql \
    qt6-qtbase-gui || true
dnf5 -y upgrade \
    --repo=updates \
    elfutils-libelf \
    elfutils-libs || true
dnf5 -y upgrade \
    --repo=updates \
    libX11 \
    libX11-common \
    libX11-xcb || true
dnf5 -y upgrade \
    --repo=updates \
    glibc \
    glibc-common \
    glibc-all-langpacks \
    glibc-gconv-extra || true

# Install repositories
source /ctx/build/steps/repositories.sh
for repository in "${copr_repositories[@]}"; do
    dnf5 -y copr enable "$repository"
done
for url in "${url_repositories[@]}"; do
    curl -Lo "/etc/yum.repos.d/$(basename "$url")" "$url"
done
