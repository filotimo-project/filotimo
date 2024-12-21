Name:           filotimo-backgrounds
Version:        {{{ git_dir_version }}}
Release:        1%{?dist}
Summary:        Wallpapers for Filotimo
License:        GPLv2+
URL:            https://github.com/filotimo-project/

Source0:        LICENSE

Source1:        CadinidiMisurina.jpg
Source2:        ColdDunes.jpg
Source3:        Dunes.jpg
Source4:        HillsandMountains.jpg
Source5:        InClouds.jpg
Source6:        Kiss.jpg
Source7:        Obelisk.jpg
Source8:        Sand.jpg
Source9:        Wind.jpg
Source10:       Disks.jpg
Source11:       Waves.jpg
Source12:       Globs.jpg
Source13:       Colorism.jpg
Source14:       amber-d.jxl

Source22:       COPYING
Source23:       metadata.json

BuildArch:      noarch
BuildRequires:  ImageMagick
BuildRequires:  zopfli
Requires:       sddm-breeze

Provides:       desktop-backgrounds-compat
Obsoletes:      desktop-backgrounds-compat

%description
Wallpapers for Filotimo.

%define debug_package %{nil}

%prep

%build

%install
install -pm 0644 %{SOURCE0} LICENSE

cd %{_sourcedir}

for file in *.jpg *.jxl; do
    [ -e "$file" ] || continue

    id=$(echo $file | cut -d '.' -f 1)
    ext="${file##*.}"

    mkdir -p %{buildroot}%{_datadir}/wallpapers/$id/contents/images
    cp "$file" %{buildroot}%{_datadir}/wallpapers/$id/contents/screenshot.$ext
    cp $file %{buildroot}%{_datadir}/wallpapers/$id/contents/images/$(identify -format "%wx%h\n" $file).jpg
    cp metadata.json %{buildroot}%{_datadir}/wallpapers/$id/
    cp %{SOURCE22} %{buildroot}%{_datadir}/wallpapers/$id/

    sed -i 's/"@id@"/\"'"$id"'\"/' %{buildroot}%{_datadir}/wallpapers/$id/metadata.json

    name=""
    author_name=""
    author_email=""
    case "$id" in
        "ColdDunes")
        name="Cold Dunes"
        author_name="Marek Piwnicki"
        author_email="marpiwnicki@gmail.com"
        ;;
        "HillsandMountains")
        name="Hills and Mountains"
        author_name="Marek Piwnicki"
        author_email="marpiwnicki@gmail.com"
        ;;
        "InClouds")
        author_name="Marek Piwnicki"
        name="In Clouds"
        author_email="marpiwnicki@gmail.com"
        ;;
        "CadinidiMisurina")
        name="Cadini di Misurina"
        author_name="Eberhard Grossgasteiger"
        author_email="info@narrateography.art"
        ;;
        "Disks")
        name="Disks"
        author_name="Milad Fakurian"
        ;;
        "Colorism")
        name="Colorism"
        author_name="Milad Fakurian"
        ;;
        "Waves")
        name="Waves"
        author_name="Paweł Czerwiński"
        ;;
        "Globs")
        name="Globs"
        author_name="Richard Horvath"
        ;;
        "amber-d")
        name="Amber"
        author_name="David Lapshin"
        ;;
        *)
        name=$id
        author_name="Marek Piwnicki"
        author_email="marpiwnicki@gmail.com"
        ;;
    esac
    sed -i 's/"@name@"/\"'"$name"'\"/' %{buildroot}%{_datadir}/wallpapers/$id/metadata.json
    sed -i 's/"@author_name@"/\"'"$author_name"'\"/' %{buildroot}%{_datadir}/wallpapers/$id/metadata.json
    sed -i 's/"@author_email@"/\"'"$author_email"'\"/' %{buildroot}%{_datadir}/wallpapers/$id/metadata.json
done

mkdir -p %{buildroot}%{_datadir}/backgrounds/images
mkdir -p %{buildroot}%{_datadir}/sddm/themes/01-breeze-fedora/
cp Globs.jpg %{buildroot}%{_datadir}/backgrounds/default.jpg
convert %{buildroot}%{_datadir}/backgrounds/default.jpg %{buildroot}%{_datadir}/backgrounds/default.png
rm -f %{buildroot}%{_datadir}/backgrounds/default.jpg
ln -sf %{_datadir}/backgrounds/default.png %{buildroot}%{_datadir}/backgrounds/default-dark.png
ln -sf %{_datadir}/backgrounds/default.png %{buildroot}%{_datadir}/backgrounds/images/default.png
ln -sf %{_datadir}/backgrounds/default.png %{buildroot}%{_datadir}/sddm/themes/01-breeze-fedora/default.png

%files
%license LICENSE
%{_datadir}/wallpapers/*
%{_datadir}/backgrounds/default.png
%{_datadir}/backgrounds/default-dark.png
%dir %{_datadir}/backgrounds/images/
%{_datadir}/backgrounds/images/default*
%{_datadir}/sddm/themes/01-breeze-fedora/default.png

%changelog
