Name:    systemdgenie

%global app_id org.kde.%{name}
%global service_id org.kde.kcontrol.%{name}

%global forgeurl https://github.com/KDE/%{name}
%global commit dd17439d8583540647524780fcd1f4e8db13638d
%global date 20250222
%forgemeta

Summary: Systemd managment utility
Version: 0.100.0
Release: 1%{?dist}

License: GPLv2+
URL:     %{forgeurl}
Source:  %{forgesource}

Patch0:  0001-Use-generic-name.patch

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
