Name:           filotimo-kde-overrides
Version:        {{{ git_dir_version }}}
Release:        1%{?dist}
Summary:        KDE defaults for Filotimo
URL:            https://github.com/filotimo-project/

Source0:        LICENSE
# KDE global config files
Source1:        discoverrc
Source2:        kded5rc
Source3:        kded_device_automounterrc
Source4:        kdeglobals
Source5:        kdesurc
Source6:        krunnerrc
Source7:        ksplashrc
Source8:        kuriikwsfilterrc
Source9:        kwinrc
Source10:       kwriterc
Source11:       spectaclerc
Source12:       ksmserverrc
Source13:       PlasmaDiscoverUpdates
Source14:       12-filotimo-kde-policy.rules
Source15:       kde-mimeapps.list
Source16:       kicker-extra-favoritesrc
Source17:       dolphinrc
Source18:       kwinrulesrc
# SDDM config files
Source21:       10-filotimo-kde-overrides.conf
# look-and-feel
Source31:       metadata-dark.json
Source32:       defaults-dark
Source33:       org.kde.plasma.kickoff.js
Source34:       org.kde.plasma.desktop-layout.js
Source82:       org.kde.plasma.icontasks.js
Source35:       preview-dark.png
Source36:       fullscreenpreview-dark.jpg
Source71:       preview-light.png
Source72:       fullscreenpreview-light.jpg
Source37:       FilotimoLight.colors
Source38:       FilotimoDark.colors
Source39:       metadata-light.json
Source40:       defaults-light
Source41:       metadata-twilight.json
Source42:       defaults-twilight
Source43:       preview-twilight.png
Source44:       fullscreenpreview-twilight.jpg
Source45:       colors-dark
Source46:       colors-light
# desktoptheme
Source73:       metadata-dark-plasma.json
Source74:       metadata-light-plasma.json
Source75:       plasmarc-dark
Source76:       plasmarc-light
# konsole profile
Source81:       Filotimo.profile

BuildArch:      noarch
License:        GPLv2+

Requires:       rsms-inter-fonts
Requires:       ibm-plex-fonts-all
Requires:       plasma-workspace
Requires:       filotimo-fonts
# fcitx5 is default in kwinrc
#Requires:       filotimo-environment-ime
# stupid for just one folder
BuildRequires:  plasma-workspace
Obsoletes:      plasma-discover-offline-updates
Provides:       plasma-discover-offline-updates
# plasma-lookandfeel-fedora
BuildRequires:  kf6-rpm-macros
Requires:       qt6-qtvirtualkeyboard
# theming
Recommends:     filotimo-kde-theme

%description
KDE defaults for Filotimo

%define debug_package %{nil}

%package -n filotimo-kde-theme
Summary:        KDE theming provided with filotimo

#Requires:       filotimo-backgrounds >= 0.9
Provides:       plasma-lookandfeel-fedora
Obsoletes:      plasma-lookandfeel-fedora

%description -n filotimo-kde-theme
%{summary}

%prep

%install
install -pm 0644 %{SOURCE0} LICENSE

mkdir -p %{buildroot}%{_sysconfdir}/xdg/
mkdir -p %{buildroot}%{_sysconfdir}/sddm.conf.d/
mkdir -p %{buildroot}%{_datadir}/polkit-1/rules.d
mkdir -p %{buildroot}%{_datadir}/konsole/

install -t %{buildroot}%{_sysconfdir}/xdg/ %{SOURCE1} %{SOURCE2} %{SOURCE3} %{SOURCE4} %{SOURCE5} %{SOURCE6} %{SOURCE7} %{SOURCE8} %{SOURCE9} %{SOURCE10} %{SOURCE11} %{SOURCE12} %{SOURCE13} %{SOURCE15} %{SOURCE16} %{SOURCE17} %{SOURCE18}
install -t %{buildroot}%{_sysconfdir}/sddm.conf.d/ %{SOURCE21}
install -t %{buildroot}%{_datadir}/polkit-1/rules.d/ %{SOURCE14}
install -t %{buildroot}%{_datadir}/konsole/ %{SOURCE81}

