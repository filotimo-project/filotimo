%define fontname msttcore

# directory to unpack truetype fonts from the cab into
%define fontdir %{_datadir}/fonts/%{fontname} 

%define download_script     /usr/lib/msttcore-fonts-installer/refresh-msttcore-fonts.sh
%define cabfiles_sha256sums /usr/lib/msttcore-fonts-installer/cabfiles.sha256sums
%define license_file        /usr/share/doc/msttcore-fonts-installer/READ_ME!

Summary: Installer for Microsoft core TrueType fonts for better Windows Compatibility
Name: %{fontname}-fonts-installer
Obsoletes: msttcorefonts <= 2.6-1
Provides: msttcorefonts = 2.6-2
Version: {{{ git_dir_version }}}
Release: 2%{?dist}
License: GPLv2
Group: Fonts
BuildArch: noarch
Requires: curl
Requires: cabextract
Requires: fontconfig
Packager: Rob Janes <janes.rob gmail com>
Source: https://downloads.sourceforge.net/project/mscorefonts2/sources/msttcore-fonts-installer-2.6.tar.gz
URL: http://mscorefonts2.sourceforge.net/

%description
This installs the TrueType core fonts for the web that were once
available from http://www.microsoft.com/typography/fontpack/ prior
to 2002, and most recently updated in the European Union Expansion
Update circa May 2007, still available on the Microsoft website.
This also installs Microsoft's ClearType fonts, see
http://www.microsoft.com/typography/ClearTypeFonts.mspx for more info.

Note that the TrueType fonts are not part of the rpm.  They are
downloaded by the rpm when the rpm is installed.

The font cab files are downloaded from a Sourceforge project mirror
and unpacked at install time. Therefore this package technically
does not 'redistribute' the cab files.  The fonts are then added to
the core X fonts system as well as the Xft font system.

These are the cab files downloaded:

    andale32.exe, arialb32.exe, comic32.exe, courie32.exe,
    georgi32.exe, impact32.exe, webdin32.exe, EUupdate.EXE,
    wd97vwr32.exe, PowerPointViewer.exe

The following cab files are only downloaded if EUupdate.EXE cannot
be downloaded, since the EUupdate.EXE cab contains updates for
the fonts in these cabs:

    arial32.exe, times32.exe, trebuc32.exe, verdan32.exe

These are the fonts added:

    1998 Andale Mono
    2006 Arial: bold, bold italic, italic, regular
    1998 Arial: black
    2007 Calabri: bold, bold italic, italic, regular
    2007 Cambria: bold, bold italic, italic
    2007 Candara: bold, bold italic, italic, regular
    2007 Consolas: bold, bold italic, italic, regular
    2007 Constantia: bold, bold italic, italic, regular
    2007 Corbel: bold, bold italic, italic, regular
    1998 Comic: bold, regular
    2000 Courier: bold, bold italic, italic, regular
    1998 Impact
    2006 Times: bold, bold italic, italic, regular
    2006 Trebuchet: bold, bold italic, italic, regular
    2006 Verdana: bold, bold italic, italic, regular
    1998 Webdings

%prep
%setup

%install
find . | cpio -pdm $RPM_BUILD_ROOT

mkdir -p $RPM_BUILD_ROOT/%{fontdir}
echo not-empty > $RPM_BUILD_ROOT/%{fontdir}/fonts.dir 
echo not-empty > $RPM_BUILD_ROOT/%{fontdir}/fonts.scale 

%clean
[ "${RPM_BUILD_ROOT:-nonexistantdir}" != "/" ] && rm -rf ${RPM_BUILD_ROOT:-nonexistantdir}

%post
%{download_script} -F %{fontdir} -L %{license_file}

