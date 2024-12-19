Name:           filotimo-environment
Version:        0.0
Release:        1%{?dist}
Summary:        Environment configuration for Filotimo.
URL:            https://github.com/filotimo-project

Source0:        LICENSE
# profile.d scripts
Source1:        filotimo-kde-qml-font-fix.sh
Source2:        filotimo-nvidia.sh
Source3:        filotimo-obs-studio.sh
Source4:        filotimo-ime.sh
Source5:        open.sh
# /usr/lib/sysctl.d
Source11:       99-filotimo.conf
Source12:       80-inotify.conf
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
Also includes a fonts package that ensures there will never be tofu.

%define debug_package %{nil}

%package fonts
Summary: The extra font set that comes with Filotimo.
Requires: rsms-inter-fonts
Requires: rsms-inter-vf-fonts
Requires: ibm-plex-fonts-all
Requires: adobe-source-code-pro-fonts

# Maybe a bit extra but there will never ever be tofu
Requires: adobe-source-han-code-jp-fonts
Requires: google-noto-color-emoji-fonts
Requires: google-noto-emoji-fonts
Requires: google-noto-fonts-common
Requires: google-noto-naskh-arabic-vf-fonts
Requires: google-noto-sans-arabic-vf-fonts
Requires: google-noto-sans-armenian-vf-fonts
Requires: google-noto-sans-bengali-vf-fonts
Requires: google-noto-sans-canadian-aboriginal-vf-fonts
Requires: google-noto-sans-cherokee-vf-fonts
Requires: google-noto-sans-cjk-vf-fonts
Requires: google-noto-sans-devanagari-vf-fonts
Requires: google-noto-sans-ethiopic-vf-fonts
Requires: google-noto-sans-fonts
Requires: google-noto-sans-georgian-vf-fonts
Requires: google-noto-sans-gujarati-vf-fonts
Requires: google-noto-sans-gurmukhi-vf-fonts
Requires: google-noto-sans-hebrew-vf-fonts
Requires: google-noto-sans-kannada-vf-fonts
Requires: google-noto-sans-khmer-vf-fonts
Requires: google-noto-sans-lao-vf-fonts
Requires: google-noto-sans-math-fonts
Requires: google-noto-sans-meeteimayek-vf-fonts
Requires: google-noto-sans-mono-cjk-vf-fonts
Requires: google-noto-sans-mono-fonts
Requires: google-noto-sans-mono-vf-fonts
Requires: google-noto-sans-ol-chiki-vf-fonts
Requires: google-noto-sans-oriya-vf-fonts
Requires: google-noto-sans-sinhala-vf-fonts
Requires: google-noto-sans-symbols-vf-fonts
Requires: google-noto-sans-symbols2-fonts
Requires: google-noto-sans-tamil-vf-fonts
Requires: google-noto-sans-telugu-vf-fonts
Requires: google-noto-sans-thaana-vf-fonts
Requires: google-noto-sans-thai-vf-fonts
Requires: google-noto-sans-vf-fonts
Requires: google-noto-serif-armenian-vf-fonts
Requires: google-noto-serif-bengali-vf-fonts
Requires: google-noto-serif-cjk-vf-fonts
Requires: google-noto-serif-devanagari-vf-fonts
Requires: google-noto-serif-ethiopic-vf-fonts
Requires: google-noto-serif-fonts
Requires: google-noto-serif-georgian-vf-fonts
Requires: google-noto-serif-gujarati-vf-fonts
Requires: google-noto-serif-gurmukhi-vf-fonts
Requires: google-noto-serif-hebrew-vf-fonts
Requires: google-noto-serif-kannada-vf-fonts
Requires: google-noto-serif-khmer-vf-fonts
Requires: google-noto-serif-lao-vf-fonts
Requires: google-noto-serif-oriya-vf-fonts
Requires: google-noto-serif-sinhala-vf-fonts
Requires: google-noto-serif-tamil-vf-fonts
Requires: google-noto-serif-telugu-vf-fonts
Requires: google-noto-serif-thai-vf-fonts
Requires: google-noto-serif-vf-fonts
Requires: google-noto-fangsong-kss-rotated-fonts
Requires: google-noto-fangsong-kss-vertical-fonts
Requires: google-noto-kufi-arabic-fonts
Requires: google-noto-kufi-arabic-vf-fonts
Requires: google-noto-music-fonts
Requires: google-noto-naskh-arabic-fonts
Requires: google-noto-naskh-arabic-ui-fonts
Requires: google-noto-naskh-arabic-ui-vf-fonts
Requires: google-noto-nastaliq-urdu-fonts
Requires: google-noto-nastaliq-urdu-vf-fonts
Requires: google-noto-rashi-hebrew-fonts
Requires: google-noto-rashi-hebrew-vf-fonts
Requires: google-noto-sans-adlam-fonts
Requires: google-noto-sans-adlam-unjoined-fonts
Requires: google-noto-sans-adlam-unjoined-vf-fonts
Requires: google-noto-sans-adlam-vf-fonts
Requires: google-noto-sans-anatolian-hieroglyphs-fonts
Requires: google-noto-sans-arabic-fonts
Requires: google-noto-sans-armenian-fonts
Requires: google-noto-sans-avestan-fonts
Requires: google-noto-sans-balinese-fonts
Requires: google-noto-sans-balinese-vf-fonts
Requires: google-noto-sans-bamum-fonts
Requires: google-noto-sans-bamum-vf-fonts
Requires: google-noto-sans-bassa-vah-fonts
Requires: google-noto-sans-bassa-vah-vf-fonts
Requires: google-noto-sans-batak-fonts
Requires: google-noto-sans-bengali-fonts
Requires: google-noto-sans-bengali-ui-fonts
Requires: google-noto-sans-bhaiksuki-fonts
Requires: google-noto-sans-brahmi-fonts
Requires: google-noto-sans-buginese-fonts
Requires: google-noto-sans-buhid-fonts
Requires: google-noto-sans-canadian-aboriginal-fonts
Requires: google-noto-sans-carian-fonts
Requires: google-noto-sans-caucasian-albanian-fonts
Requires: google-noto-sans-chakma-fonts
Requires: google-noto-sans-cham-fonts
Requires: google-noto-sans-cham-vf-fonts
Requires: google-noto-sans-cherokee-fonts
Requires: google-noto-sans-chorasmian-fonts
Requires: google-noto-sans-cjk-fonts
Requires: google-noto-sans-coptic-fonts
Requires: google-noto-sans-cuneiform-fonts
Requires: google-noto-sans-cypriot-fonts
Requires: google-noto-sans-cypro-minoan-fonts
Requires: google-noto-sans-deseret-fonts
Requires: google-noto-sans-devanagari-fonts
Requires: google-noto-sans-devanagari-ui-fonts
Requires: google-noto-sans-duployan-fonts
Requires: google-noto-sans-egyptian-hieroglyphs-fonts
Requires: google-noto-sans-elbasan-fonts
Requires: google-noto-sans-elymaic-fonts
Requires: google-noto-sans-ethiopic-fonts
Requires: google-noto-sans-georgian-fonts
Requires: google-noto-sans-glagolitic-fonts
Requires: google-noto-sans-gothic-fonts
Requires: google-noto-sans-grantha-fonts
Requires: google-noto-sans-gujarati-fonts
Requires: google-noto-sans-gujarati-ui-fonts
Requires: google-noto-sans-gunjala-gondi-fonts
Requires: google-noto-sans-gunjala-gondi-vf-fonts
Requires: google-noto-sans-gurmukhi-fonts
Requires: google-noto-sans-gurmukhi-ui-fonts
Requires: google-noto-sans-hanifi-rohingya-fonts
Requires: google-noto-sans-hanifi-rohingya-vf-fonts
Requires: google-noto-sans-hanunoo-fonts
Requires: google-noto-sans-hatran-fonts
Requires: google-noto-sans-hebrew-fonts
Requires: google-noto-sans-hk-fonts
Requires: google-noto-sans-imperial-aramaic-fonts
Requires: google-noto-sans-indic-siyaq-numbers-fonts
Requires: google-noto-sans-inscriptional-pahlavi-fonts
Requires: google-noto-sans-inscriptional-parthian-fonts
Requires: google-noto-sans-javanese-fonts
Requires: google-noto-sans-javanese-vf-fonts
Requires: google-noto-sans-jp-fonts
Requires: google-noto-sans-kaithi-fonts
Requires: google-noto-sans-kannada-fonts
Requires: google-noto-sans-kannada-ui-fonts
Requires: google-noto-sans-kannada-ui-vf-fonts
Requires: google-noto-sans-kawi-fonts
Requires: google-noto-sans-kawi-vf-fonts
Requires: google-noto-sans-kayah-li-fonts
Requires: google-noto-sans-kayah-li-vf-fonts
Requires: google-noto-sans-kharoshthi-fonts
Requires: google-noto-sans-khmer-fonts
Requires: google-noto-sans-khojki-fonts
Requires: google-noto-sans-khudawadi-fonts
Requires: google-noto-sans-kr-fonts
Requires: google-noto-sans-lao-fonts
Requires: google-noto-sans-lao-looped-fonts
Requires: google-noto-sans-lao-looped-vf-fonts
Requires: google-noto-sans-lepcha-fonts
Requires: google-noto-sans-limbu-fonts
Requires: google-noto-sans-linear-a-fonts
Requires: google-noto-sans-linear-b-fonts
Requires: google-noto-sans-lisu-fonts
Requires: google-noto-sans-lisu-vf-fonts
Requires: google-noto-sans-lycian-fonts
Requires: google-noto-sans-lydian-fonts
Requires: google-noto-sans-mahajani-fonts
Requires: google-noto-sans-malayalam-fonts
Requires: google-noto-sans-malayalam-ui-fonts
Requires: google-noto-sans-malayalam-ui-vf-fonts
Requires: google-noto-sans-malayalam-vf-fonts
Requires: google-noto-sans-mandaic-fonts
Requires: google-noto-sans-manichaean-fonts
Requires: google-noto-sans-marchen-fonts
Requires: google-noto-sans-masaram-gondi-fonts
Requires: google-noto-sans-mayan-numerals-fonts
Requires: google-noto-sans-medefaidrin-fonts
Requires: google-noto-sans-medefaidrin-vf-fonts
Requires: google-noto-sans-meetei-mayek-fonts
Requires: google-noto-sans-mende-kikakui-fonts
Requires: google-noto-sans-meroitic-fonts
Requires: google-noto-sans-miao-fonts
Requires: google-noto-sans-modi-fonts
Requires: google-noto-sans-mongolian-fonts
Requires: google-noto-sans-mro-fonts
Requires: google-noto-sans-multani-fonts
Requires: google-noto-sans-myanmar-fonts
Requires: google-noto-sans-myanmar-vf-fonts
Requires: google-noto-sans-nabataean-fonts
Requires: google-noto-sans-nag-mundari-fonts
Requires: google-noto-sans-nag-mundari-vf-fonts
Requires: google-noto-sans-nandinagari-fonts
Requires: google-noto-sans-new-tai-lue-fonts
Requires: google-noto-sans-new-tai-lue-vf-fonts
Requires: google-noto-sans-newa-fonts
Requires: google-noto-sans-nko-fonts
Requires: google-noto-sans-nko-unjoined-fonts
Requires: google-noto-sans-nko-unjoined-vf-fonts
Requires: google-noto-sans-nushu-fonts
Requires: google-noto-sans-ogham-fonts
Requires: google-noto-sans-ol-chiki-fonts
Requires: google-noto-sans-old-hungarian-fonts
Requires: google-noto-sans-old-italic-fonts
Requires: google-noto-sans-old-north-arabian-fonts
Requires: google-noto-sans-old-permic-fonts
Requires: google-noto-sans-old-persian-fonts
Requires: google-noto-sans-old-sogdian-fonts
Requires: google-noto-sans-old-south-arabian-fonts
Requires: google-noto-sans-old-turkic-fonts
Requires: google-noto-sans-oriya-fonts
Requires: google-noto-sans-osage-fonts
Requires: google-noto-sans-osmanya-fonts
Requires: google-noto-sans-pahawh-hmong-fonts
Requires: google-noto-sans-palmyrene-fonts
Requires: google-noto-sans-pau-cin-hau-fonts
Requires: google-noto-sans-phagspa-fonts
Requires: google-noto-sans-phoenician-fonts
Requires: google-noto-sans-psalter-pahlavi-fonts
Requires: google-noto-sans-rejang-fonts
Requires: google-noto-sans-runic-fonts
Requires: google-noto-sans-samaritan-fonts
Requires: google-noto-sans-saurashtra-fonts
Requires: google-noto-sans-sc-fonts
Requires: google-noto-sans-sharada-fonts
Requires: google-noto-sans-shavian-fonts
Requires: google-noto-sans-siddham-fonts
Requires: google-noto-sans-signwriting-fonts
Requires: google-noto-sans-sinhala-fonts
Requires: google-noto-sans-sinhala-ui-fonts
Requires: google-noto-sans-sogdian-fonts
Requires: google-noto-sans-sora-sompeng-fonts
Requires: google-noto-sans-sora-sompeng-vf-fonts
Requires: google-noto-sans-soyombo-fonts
Requires: google-noto-sans-sundanese-fonts
Requires: google-noto-sans-sundanese-vf-fonts
Requires: google-noto-sans-syloti-nagri-fonts
Requires: google-noto-sans-symbols-fonts
Requires: google-noto-sans-syriac-eastern-fonts
Requires: google-noto-sans-syriac-eastern-vf-fonts
Requires: google-noto-sans-syriac-fonts
Requires: google-noto-sans-syriac-vf-fonts
Requires: google-noto-sans-syriac-western-fonts
Requires: google-noto-sans-syriac-western-vf-fonts
Requires: google-noto-sans-tagalog-fonts
Requires: google-noto-sans-tagbanwa-fonts
Requires: google-noto-sans-tai-le-fonts
Requires: google-noto-sans-tai-tham-fonts
Requires: google-noto-sans-tai-tham-vf-fonts
Requires: google-noto-sans-tai-viet-fonts
Requires: google-noto-sans-takri-fonts
Requires: google-noto-sans-tamil-fonts
Requires: google-noto-sans-tamil-supplement-fonts
Requires: google-noto-sans-tamil-ui-fonts
Requires: google-noto-sans-tamil-ui-vf-fonts
Requires: google-noto-sans-tangsa-fonts
Requires: google-noto-sans-tangsa-vf-fonts
Requires: google-noto-sans-tc-fonts
Requires: google-noto-sans-telugu-fonts
Requires: google-noto-sans-telugu-ui-fonts
Requires: google-noto-sans-telugu-ui-vf-fonts
Requires: google-noto-sans-thaana-fonts
Requires: google-noto-sans-thai-fonts
Requires: google-noto-sans-thai-looped-fonts
Requires: google-noto-sans-tifinagh-adrar-fonts
Requires: google-noto-sans-tifinagh-agraw-imazighen-fonts
Requires: google-noto-sans-tifinagh-ahaggar-fonts
Requires: google-noto-sans-tifinagh-air-fonts
Requires: google-noto-sans-tifinagh-apt-fonts
Requires: google-noto-sans-tifinagh-azawagh-fonts
Requires: google-noto-sans-tifinagh-fonts
Requires: google-noto-sans-tifinagh-ghat-fonts
Requires: google-noto-sans-tifinagh-hawad-fonts
Requires: google-noto-sans-tifinagh-rhissa-ixa-fonts
Requires: google-noto-sans-tifinagh-sil-fonts
Requires: google-noto-sans-tifinagh-tawellemmet-fonts
Requires: google-noto-sans-tirhuta-fonts
Requires: google-noto-sans-ugaritic-fonts
Requires: google-noto-sans-vai-fonts
Requires: google-noto-sans-vithkuqi-fonts
Requires: google-noto-sans-vithkuqi-vf-fonts
Requires: google-noto-sans-wancho-fonts
Requires: google-noto-sans-warang-citi-fonts
Requires: google-noto-sans-yi-fonts
Requires: google-noto-sans-zanabazar-square-fonts
Requires: google-noto-serif-ahom-fonts
Requires: google-noto-serif-armenian-fonts
Requires: google-noto-serif-balinese-fonts
Requires: google-noto-serif-bengali-fonts
Requires: google-noto-serif-cjk-fonts
Requires: google-noto-serif-devanagari-fonts
Requires: google-noto-serif-dives-akuru-fonts
Requires: google-noto-serif-dogra-fonts
Requires: google-noto-serif-ethiopic-fonts
Requires: google-noto-serif-georgian-fonts
Requires: google-noto-serif-grantha-fonts
Requires: google-noto-serif-gujarati-fonts
Requires: google-noto-serif-gurmukhi-fonts
Requires: google-noto-serif-hebrew-fonts
Requires: google-noto-serif-kannada-fonts
Requires: google-noto-serif-khitan-small-script-fonts
Requires: google-noto-serif-khmer-fonts
Requires: google-noto-serif-khojki-fonts
Requires: google-noto-serif-khojki-vf-fonts
Requires: google-noto-serif-lao-fonts
Requires: google-noto-serif-makasar-fonts
Requires: google-noto-serif-malayalam-fonts
Requires: google-noto-serif-malayalam-vf-fonts
Requires: google-noto-serif-myanmar-fonts
Requires: google-noto-serif-myanmar-vf-fonts
Requires: google-noto-serif-np-hmong-fonts
Requires: google-noto-serif-np-hmong-vf-fonts
Requires: google-noto-serif-old-uyghur-fonts
Requires: google-noto-serif-oriya-fonts
Requires: google-noto-serif-ottoman-siyaq-fonts
Requires: google-noto-serif-sinhala-fonts
Requires: google-noto-serif-tamil-fonts
Requires: google-noto-serif-tangut-fonts
Requires: google-noto-serif-telugu-fonts
Requires: google-noto-serif-thai-fonts
Requires: google-noto-serif-tibetan-fonts
Requires: google-noto-serif-tibetan-vf-fonts
Requires: google-noto-serif-toto-fonts
Requires: google-noto-serif-toto-vf-fonts
Requires: google-noto-serif-vithkuqi-fonts
Requires: google-noto-serif-vithkuqi-vf-fonts
Requires: google-noto-serif-yezidi-fonts
Requires: google-noto-serif-yezidi-vf-fonts
Requires: google-noto-traditional-nushu-fonts
Requires: google-noto-traditional-nushu-vf-fonts