# Filotimo dark global theme
mkdir -p %{buildroot}%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimodark.desktop/contents/{layouts,previews,plasmoidsetupscripts}

install -T %{SOURCE31} %{buildroot}%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimodark.desktop/metadata.json
install -T %{SOURCE32} %{buildroot}%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimodark.desktop/contents/defaults

install -t %{buildroot}%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimodark.desktop/contents/plasmoidsetupscripts/ %{SOURCE33} %{SOURCE82}
install -t %{buildroot}%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimodark.desktop/contents/layouts/ %{SOURCE34}
install -T %{SOURCE35} %{buildroot}%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimodark.desktop/contents/previews/preview.png
install -T %{SOURCE36} %{buildroot}%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimodark.desktop/contents/previews/fullscreenpreview.jpg

# Filotimo light global theme
mkdir -p %{buildroot}%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimolight.desktop/contents/{layouts,previews,plasmoidsetupscripts}

install -T %{SOURCE39} %{buildroot}%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimolight.desktop/metadata.json
install -T %{SOURCE40} %{buildroot}%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimolight.desktop/contents/defaults

install -t %{buildroot}%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimolight.desktop/contents/plasmoidsetupscripts/ %{SOURCE33} %{SOURCE82}
install -t %{buildroot}%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimolight.desktop/contents/layouts/ %{SOURCE34}
install -T %{SOURCE71} %{buildroot}%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimolight.desktop/contents/previews/preview.png
install -T %{SOURCE72} %{buildroot}%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimolight.desktop/contents/previews/fullscreenpreview.jpg

# Filotimo twilight global theme
mkdir -p %{buildroot}%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimo.desktop/contents/{layouts,previews,plasmoidsetupscripts}

install -T %{SOURCE41} %{buildroot}%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimo.desktop/metadata.json
install -T %{SOURCE42} %{buildroot}%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimo.desktop/contents/defaults

install -t %{buildroot}%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimo.desktop/contents/plasmoidsetupscripts/ %{SOURCE33} %{SOURCE82}
install -t %{buildroot}%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimo.desktop/contents/layouts/ %{SOURCE34}
install -T %{SOURCE43} %{buildroot}%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimo.desktop/contents/previews/preview.png
install -T %{SOURCE44} %{buildroot}%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimo.desktop/contents/previews/fullscreenpreview.jpg

# Matching plasmashell themes
mkdir -p %{buildroot}%{_kf6_datadir}/plasma/desktoptheme/filotimo-dark
mkdir -p %{buildroot}%{_kf6_datadir}/plasma/desktoptheme/filotimo-light

install -T %{SOURCE73} %{buildroot}%{_kf6_datadir}/plasma/desktoptheme/filotimo-dark/metadata.json
install -T %{SOURCE75} %{buildroot}%{_kf6_datadir}/plasma/desktoptheme/filotimo-dark/plasmarc
install -T %{SOURCE45} %{buildroot}%{_kf6_datadir}/plasma/desktoptheme/filotimo-dark/colors

install -T %{SOURCE74} %{buildroot}%{_kf6_datadir}/plasma/desktoptheme/filotimo-light/metadata.json
install -T %{SOURCE76} %{buildroot}%{_kf6_datadir}/plasma/desktoptheme/filotimo-light/plasmarc
install -T %{SOURCE46} %{buildroot}%{_kf6_datadir}/plasma/desktoptheme/filotimo-light/colors

# Matching color schemes
mkdir -p %{buildroot}%{_kf6_datadir}/color-schemes/
install -t %{buildroot}%{_kf6_datadir}/color-schemes/ %{SOURCE37} %{SOURCE38}

