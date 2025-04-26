Summary: Graphical system installer
Name:    anaconda
Version: 41.35
Release: 100%{?dist}.filotimo
License: GPL-2.0-or-later
URL:     http://fedoraproject.org/wiki/Anaconda

# To generate Source0 do:
# git clone https://github.com/rhinstaller/anaconda
# git checkout -b archive-branch anaconda-%%{version}-%%{release}
# ./autogen.sh
# make dist
Source0: https://github.com/rhinstaller/%{name}/releases/download/%{name}-%{version}/%{name}-%{version}.tar.bz2

Patch0:  0001-filotimo.patch

# Versions of required components (done so we make sure the buildrequires
# match the requires versions of things).

%if ! 0%{?rhel}
%bcond_without glade
%bcond_without live
%define blivetguiver 2.4.2-3
%else
%bcond_with glade
%bcond_with live
%endif
%define dasbusver 1.3
%define dbusver 1.2.3
%define dnfver 3.6.0
%define dracutver 034-7
%define fcoeutilsver 1.0.12-3.20100323git
%define gettextver 0.19.8
%define gtk3ver 3.22.17
%define isomd5sumver 1.0.10
%define langtablever 0.0.60
%define libarchivever 3.0.4
%define libblockdevver 2.1
%define libreportanacondaver 2.0.21-1
%define libxklavierver 5.4
%define mehver 0.23-1
%define nmver 1.0
%define pykickstartver 3.58-1
%define pypartedver 2.5-2
%define pythonblivetver 1:3.9.0-1
%define rpmver 4.15.0
%define simplelinever 1.9.0-1
%define subscriptionmanagerver 1.26
%define utillinuxver 2.15.1
%define rpmostreever 2023.2

BuildRequires: libtool
BuildRequires: gettext-devel >= %{gettextver}
BuildRequires: gtk3-devel >= %{gtk3ver}
BuildRequires: gtk-doc
BuildRequires: gtk3-devel-docs >= %{gtk3ver}
BuildRequires: glib2-doc
BuildRequires: gobject-introspection-devel
%if %{with glade}
BuildRequires: glade-devel
%endif
BuildRequires: libxklavier-devel >= %{libxklavierver}
BuildRequires: make
BuildRequires: pango-devel
BuildRequires: python3-devel
BuildRequires: systemd
# rpm and libarchive are needed for driver disk handling
BuildRequires: rpm-devel >= %{rpmver}
BuildRequires: libarchive-devel >= %{libarchivever}
%ifarch s390 s390x
BuildRequires: s390utils-devel
%endif

# Tools used by the widgets resource bundle generation
BuildRequires: gdk-pixbuf2-devel
BuildRequires: libxml2

Requires: anaconda-gui = %{version}-%{release}
Requires: anaconda-tui = %{version}-%{release}

%description
The anaconda package is a metapackage for the Anaconda installer.

%package core
Summary: Core of the Anaconda installer
# core/signal.py is under MIT
License: GPL-2.0-or-later AND MIT
Requires: python3-libs
%if 0%{?rhel} > 10 || 0%{?fedora} > 40
Requires: python3-crypt-r
%endif
Requires: python3-dnf >= %{dnfver}
Requires: python3-blivet >= %{pythonblivetver}
Requires: python3-blockdev >= %{libblockdevver}
Requires: python3-meh >= %{mehver}
%if 0%{?rhel} < 10 || 0%{?fedora}
Requires: libreport-anaconda >= %{libreportanacondaver}
%endif
Requires: libselinux-python3
Requires: python3-rpm >= %{rpmver}
Requires: python3-pyparted >= %{pypartedver}
Requires: python3-requests
Requires: python3-requests-file
Requires: python3-requests-ftp
Requires: python3-kickstart >= %{pykickstartver}
Requires: python3-langtable >= %{langtablever}
Requires: util-linux >= %{utillinuxver}
Requires: python3-gobject-base
Requires: python3-pwquality
Requires: python3-systemd
Requires: python3-productmd
Requires: python3-dasbus >= %{dasbusver}
Requires: flatpak-libs
%if %{defined rhel} && %{undefined centos}
Requires: subscription-manager >= %{subscriptionmanagerver}
%endif

