Name:           filotimo-backgrounds
Version:        {{{ git_dir_version }}}
Release:        1%{?dist}
Summary:        Wallpapers for Filotimo
License:        GPLv2+
URL:            https://github.com/filotimo-project/

Source0:        LICENSE

Source1:        Amber.jxl
Source2:        Chroma.jpg
Source3:        Crepusculum.jpg
Source4:        Dayiri.jpg
Source5:        Disks.jpg
Source6:        Elysium.jpg
Source7:        Globs.jpg
Source8:        Magniloquent.jpg
Source9:        Naima.jpg
Source10:       Phaethon.jpg

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
    cp $file %{buildroot}%{_datadir}/wallpapers/$id/contents/images/$(identify -format "%wx%h\n" $file)."${file##*.}"
    cp metadata.json %{buildroot}%{_datadir}/wallpapers/$id/
    cp %{SOURCE22} %{buildroot}%{_datadir}/wallpapers/$id/

    sed -i 's/"@id@"/\"'"$id"'\"/' %{buildroot}%{_datadir}/wallpapers/$id/metadata.json

    name=""
    author_name=""
    author_email=""
    case "$id" in
        "Disks")
        name="Disks"
        author_name="Milad Fakurian"
        ;;
        "Chroma")
        name="Chroma"
        author_name="Milad Fakurian"
        ;;
        "Blobs")
        name="Blobs"
        author_name="Richard Horvath"
        ;;
        "Amber")
        name="Amber"
        author_name="David Lapshin"
        ;;
        "Naima")
        name="Naima"
        author_name="Nat Watson"
        ;;
        "Dayiri")
        name="Dayiri"
        author_name="Martin Martz"
        ;;
        "Magniloquent")
        name="Magniloquent"
        author_name="Pawel Czerwinski"
        ;;
        "Crepusculum")
        name="Crepusculum"
        author_name="Dim Gunger"
        ;;
        "Elysium")
        name="Elysium"
        author_name="Sean Sinclair"
        ;;
        "Phaethon")
        name="Phaethon"
        author_name="Li Zhang"
        ;;
    esac
    sed -i 's/"@name@"/\"'"$name"'\"/' %{buildroot}%{_datadir}/wallpapers/$id/metadata.json
    sed -i 's/"@author_name@"/\"'"$author_name"'\"/' %{buildroot}%{_datadir}/wallpapers/$id/metadata.json
    sed -i 's/"@author_email@"/\"'"$author_email"'\"/' %{buildroot}%{_datadir}/wallpapers/$id/metadata.json
done

mkdir -p %{buildroot}%{_datadir}/backgrounds/images
mkdir -p %{buildroot}%{_datadir}/sddm/themes/01-breeze-fedora/
cp Phaethon.jpg %{buildroot}%{_datadir}/backgrounds/default.jpg
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
