#!/usr/bin/bash
set -ouex pipefail
source /ctx/build/steps/prelude.sh

# Uninstall repositories
source /ctx/build/steps/repositories.sh
for repository in "${copr_repositories[@]}"; do
    dnf5 -y copr disable "$repository"
done
for url in "${url_repositories[@]}"; do
    rm -f "/etc/yum.repos.d/$(basename "$url")"
done

# Clean up
rm -rf /tmp/* || true
rm -rf /tmp/* || true
find /var/* -maxdepth 0 -type d \! -name cache -exec rm -fr {} \;
find /var/cache/* -maxdepth 0 -type d \! -name libdnf5 \! -name rpm-ostree -exec rm -fr {} \;
mkdir -p /var/tmp &&
    chmod -R 1777 /var/tmp