# pwquality only "recommends" the dictionaries it needs to do anything useful,
# which is apparently great for containers but unhelpful for the rest of us
Requires: cracklib-dicts

%if 0%{?rhel} < 10 || 0%{?fedora}
Requires: teamd
Requires: NetworkManager-team
%endif
%ifarch s390 s390x
Requires: openssh
%endif
Requires: NetworkManager >= %{nmver}
Requires: NetworkManager-libnm >= %{nmver}
Requires: kbd
Requires: chrony
Requires: systemd
%if 0%{?rhel} > 10 || 0%{?fedora}
Requires: systemd-resolved
%endif
Requires: python3-pid

# Required by the systemd service anaconda-fips.
Requires: crypto-policies
Requires: /usr/bin/update-crypto-policies

# required because of the rescue mode and VNC question
Requires: anaconda-tui = %{version}-%{release}

# Make sure we get the en locale one way or another
Requires: (glibc-langpack-en or glibc-all-langpacks)

# anaconda literally runs its own dbus-daemon, so it needs this,
# even though the distro default is dbus-broker in F30+
Requires: dbus-daemon

# setting time from time spoke
Requires: /usr/bin/date

# Ensure it's not possible for a version of grubby to be installed
# that doesn't work with btrfs subvolumes correctly...
Conflicts: grubby < 8.40-10

Obsoletes: anaconda-images <= 10
Provides: anaconda-images = %{version}-%{release}
Obsoletes: anaconda-runtime < %{version}-%{release}
Provides: anaconda-runtime = %{version}-%{release}
Obsoletes: booty <= 0.107-1

%description core
The anaconda-core package contains the program which was used to install your
system.

%if %{with live}
# do not provide the live subpackage on RHEL

%package live
Summary: Live installation specific files and dependencies
BuildArchitectures: noarch
BuildRequires: desktop-file-utils
# live installation currently implies a graphical installation
Requires: anaconda-gui = %{version}-%{release}
Requires: zenity
Requires: xisxwayland
Recommends: xhost

%description live
The anaconda-live package contains scripts, data and dependencies required
for live installations.

%endif

%package install-env-deps
Summary: Installation environment specific dependencies
Requires: udisks2-iscsi
Requires: libblockdev-plugins-all >= %{libblockdevver}
%if ! 0%{?rhel}
Requires: libblockdev-lvm-dbus
%endif
# active directory/freeipa join support
Requires: realmd
Requires: isomd5sum >= %{isomd5sumver}
%ifarch %{ix86} x86_64
Recommends: fcoe-utils >= %{fcoeutilsver}
%endif
# likely HFS+ resize support
%ifarch %{ix86} x86_64
%if ! 0%{?rhel}
Requires: hfsplus-tools
%endif
%endif
# kexec support except riscv64
%ifnarch riscv64
Requires: kexec-tools
%endif
# run's on TTY1 in install env
Requires: tmux
# install time crash handling
Requires: gdb
# support for installation from image and live & live image installations
Requires: rsync
# An addon that allows enabling kdump at install time
Recommends: kdump-anaconda-addon
# basic filesystem tools
%if ! 0%{?rhel}
Requires: btrfs-progs
Requires: ntfs-3g
Requires: ntfsprogs
Requires: f2fs-tools
%endif
Requires: xfsprogs
Requires: dosfstools
Requires: e2fsprogs
# External tooling for managing NVMe-FC devices in the installation environment
Recommends: nvme-cli

%description install-env-deps
The anaconda-install-env-deps metapackage lists all installation environment
dependencies. This makes it possible for packages (such as Initial Setup) to
depend on the main Anaconda package without pulling in all the install time
dependencies as well.

