Name:       fedora-logos
Summary:    Stub to satisfy dependency
Epoch:      1
Version:    38.1.0
Release:    100%{?dist}
License:    GPL-2.0-or-later
URL:        https://github.com/filotimo-project/filotimo
Provides:   redhat-logos <= %{version}-%{release}
Provides:   gnome-logos <= %{version}-%{release}
Provides:   system-logos <= %{version}-%{release}

Provides:   fedora-logos = 1:%{version}-%{release}
Conflicts:  fedora-logos < 1:%{version}-%{release}
Obsoletes:  fedora-logos < 1:%{version}-%{release}

Requires:   filotimo-branding >= 1.5-8

BuildArch:  noarch

%description
Stub to satisfy dependency