%postun
if [ "$1" = "0" ]; then
  counter=0
  for ff in %{fontdir}/*.ttf; do
    if [ -f "$ff" ]; then
      if [ $counter -eq 0 ]; then
        echo "### Removing ttf files in %{fontdir}" >&2
      fi

      # these files are installed "manually" so they must be removed "manually".
      # ie, rpm won't do it for us, it doesn't know about them.
      rm -f "$ff"

      counter=`expr $counter + 1`
    fi
  done
  if [ $counter -gt 0 ]; then
    echo "### ttf files already removed" >&2
  fi
  if [ -x %{_bindir}/fc-cache ]; then
    echo "### Rebuilding Xft font cache" >&2
    %{_bindir}/fc-cache -f -v || :
  fi

  [ -f /etc/fonts/conf.d/09-msttcore-fonts.conf ] && rm -f /etc/fonts/conf.d/09-msttcore-fonts.conf
  [ -f "%{license_file}" ] && rm -f "%{license_file}"
  [ -f /usr/lib/msttcore-fonts-installer/installed-list.txt ] && rm -f /usr/lib/msttcore-fonts-installer/installed-list.txt
fi

%files
%defattr(-,root,root,-)
%attr(-,root,root) %{fontdir}
%docdir /usr/share/doc/msttcore-fonts-installer
%attr(-,root,root) /usr/share/doc/msttcore-fonts-installer

/usr/lib/msttcore-fonts-installer

%changelog
* Wed May 29 2013  Rob Janes <janes.rob gmail com> 2.6-1
- added ClearType fonts, thanks to Robbie Litchfield.
  see http://www.microsoft.com/typography/ClearTypeFonts.mspx for more info.
- added %verify section to qualify rpm -V, thanks to discussion on rpmfusion
- bumped version number past Daniel Resare's.  Tried to coordinate with him, but he's
  working on mac stuff now and not interested - "I've given up on Linux on the desktop."
- available at https://downloads.sourceforge.net/project/mscorefonts2/specs/msttcore-fonts-installer-2.6-1.spec

* Sun Oct 7 2012  Rob Janes <janes.rob gmail com> 2.2-1
- moved install script to shell script, run in post step
- switched to sha256 from md5
- available at https://downloads.sourceforge.net/project/mscorefonts2/specs/msttcore-fonts-installer-2.2-1.spec

* Mon Sep 15 2012  Rob Janes <janes.rob gmail com> 2.1-2
- updated comments, messages, description and such.
- don't download older cabs for fonts in the EUupdate.EXE file,
  unless the download for the EUupdate failed.
- available at https://downloads.sourceforge.net/project/mscorefonts2/specs/msttcore-fonts-2.1-2.spec

* Sun Sep 9 2012 Daniel Resare <noa resare com> 2.5-1
- Daniel Resare: "Ouch, that was a few years. Due to the kind contributions of
  Deven T. Corzine we now have an updated (and working!) package again."
- Almost the same feature set as Dennis Johnson's 2.0-6
- updates the hardcoded sourceforge mirror list - does not use sourceforge's mirror redirect
  (meaning it will get out of date again).
- replaces deprecated BuildPrereq with BuildRequires
- available at http://corefonts.sourceforge.net/msttcorefonts-2.5-1.spec

* Sat Sep 8 2012  Rob Janes <janes.rob gmail com> 2.1-1
- generates distributable rpm that downloads and unpacks the fonts at
  install time, not rpmbuild time
- available at https://downloads.sourceforge.net/project/mscorefonts2/specs/msttcore-fonts-2.1-1.spec

* Sat Sep 8 2012  Rob Janes <janes.rob gmail com> 2.0-7
- added EUupdate.EXE European Union Expansion Update circa May 2007
- refactored sourceforge mirror stuff
- replaced wget with curl, which seems to be installed by default on fedora
- replaced ttmkfdir with mkfontscale and mkfontdir.  This creates fonts.dir file
  for the core X font system.  ttmkfdir has been supersceded by mkfontdir - they
  both create fonts.dir but mkfontdir is part of xorg-x11-font-utils.
- removed 09-msttcorefonts.conf and refactored fc-cache lines.  fc-cache walks
  subdirectories so the 09-msttcorefonts.conf to add the /usr/share/font/msttcore
  is redundant.  fc-cache indexes for the Xft font system, not the legacy core X
  font system.
- added 09-msttcore-fontpath.conf to /etc/X11/xorg.conf.d for core X font system
- added xset fp+ to add the fontdirectory to core X font for the current session so
  the installer doesn't have to relogin.
- available at https://downloads.sourceforge.net/project/mscorefonts2/specs/msttcore-fonts-2.0-7.spec

* Mon Aug 15 2011  Dennis Johnson 2.0-6
- BuildRequires ttmkfdir, cabextract, wget
- removes Requires
- fixes sourceforge mirror
- generates 09-msttcorefonts.conf
- restores call to ttmkfdir in install section
- available from http://fenris02.fedorapeople.org/msttcore-fonts-2.0-6.spec

* Sat Dec 11 2010  Hnr Kordewiner <hnr@kordewiner.com> 2.0-5
- move 09-msttcorefonts.conf to this spec file
- drop %{ttmkfdir} - again
- msttcore fonts history site setup at http://moin.kordewiner.com/helpdesk/fedora/mscorefonts
- available from http://moin.kordewiner.com/helpdesk/fedora/mscorefonts?action=AttachFile&do=get&target=msttcore-fonts-2.0-5.spec

* Mon Jun 07 2010 Zied FAKHFAKH <fzied@dottn.com> 2.0-3
- removed chkfontpath dependency for Fedora >= 9
- removed prerun and post chkconfig reference
- divergent development, same purpose as Andrew Bartlett's but derived from Noa Resare's 2.0-1
- available from http://moin.kordewiner.com/helpdesk/fedora/mscorefonts?action=AttachFile&do=get&target=msttcorefonts-2.0-3.spec

* Tue Jun 16 2009  Dennis Johnson
- Provides msttcorefonts
- Requires ttmkfdir, cabextract
- restores call to ttmkfdir in install section
- available from http://fenris02.fedorapeople.org/msttcore-fonts-2.0-4.spec

* Wed Jun 25 2008  Muayyad Saleh Alsadi <alsadi gmail com> 2.0-3
- drop %{ttmkfdir} completely 

* Mon Feb 18 2008 Andrew Bartlett <abartlet samba org> 2.0-2
- Make work with Fedora 9 fonts system
- available from http://moin.kordewiner.com/helpdesk/fedora/mscorefonts?action=AttachFile&do=get&target=msttcorefonts-2.0-2.spec

* Sun May 07 2006 Noa Resare <noa resare com> 2.0-1
- checksums downloads
- random mirror
- use redistributable word 97 viewer as source for tahoma.ttf
- available from http://corefonts.sourceforge.net/msttcorefonts-2.0-1.spec

* Mon Mar 31 2003 Daniel Resare <noa resare com> 1.3-4
- updated microsoft link
- updated sourceforge mirrors

* Mon Nov 25 2002 Daniel Resare <noa resare com> 1.3-3
- the install dir is now deleted when the package is uninstalled
- executable permission removed from the fonts
- executes fc-cache after install if it is available

* Thu Nov 07 2002 Daniel Resare <noa resare com> 1.3-2
- Microsoft released a new service-pack. New url for Tahoma font.

* Thu Oct 24 2002 Daniel Resare <noa resare com> 1.3-1
- removed python hack
- removed python hack info from description
- made tahoma inclusion depend on define
- added some info on the ttmkfdir define

* Tue Aug 27 2002 Daniel Resare <noa resare com> 1.2-3
- fixed spec error when tahoma is not included 

* Tue Aug 27 2002 Daniel Resare <noa resare com> 1.2-2
- removed tahoma due to unclear licensing
- parametrized ttmkfdir path (for mandrake users)
- changed description text to reflect the new microsoft policy

* Thu Aug 15 2002 Daniel Resare <noa resare com> 1.2-1
- changed distserver because microsoft no longer provides them

* Tue Apr 09 2002 Daniel Resare <noa resare com> 1.1-3
- fixed post/preun script to actually do what they were supposed to do

* Tue Mar 12 2002 Daniel Resare <noa resare com> 1.1-2
- removed cabextact from this package
- added tahoma font from ie5.5 update

* Fri Aug 25 2001 Daniel Resare <noa metamatrix se>
- initial version