%package install-img-deps
Summary: Installation image specific dependencies
# This package must have no weak dependencies.
# Pull in most stuff with the -env- metapackage
Requires: anaconda-install-env-deps = %{version}-%{release}
# Require storage things that are only recommended in -env-
%ifarch %{ix86} x86_64
Requires: fcoe-utils >= %{fcoeutilsver}
%endif
# only WeakRequires elsewhere and not guaranteed to be present
Requires: device-mapper-multipath
# only WeakRequires in -env-
Requires: kdump-anaconda-addon
%if ! 0%{?rhel}
Requires: zram-generator-defaults
%else
Requires: zram-generator
%endif
# needed for proper driver disk support - if RPMs must be installed, a repo is needed
Requires: createrepo_c
# Display stuff moved from lorax templates
Requires: xorg-x11-drivers
Requires: xorg-x11-server-Xorg
Requires: xrandr
Requires: xrdb
Requires: dbus-x11
Requires: gsettings-desktop-schemas
Requires: nm-connection-editor
Requires: librsvg2
Requires: gnome-kiosk
Requires: brltty
# dependencies for rpm-ostree payload module
Requires: rpm-ostree >= %{rpmostreever}
Requires: ostree
# used by ostree command for native containers
Requires: skopeo
# External tooling for managing NVMe-FC devices in the installation environment
Requires: nvme-cli
# Needed for bootc
Requires: podman

%description install-img-deps
The anaconda-install-img-deps metapackage lists all boot.iso installation
image dependencies. Add this package to an image build (eg. with lorax) to
ensure all Anaconda capabilities are supported in the resulting image.

%package gui
Summary: Graphical user interface for the Anaconda installer
Requires: anaconda-core = %{version}-%{release}
Requires: anaconda-widgets = %{version}-%{release}
Requires: python3-iso639
Requires: python3-meh-gui >= %{mehver}
Requires: python3-xkbregistry
Requires: adwaita-icon-theme
# Filotimo --------------------------
Requires: breeze-icon-theme
# -----------------------------------
Requires: tecla
Requires: tigervnc-server-minimal
Requires: libxklavier >= %{libxklavierver}
Requires: nm-connection-editor
%ifnarch s390 s390x
Requires: NetworkManager-wifi
%endif
%if ! 0%{?rhel}
Requires: blivet-gui-runtime >= %{blivetguiver}
%endif
# Filotimo --------------------------
Requires: fedora-logos >= 1:38.1.0-100
Requires: rsms-inter-fonts
Requires: breeze-gtk-gtk3
# -----------------------------------

# Needed to compile the gsettings files
BuildRequires: gsettings-desktop-schemas

%description gui
This package contains graphical user interface for the Anaconda installer.

%package tui
Summary: Textual user interface for the Anaconda installer
Requires: anaconda-core = %{version}-%{release}
Requires: python3-simpleline >= %{simplelinever}

%description tui
This package contains textual user interface for the Anaconda installer.

%package widgets
Summary: A set of custom GTK+ widgets for use with anaconda
Requires: %{__python3}

%description widgets
This package contains a set of custom GTK+ widgets used by the anaconda
installer.

%package widgets-devel
Summary: Development files for anaconda-widgets
%if %{with glade}
Requires: glade
%endif
Requires: %{name}-widgets%{?_isa} = %{version}-%{release}

%description widgets-devel
This package contains libraries and header files needed for writing the
anaconda installer.  It also contains Python and Glade support files,
as well as documentation for working with this library.

%package dracut
Summary: The anaconda dracut module
Requires: dracut >= %{dracutver}
Requires: dracut-network
Requires: dracut-live
Requires: xz
Requires: python3-kickstart
Requires: iputils

%description dracut
The 'anaconda' dracut module handles installer-specific boot tasks and
options. This includes driver disks, kickstarts, and finding the anaconda
runtime on NFS/HTTP/FTP servers or local disks.

%prep
%autosetup -p 1

%build
# use actual build-time release number, not tarball creation time release number
%configure ANACONDA_RELEASE=%{release} %{!?with_glade:--disable-glade}
%{__make} %{?_smp_mflags}

%install
%{make_install}
find %{buildroot} -type f -name "*.la" | xargs %{__rm}

# Create an empty directory for addons
mkdir %{buildroot}%{_datadir}/anaconda/addons

# Create an empty directory for post-scripts
mkdir %{buildroot}%{_datadir}/anaconda/post-scripts