%description fonts
The extra font set that comes with Filotimo.
Includes a complete set of Noto fonts to avoid tofu in all situations.


%package ime
Summary: IME setup for Filotimo
# This pulls in a glorious 117MiB yikes
Requires:  fcitx5
Requires:  kcm-fcitx5
Requires:  fcitx5-m17n

Requires:  fcitx5-chinese-addons
Requires:  fcitx5-hangul
Requires:  fcitx5-kkc
Requires:  fcitx5-libthai
Requires:  fcitx5-rime
Requires:  fcitx5-sayura
Requires:  fcitx5-unikey
Requires:  fcitx5-zhuyin
Requires:  fcitx5-table-extra
Requires:  fcitx5-table-other

Provides:  im-chooser
Obsoletes: im-chooser

%description ime
IME setup for Filotimo
pinyin, zhuyin etc - uses fcitx5

%prep

%install
install -pm 0644 %{SOURCE0} LICENSE
mkdir -p %{buildroot}%{_sysconfdir}/profile.d/
mkdir -p %{buildroot}%{_prefix}/lib/sysctl.d/
mkdir -p %{buildroot}%{_sysconfdir}/fonts/conf.d/
mkdir -p %{buildroot}%{_sysconfdir}/sudoers.d/
mkdir -p %{buildroot}%{_sysconfdir}/xdg/fcitx5/conf/
mkdir -p %{buildroot}%{_prefix}/lib/systemd/
install -t %{buildroot}%{_sysconfdir}/profile.d/ %{SOURCE1} %{SOURCE2} %{SOURCE3} %{SOURCE4} %{SOURCE5}
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
%config(noreplace) %{_sysconfdir}/profile.d/filotimo-kde-qml-font-fix.sh
%config(noreplace) %{_sysconfdir}/profile.d/filotimo-nvidia.sh
%config(noreplace) %{_sysconfdir}/profile.d/filotimo-obs-studio.sh
%config(noreplace) %{_sysconfdir}/profile.d/open.sh
%config(noreplace) %{_sysconfdir}/sudoers.d/filotimo-sudoers
%{_prefix}/lib/systemd/zram-generator.conf
%{_prefix}/lib/sysctl.d/99-filotimo.conf
%{_prefix}/lib/sysctl.d/80-inotify.conf

%files fonts
%config(noreplace) %{_sysconfdir}/fonts/conf.d/00-filotimo-default-font.conf

%files ime
%config(noreplace) %{_sysconfdir}/profile.d/filotimo-ime.sh
%config(noreplace) %{_sysconfdir}/xdg/fcitx5/conf/classicui.conf
%config(noreplace) %{_sysconfdir}/xdg/fcitx5/conf/notifications.conf

%changelog
