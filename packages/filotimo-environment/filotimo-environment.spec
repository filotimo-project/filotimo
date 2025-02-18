Name:           filotimo-environment
Version:        {{{ git_dir_version }}}
Release:        1%{?dist}
Summary:        Environment configuration for Filotimo.
URL:            https://github.com/filotimo-project

Source0:        LICENSE
# profile.d scripts
Source2:        filotimo-nvidia.sh
Source3:        filotimo-obs-studio.sh
Source4:        filotimo-ime.sh
Source5:        open.sh
# /usr/lib/sysctl.d
Source11:       zz1-filotimo.conf
Source12:       zz1-inotify.conf
# fonts/conf.d
Source21:       00-filotimo-default-font.conf
# /etc/sudoers.d
Source41:       filotimo-sudoers
# /etc/xdg/fcitx5/conf/
Source51:       classicui.conf
Source52:       notifications.conf
# /etc/systemd/
Source61:       zram-generator.conf

BuildArch:      noarch
License:        GPLv2+

Requires:       flatpak
Requires:       bash
Requires:       gawk
Requires:       dnf5
Requires:       dnf5-plugins
Requires:       kdenetwork-filesharing

Recommends:     filotimo-environment-fonts
Recommends:     filotimo-environment-ime
# We provide a different zram configuration
Provides:       zram-generator-defaults
Obsoletes:      zram-generator-defaults

%description
Environment variables, sysctl and fontconfig configuration for Filotimo.

%define debug_package %{nil}

%package fonts
Summary: The extra font set that comes with Filotimo.
Requires: rsms-inter-fonts
Requires: rsms-inter-vf-fonts
Requires: ibm-plex-fonts-all
Requires: adobe-source-code-pro-fonts
Requires: adobe-source-han-code-jp-fonts
Requires: google-noto-color-emoji-fonts
Requires: google-noto-emoji-fonts
Requires: google-noto-fonts-all

%description fonts
The extra font set that comes with Filotimo.


%package ime
Summary: IME setup for Filotimo
# This pulls in a glorious 117MiB yikes
Requires:  fcitx5
Requires:  kcm-fcitx5

Requires:  fcitx5-m17n
Requires:  fcitx5-chinese-addons
Requires:  fcitx5-lua
Requires:  fcitx5-hangul
Requires:  fcitx5-mozc
Requires:  fcitx5-unikey

Provides:  im-chooser
Obsoletes: im-chooser

%description ime
IME setup for Filotimo
pinyin, japanese, hangul, etc - uses fcitx5

%prep

%install
install -pm 0644 %{SOURCE0} LICENSE
mkdir -p %{buildroot}%{_sysconfdir}/profile.d/
mkdir -p %{buildroot}%{_prefix}/lib/sysctl.d/
mkdir -p %{buildroot}%{_sysconfdir}/fonts/conf.d/
mkdir -p %{buildroot}%{_sysconfdir}/sudoers.d/
mkdir -p %{buildroot}%{_sysconfdir}/xdg/fcitx5/conf/
mkdir -p %{buildroot}%{_prefix}/lib/systemd/
install -t %{buildroot}%{_sysconfdir}/profile.d/ %{SOURCE2} %{SOURCE3} %{SOURCE4} %{SOURCE5}
install -t %{buildroot}%{_prefix}/lib/sysctl.d/ %{SOURCE11} %{SOURCE12}
install -t %{buildroot}%{_sysconfdir}/fonts/conf.d/ %{SOURCE21}
install -t %{buildroot}%{_sysconfdir}/sudoers.d/ %{SOURCE41}
install -t %{buildroot}%{_sysconfdir}/xdg/fcitx5/conf/ %{SOURCE51} %{SOURCE52}
install -t %{buildroot}%{_prefix}/lib/systemd/ %{SOURCE61}

%post
if [ $1 -eq 1 ] ; then
# Fix files not appearing
setsebool -P samba_enable_home_dirs=1
setsebool -P samba_export_all_ro=1
setsebool -P samba_export_all_rw=1
# Disable showing home dirs with samba shares
cp %{_sysconfdir}/samba/smb.conf %{_sysconfdir}/samba/smb.conf.bak
sed '/^\[homes\]/,/^\[/{/^\[homes\]/d;/^\[/!d}' %{_sysconfdir}/samba/smb.conf.bak > %{_sysconfdir}/samba/smb.conf
fi

%postun
if [ $1 -eq 0 ] ; then
# Fix files not appearing
setsebool -P samba_enable_home_dirs=0
setsebool -P samba_export_all_ro=0
setsebool -P samba_export_all_rw=0
# Disable showing home dirs with samba shares
rm %{_sysconfdir}/samba/smb.conf
mv %{_sysconfdir}/samba/smb.conf.bak %{_sysconfdir}/samba/smb.conf
fi

%files
%license LICENSE
%config(noreplace) %{_sysconfdir}/profile.d/filotimo-nvidia.sh
%config(noreplace) %{_sysconfdir}/profile.d/filotimo-obs-studio.sh
%config(noreplace) %{_sysconfdir}/profile.d/open.sh
%config(noreplace) %{_sysconfdir}/sudoers.d/filotimo-sudoers
%{_prefix}/lib/systemd/zram-generator.conf
%{_prefix}/lib/sysctl.d/zz1-filotimo.conf
%{_prefix}/lib/sysctl.d/zz1-inotify.conf

%files fonts
%config(noreplace) %{_sysconfdir}/fonts/conf.d/00-filotimo-default-font.conf

%files ime
%config(noreplace) %{_sysconfdir}/profile.d/filotimo-ime.sh
%config(noreplace) %{_sysconfdir}/xdg/fcitx5/conf/classicui.conf
%config(noreplace) %{_sysconfdir}/xdg/fcitx5/conf/notifications.conf

%changelog
