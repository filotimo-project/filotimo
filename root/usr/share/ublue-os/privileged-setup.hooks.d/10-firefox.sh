#!/usr/bin/bash
set -ouex pipefail

# See https://github.com/ublue-os/packages/blob/main/packages/ublue-setup-services
source /usr/lib/ublue/setup-services/libsetup.sh
version-script firefox privileged 1 || exit 0

# Set up Firefox default configuration
mkdir -p /var/lib/flatpak/extension/org.mozilla.firefox.systemconfig/$(arch)/stable/defaults/pref
rm -f /var/lib/flatpak/extension/org.mozilla.firefox.systemconfig/$(arch)/stable/defaults/pref/*filotimo*.js
/usr/bin/cp -rf /usr/share/firefox-config/* /var/lib/flatpak/extension/org.mozilla.firefox.systemconfig/$(arch)/stable/defaults/pref/