# Icon directories
mkdir -p %{buildroot}%{_datadir}/icons/{breeze,breeze-dark}/{preferences,mimetypes,apps}/{16,22,24,32,48,64}

# Make fcitx icon same as keyboard preferences icon
for size in 22 24 32; do
    ln -sf %{_datadir}/icons/breeze/preferences/$size/preferences-desktop-keyboard.svg \
          %{buildroot}%{_datadir}/icons/breeze/preferences/$size/fcitx.svg
    ln -sf %{_datadir}/icons/breeze-dark/preferences/$size/preferences-desktop-keyboard.svg \
          %{buildroot}%{_datadir}/icons/breeze-dark/preferences/$size/fcitx.svg
done


# Change AppImageLauncher icon to appimage application icon
for size in 16 22 24 32 48 64; do
    if [ "$size" -eq 48 ]; then
        ln -sf %{_datadir}/icons/breeze/mimetypes/64/application-vnd.appimage.svg \
              %{buildroot}%{_datadir}/icons/breeze/apps/48/AppImageLauncher.svg
        ln -sf %{_datadir}/icons/breeze-dark/mimetypes/64/application-vnd.appimage.svg \
              %{buildroot}%{_datadir}/icons/breeze-dark/apps/48/AppImageLauncher.svg
    else
        ln -sf %{_datadir}/icons/breeze/mimetypes/${size}/application-vnd.appimage.svg \
              %{buildroot}%{_datadir}/icons/breeze/apps/${size}/AppImageLauncher.svg
        ln -sf %{_datadir}/icons/breeze-dark/mimetypes/${size}/application-vnd.appimage.svg \
              %{buildroot}%{_datadir}/icons/breeze-dark/apps/${size}/AppImageLauncher.svg
    fi
done

%post


%files
%license LICENSE
%config(noreplace) %{_sysconfdir}/xdg/discoverrc
%config(noreplace) %{_sysconfdir}/xdg/kded5rc
%config(noreplace) %{_sysconfdir}/xdg/kded_device_automounterrc
%config(noreplace) %{_sysconfdir}/xdg/kdeglobals
%config(noreplace) %{_sysconfdir}/xdg/kdesurc
%config(noreplace) %{_sysconfdir}/xdg/krunnerrc
%config(noreplace) %{_sysconfdir}/xdg/ksplashrc
%config(noreplace) %{_sysconfdir}/xdg/kuriikwsfilterrc
%config(noreplace) %{_sysconfdir}/xdg/kwinrc
%config(noreplace) %{_sysconfdir}/xdg/kwriterc
%config(noreplace) %{_sysconfdir}/xdg/spectaclerc
%config(noreplace) %{_sysconfdir}/xdg/ksmserverrc
%config(noreplace) %{_sysconfdir}/xdg/PlasmaDiscoverUpdates
%config(noreplace) %{_sysconfdir}/xdg/kde-mimeapps.list
%config(noreplace) %{_sysconfdir}/xdg/kicker-extra-favoritesrc
%config(noreplace) %{_sysconfdir}/xdg/dolphinrc
%config(noreplace) %{_sysconfdir}/xdg/kwinrulesrc
%{_datadir}/polkit-1/rules.d/12-filotimo-kde-policy.rules

%files -n filotimo-kde-theme
%{_sysconfdir}/sddm.conf.d/10-filotimo-kde-overrides.conf
%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimodark.desktop
%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimolight.desktop
%{_kf6_datadir}/plasma/look-and-feel/org.filotimoproject.filotimo.desktop
%{_kf6_datadir}/color-schemes/FilotimoLight.colors
%{_kf6_datadir}/color-schemes/FilotimoDark.colors
%{_kf6_datadir}/plasma/desktoptheme/filotimo-dark
%{_kf6_datadir}/plasma/desktoptheme/filotimo-light
%{_datadir}/konsole/Filotimo.profile
%{_datadir}/icons/breeze/*
%{_datadir}/icons/breeze-dark/*

%changelog