%if %{with live}
# required for live installations
desktop-file-install --dir=%{buildroot}%{_datadir}/applications %{buildroot}%{_datadir}/applications/liveinst.desktop
%else
# Remove all live-installer files from the buildroot
rm -rf \
  %{buildroot}/%{_sysconfdir}/xdg/autostart/liveinst-setup.desktop \
  %{buildroot}/%{_bindir}/liveinst \
  %{buildroot}/%{_libexecdir}/liveinst-setup.sh \
  %{buildroot}/%{_datadir}/anaconda/gnome \
  %{buildroot}/%{_datadir}/anaconda/gnome/fedora-welcome \
  %{buildroot}/%{_datadir}/anaconda/gnome/org.fedoraproject.welcome-screen.desktop \
  %{buildroot}/%{_datadir}/polkit-1/actions/* \
  %{buildroot}/%{_datadir}/applications/liveinst.desktop
%endif

# Add localization files
%find_lang %{name}

# main package and install-env-deps are metapackages
%files

%files install-env-deps

# Allow the lang file to be empty
%define _empty_manifest_terminate_build 0

%files install-img-deps

# Allow the lang file to be empty here too
%define _empty_manifest_terminate_build 0

%files core -f %{name}.lang
%license COPYING
%{_unitdir}/*
%{_prefix}/lib/systemd/system-generators/*
%{_bindir}/instperf
%{_bindir}/anaconda-disable-nm-ibft-plugin
%{_bindir}/anaconda-nm-disable-autocons
%{_sbindir}/anaconda
%{_sbindir}/handle-sshpw
%{_datadir}/anaconda
%{_prefix}/libexec/anaconda
%exclude %{_datadir}/anaconda/gnome
%exclude %{_datadir}/anaconda/pixmaps
%exclude %{_datadir}/anaconda/ui
%exclude %{_datadir}/anaconda/window-manager
%exclude %{_datadir}/anaconda/anaconda-gtk.css
%dir %{_datadir}/anaconda/post-scripts
%exclude %{_prefix}/libexec/anaconda/dd_*
%{python3_sitearch}/pyanaconda
%exclude %{python3_sitearch}/pyanaconda/rescue.py*
%exclude %{python3_sitearch}/pyanaconda/__pycache__/rescue.*
%exclude %{python3_sitearch}/pyanaconda/ui/gui/*
%exclude %{python3_sitearch}/pyanaconda/ui/tui/*
%{_bindir}/anaconda-cleanup
%dir %{_sysconfdir}/%{name}
%config %{_sysconfdir}/%{name}/*
%dir %{_sysconfdir}/%{name}/conf.d
%config %{_sysconfdir}/%{name}/conf.d/*
%dir %{_sysconfdir}/%{name}/profile.d
%config %{_sysconfdir}/%{name}/profile.d/*

%if %{with live}
# do not provide the live subpackage on RHEL

%files live
%{_bindir}/liveinst
%{_datadir}/polkit-1/actions/*
%{_libexecdir}/liveinst-setup.sh
%{_datadir}/applications/*.desktop
%{_datadir}/anaconda/gnome
%{_sysconfdir}/xdg/autostart/*.desktop

%endif

%files gui
%{python3_sitearch}/pyanaconda/ui/gui/*
%{_datadir}/anaconda/pixmaps
%{_datadir}/anaconda/ui
%if 0%{?rhel}
# Remove blivet-gui
%exclude %{_datadir}/anaconda/ui/spokes/blivet_gui.*
%exclude %{python3_sitearch}/pyanaconda/ui/gui/spokes/blivet_gui.*
%endif
%{_datadir}/anaconda/window-manager
%{_datadir}/anaconda/anaconda-gtk.css
%{_datadir}/anaconda/gtk-4.0/settings.ini

%files tui
%{python3_sitearch}/pyanaconda/rescue.py
%{python3_sitearch}/pyanaconda/__pycache__/rescue.*
%{python3_sitearch}/pyanaconda/ui/tui/*

%files widgets
%{_libdir}/libAnacondaWidgets.so.*
%{_libdir}/girepository*/AnacondaWidgets*typelib
%{python3_sitearch}/gi/overrides/*

%files widgets-devel
%{_includedir}/*
%{_libdir}/libAnacondaWidgets.so
%if %{with glade}
%{_libdir}/glade/modules/libAnacondaWidgets.so
%{_datadir}/glade/catalogs/AnacondaWidgets.xml
%endif
%{_datadir}/gtk-doc

%files dracut
%dir %{_prefix}/lib/dracut/modules.d/80%{name}
%{_prefix}/lib/dracut/modules.d/80%{name}/*
%{_prefix}/libexec/anaconda/dd_*

%changelog
