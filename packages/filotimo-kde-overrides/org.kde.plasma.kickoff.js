/*
 *   00-start-here-kde-fedora.js - Set launcher icon to start-here-kde-fedora, and some other configuration
 *   Copyright (C) 2010 Kevin Kofler <kevin.kofler@chello.at>
 *   Copyright (C) 2010 Rex Dieter <rdieter@fedoraproject.org>
 *   Copyright (C) 2024 Thomas Duckworth <tduck973564@gmail.com>
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *   Portions lifted from 01-kubuntu-10.04.js:
 *   Harald Sitter, apachelogger@ubuntu.com 2010-04-02
 *   Jonathan Riddell, jriddell@ubuntu.com 2010-02-18
 *   Copyright Canonical Ltd, may be copied under the GNU GPL 2 or later
 */

if ( applet.readConfig("icon", "start-here-kde") == "start-here-kde" || applet.readConfig("icon", "start-here-kde-symbolic") == "start-here-kde-symbolic") {
  applet.currentConfigGroup = ["General"]
  applet.writeConfig("icon", "fedora-logo-icon-symbolic");
}

applet.currentConfigGroup = ["General"]
applet.writeConfig("favoritesDisplay", 1);
applet.writeConfig("showActionButtonCaptions", false);
