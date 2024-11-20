#!/usr/bin/bash
set -ouex pipefail

# Fix podman complaining about some database thing
mkdir -p /etc/skel/.local/share/containers/storage/volumes

# Hide nvtop and htop desktop entries
sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nHidden=true@g' /usr/share/applications/htop.desktop
sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nHidden=true@g' /usr/share/applications/nvtop.desktop

# Set Konsole default profile
echo "[Desktop Entry]
DefaultProfile=Filotimo.profile" >> /etc/xdg/konsolerc

# Set rpm-ostree to check for updates automatically, not stage automatically
# Updates will be done automatically by Discover
sed -i "s/^AutomaticUpdatePolicy=.*/AutomaticUpdatePolicy=check/" /etc/rpm-ostreed.conf

# Remove fcitx default icons
rm -rf /usr/share/icons/breeze/status/22/fcitx.svg
rm -rf /usr/share/icons/breeze/status/24/fcitx.svg
rm -rf /usr/share/icons/breeze-dark/status/22/fcitx.svg
rm -rf /usr/share/icons/breeze-dark/status/24/fcitx.svg

# Fix misconfigured samba usershares
mkdir -p /var/lib/samba/usershares
chown -R root:usershares /var/lib/samba/usershares
firewall-offline-cmd --service=samba --service=samba-client

# Helper for virt-manager
cat <<-EOF | tee /usr/libexec/selinux-virt-manager > /dev/null
#!/usr/bin/bash
set -e
kdialog --warningcontinuecancel "The SELinux security module included with this operating system may cause compatibility issues with Virtual Machine Manager. Continuing will temporarily disable SELinux until the next reboot, or until the command\nsudo setenforce 1\nis executed in a terminal.\n" --title "Security Warning"
pkexec setenforce 0
virt-manager
EOF
chmod +x /usr/libexec/selinux-virt-manager
sed -i 's@^Exec=.*@Exec=/usr/libexec/selinux-virt-manager@' /usr/share/applications/virt-manager.desktop

# Fix GTK theming
echo "[org/gnome/desktop/interface]
color-scheme='default'
cursor-size=24
cursor-theme='breeze_cursors'
enable-animations=true
font-name='Inter Variable,  10'
gtk-theme='Breeze'
icon-theme='breeze'
scaling-factor=uint32 1
text-scaling-factor=1.0
toolbar-style='text'" > /etc/dconf/db/distro.d/00-breeze-theme
dconf update

# Fix X display issues in distrobox
echo 'xhost +si:localuser:$USER >/dev/null' > /etc/skel/.distroboxrc

# Set some flatpak overrides - fixes fcitx, some launching bug, and theming
mkdir -p /etc/skel/.local/share/flatpak/overrides
echo '[Context]
filesystems=~/.themes;~/.icons;' | tee /etc/skel/.local/share/flatpak/overrides/global > /dev/null
echo '[Context]
sockets=!wayland;' | tee /etc/skel/.local/share/flatpak/overrides/dev.vencord.Vesktop /etc/skel/.local/share/flatpak/overrides/com.discordapp.Discord > /dev/null

# Work around a bug with xdg-desktop-portal crashing
echo '[Desktop Entry]
Type=Application
Exec=/usr/bin/systemctl --user restart xdg-desktop-portal.service
X-KDE-StartupNotify=false
X-KDE-autostart-phase=2
NoDisplay=true
Name=Restart XDG Desktop Portal (bug workaround)' > /etc/xdg/autostart/restart-xdg-desktop-portal.desktop

# Stop tuned touching swappiness
grep -rIl 'vm.swappiness=' /usr/lib/tuned/profiles | xargs sed -i '/^vm.swappiness=[0-9]\+/s/^/# /'

# Allow changing the SDDM background
touch /etc/sddm-theme.conf.user
ln -sf /etc/sddm-theme.conf.user /usr/share/sddm/themes/01-breeze-fedora

# Consistent setroubleshoot icons
cp /usr/share/icons/breeze/apps/48/setroubleshoot_icon.svg /usr/share/icons/hicolor/scalable/apps/setroubleshoot_icon.svg
cp /usr/share/icons/breeze/apps/48/setroubleshoot_icon.svg /usr/share/icons/hicolor/scalable/apps/setroubleshoot_red_icon.svg
cp /usr/share/icons/breeze/apps/48/setroubleshoot_icon.svg /usr/share/icons/hicolor/scalable/apps/setroubleshoot_icon-symbolic.svg
