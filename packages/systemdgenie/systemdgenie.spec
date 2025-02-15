Name:    systemdgenie

%global app_id org.kde.%{name}
%global service_id org.kde.kcontrol.%{name}

%global forgeurl https://github.com/KDE/%{name}
%global commit 39d552e97f9e08d02cc106112265f2abc86b7f60
%global date 20250215
%forgemeta

Summary: Systemd managment utility
Version: 0.99.0
Release: 4%{?dist}

License: GPLv2+
URL:     %{forgeurl}
Source:  %{forgesource}

Patch0:  6.patch
Patch1:  7.patch
Patch2:  8.patch
Patch3:  11.patch

BuildRequires: gcc-c++
BuildRequires: cmake
BuildRequires: extra-cmake-modules
BuildRequires: desktop-file-utils
BuildRequires: kf6-rpm-macros

BuildRequires: pkgconfig(libsystemd)
BuildRequires: pkgconfig(systemd)

BuildRequires: cmake(Qt6DBus)
BuildRequires: cmake(Qt6Gui)
BuildRequires: cmake(Qt6Widgets)

BuildRequires: cmake(KF6Auth)
BuildRequires: cmake(KF6CoreAddons)
BuildRequires: cmake(KF6Crash)
BuildRequires: cmake(KF6I18n)
BuildRequires: cmake(KF6XmlGui)
BuildRequires: cmake(KF6TextEditor)

%description
SystemdGenie is a systemd management utility based on KDE technologies. It provides a graphical frontend for the systemd daemon, which allows for viewing and controlling systemd units, logind sessions as well as easy modification of configuration and unit files.

%prep
%forgeautosetup -p1

%build
%cmake_kf6
%cmake_build

%install
%cmake_install
%find_lang %{name} --all-name --with-html

%check
desktop-file-validate %{buildroot}%{_kf6_datadir}/applications/%{app_id}.desktop

%files -f %{name}.lang
%license LICENSES/*
%{_kf6_bindir}/%{name}
%{_kf6_libexecdir}/kauth/%{name}helper
%{_kf6_datadir}/applications/%{app_id}.desktop
%{_kf6_datadir}/dbus-1/system-services/%{service_id}.service
%{_kf6_datadir}/dbus-1/system.d/%{service_id}.conf
%{_kf6_datadir}/kxmlgui5/%{name}/
%{_kf6_datadir}/polkit-1/actions/%{service_id}.policy

%changelog
* Fri Nov 1 2024 Hazel Bunny <hazel_bunny@disroot.org> - 0.99.0-4.git
- Rebuild for Qt 6.8

* Thu Oct 17 2024 Hazel Bunny <hazel_bunny@disroot.org> 0.99.0-3.git
- Fedora 41 Mass Rebuild

* Thu Apr 25 2024 Hazel Bunny <hazel_bunny@disroot.org> 0.99.0-2.git
- Rebuild for Qt 6.8

* Wed Mar 6 2024 Hazel Bunny <hazel_bunny@disroot.org> 0.99.0-1.git
- Initial packaging
