Name:    kdenetwork-filesharing

%global forgeurl https://invent.kde.org/network/%{name}
%global commit e576ac25e934daee31f96c6a4d01b593dc013d04
%global date 20250525
%forgemeta

Summary: Network filesharing
Epoch:   1
Version: 25.04.2
Release: 1%{?dist}
# KDE e.V. may determine that future GPL versions are accepted
License: BSD-3-Clause AND CC0-1.0 AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND LGPL-2.1-only AND LGPL-3.0-only

URL:     %{forgeurl}
Source:  %{forgesource}

Patch0:  0001-fix-ui.patch

# upstream patches
BuildRequires: extra-cmake-modules
BuildRequires: gettext
BuildRequires: kf6-rpm-macros
BuildRequires: libappstream-glib

BuildRequires: cmake(Qt6Core)
BuildRequires: cmake(Qt6Widgets)
BuildRequires: cmake(Qt6Qml)
BuildRequires: cmake(Qt6QuickWidgets)
BuildRequires: cmake(KF6Auth)
BuildRequires: cmake(KF6Completion)
BuildRequires: cmake(KF6CoreAddons)
BuildRequires: cmake(KF6I18n)
BuildRequires: cmake(KF6KIO)
BuildRequires: cmake(KF6WidgetsAddons)
BuildRequires: cmake(packagekitqt6)
BuildRequires: cmake(QCoro6Core)
# or gets pulled in via PK at runtime
Recommends: samba
Recommends: samba-usershares

%description
%{summary}.

%prep
%forgeautosetup -p1

%build
%cmake_kf6
%cmake_build

%install
%cmake_install
%find_lang %{name} --all-name --with-html

%check
appstream-util validate-relax --nonet %{buildroot}%{_kf6_metainfodir}/org.kde.kdenetwork-filesharing.metainfo.xml

%files -f %{name}.lang
%license LICENSES/*
%dir %{_kf6_plugindir}/propertiesdialog/
%{_kf6_plugindir}/propertiesdialog/sambausershareplugin.so
%{_kf6_plugindir}/propertiesdialog/SambaAcl.so
%{_kf6_metainfodir}/org.kde.kdenetwork-filesharing.metainfo.xml
%{_kf6_libexecdir}/kauth/authhelper
%{_kf6_datadir}/dbus-1/system-services/org.kde.filesharing.samba.service
%{_kf6_datadir}/dbus-1/system.d/org.kde.filesharing.samba.conf
%{_kf6_datadir}/polkit-1/actions/org.kde.filesharing.samba.policy

%changelog
