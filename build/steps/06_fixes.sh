#!/usr/bin/bash
set -ouex pipefail
source /ctx/build/steps/prelude.sh

# Fix podman complaining about some database thing
mkdir -p /etc/skel/.local/share/containers/storage/volumes

# Set rpm-ostree to check for updates automatically, not stage automatically
# Updates will be done automatically by Discover
sed -i "s/^AutomaticUpdatePolicy=.*/AutomaticUpdatePolicy=check/" /etc/rpm-ostreed.conf

# Fix misconfigured samba usershares
mkdir -p /var/lib/samba/usershares
chown -R root:usershares /var/lib/samba/usershares
firewall-offline-cmd --service=samba --service=samba-client
setsebool -P samba_enable_home_dirs=1
setsebool -P samba_export_all_ro=1
setsebool -P samba_export_all_rw=1
sed -i '/^\[homes\]/,/^\[/{/^\[homes\]/d;/^\[/!d}' /etc/samba/smb.conf

# Helper for virt-manager
sed -i 's@^Exec=.*@Exec=/usr/libexec/selinux-virt-manager@' /usr/share/applications/virt-manager.desktop

# Stop tuned touching swappiness
grep -rIl 'vm.swappiness=' /usr/lib/tuned/profiles | xargs sed -i '/^vm.swappiness=[0-9]\+/s/^/# /'

# Make RDP work
firewall-offline-cmd --service=rdp

# Remove the rpm mimetype association from discover
sed -i 's/application\/x-rpm;//g' /usr/share/applications/org.kde.discover.desktop

# Remove gnome ssh askpass environment variable
rm -rf /etc/profile.d/gnome-ssh-askpass.csh /etc/profile.d/gnome-ssh-askpass.sh

# Purge KNewStuff from Discover
rm -rf /usr/lib64/qt6/plugins/discover/kns-backend.so
