--boldon
--center Debian GNU/Linux
--center Paketerstellung
--center am Beispiel von binclock

--author Nico Golde <nico@ngolde.de>
--boldoff



--center Berlinux
--center 22.+23. Okt 2004


--center http://www.ngolde.de
--fgcolor white
--bgcolor black
--boldoff


--newpage Inhalt
--boldon
--huge Inhalt
--ulon
--horline
--boldoff
--uloff
--boldon




- Gründe für die Erstellung von Paketen

- Benötigte Software

- Vorbereitung 

- Debian-Pakete 

- Erstellung benötigter Dateien

- Konfiguration

- Build-Prozess

- Testen des Pakets

- Veröffentlichung:
  Wie mache ich das Paket verfügbar?

- Weitere Informationen


--newpage warum
--boldon
--huge Warum?
--ulon
--horline
--boldoff
--uloff
--boldon




- Eingliederung von Software in das Debian-Paketsystem

- Ziel: Offizieller Maintainer

- "NEU!"  Das Programm war bisher nicht als Debian-Paket verfügbar

- Erweiterung vorhandener Pakete, zB durch patches
  oder zusätzliche Konfigurationsdateien

- Cluster/Pool:  Leichte De- und Installation
  von Programmen auf mehreren Rechnern

- Auflösen von Abhängigkeiten und Konflikten
  dem Paketsystem überlassen können

- Eingliederung in das Menüsystem

--newpage software
--boldon
--huge Software
--ulon
--horline
--boldoff
--uloff
--boldon




- Compiler, Bibliotheken (Paket: build-essential)

- dpkg-dev (Hilfe beim Entpacken und Erstellen)

- debhelper 

- lintian (Paket-Checker)

- patch, dpatch, automake, autoconf


--newpage Vorbereitung
--boldon
--huge Vorbereitung
--ulon
--horline
--boldoff
--uloff
--boldon



- Existieren schon Pakete?
  ->  packages.debian.org

- Kontakt zum Autor herstellen!
  Interesse an einem Paket?

- Lizenzen überprüfen:
  Ist das Programm auch frei?
  aka "Klären der Fakten"
  -> Debian Free Software Guidelines (DFSG)

- Abhängigkeiten zu anderen Programmen prüfen

- Kenntnis des Programms erforderlich!

- Format des Dateinamens:
  paketname-version.tar.gz


--newpage paket
--boldon
--huge Pakete
--ulon
--horline
--boldoff
--uloff
--boldon


Inhalt:
--## --exec display paket.png

--beginoutput
Debian Paket:
(1) Quellpaket          (Source Package)
    - paket.orig.tar.gz   ("source archive")
    - paket.dsc           ("description")
    - paket.diff.gz       ("differences")

(2) Binärpaket (.deb)     (Binary Package)
--endoutput

- zu installierende Programme und Pfade

--newpage dateierstellung
--boldon
--huge Dateien - 1
--ulon
--horline
--boldoff
--uloff
--boldon



1. Entpacken der Quellen
---
--beginshelloutput
$ tar xvfz binclock-1.5.tar.gz
binclock-1.5/
binclock-1.5/CHANGELOG
binclock-1.5/COPYING
binclock-1.5/doc/
binclock-1.5/doc/binclock.1
binclock-1.5/src/
binclock-1.5/src/binclock.c
binclock-1.5/Makefile
binclock-1.5/README
binclock-1.5/INSTALL
binclock-1.5/binclockrc
--endshelloutput

2. Umbgebungsvariablen
---

--beginshelloutput
$ export DEBEMAIL="nico@ngolde.de"
--endshelloutput
--beginshelloutput
$ export DEBFULLNAME="Nico Golde"
--endshelloutput

--newpage dateien2
--boldon
--huge Dateien - 2  
--ulon
--horline
--boldoff
--uloff
--boldon



---
--beginshelloutput
$ dh_make
Type of package: single binary, multiple \
binary, library, or kernel module? [s/m/l/k]

---
Maintainer name : Nico Golde
Email-Address   : nico@ngolde.de
Date            : Sat, 16 Oct 2004 01:00:14 +0200
Package Name    : binclock
Version         : 1.5
Type of Package : Single
Hit <enter> to confirm:
---
Done. Please edit the files in the debian/ subdirectory now.
You should also check that the binclock Makefiles
install into $DESTDIR and not in / .
--endshelloutput


--beginslideleft
--color red
==> debian-Dateien (im Ordner debian/)
--endslideleft
--color white

--newpage Config-1
--boldon
--huge Config - 1
--ulon
--horline
--boldoff
--uloff
--boldon




--ulon
Die wichtigen Dateien:
--uloff

changelog:
(später /usr/share/doc/binclock/changelog.Debian.gz)
---

--beginoutput
binclock (1.5-1) unstable; urgency=low
  * Initial Release.
Nico Golde <nico@ngolde.de>  Fri, 15 Oct 2004 18:45:13 +0200
--endoutput

- Paketname, Version, Distribution, Priorität

- Änderungen am Paket, _nicht_ am Quellcode

- Name des Maintainers, Emailaddresse, Datum
--## "date -R" erstmal nicht so wichtig

- neuer changelog-Eintrag mit "dch -i"

--newpage Config-2a
--boldon
--huge Config - 2a
--ulon
--horline
--boldoff
--uloff
--boldon




Datei "control" (vor dem Editieren):
---

--beginoutput
Source: binclock
Section: unknown
Priority: optional
Maintainer: Nico Golde <nico@ngolde.de>
Build-Depends: debhelper (>= 4.1.0)
Standards-Version: 3.6.1

Package: binclock
Architecture: any
Depends: ${shlibs:Depends}, ${misc:Depends}
Description: <insert up to 60 chars description>
 <insert long description, indented with spaces>
--endoutput

--newpage Config-2b
--boldon
--huge Config - 2b
--ulon
--horline
--boldoff
--uloff
--boldon




Datei "control" (nach dem Editieren):

---
--beginoutput
Source: binclock
--color green
Section: utils 
--color white
Priority: optional
Maintainer: Nico Golde <nico@ngolde.de>
--color green
Build-Depends: debhelper (>= 4.1.0) 
--color white
Standards-Version: 3.6.1

Package: binclock
--color green
Architecture: any 
--color white
Depends: ${shlibs:Depends}, ${misc:Depends}
--color green
Description: binary clock for console with color support * (60 Zeichen)
 BinClock - Displays system time in binary format.
 It supports showing the time with eight different colors, and it can
 run a loop that prints the time every second.
 The default colors and characters for printing can be changed with a
 config file.
--color white

--endoutput
- Kontrollinformationen, Name des Quellpakets, Subsection, Maintainer, 
  Abhängigkeiten zum Bauen, Policy-Version

- Paketname, Architektur

- Abhängigkeiten (mögliche weitere Felder: Suggests, Conflicts, Replaces, ...)

- kurze und lange Beschreibung, kurze Beschreibung darf nicht mit 
  Programmnamen anfangen

--newpage Config-3a
--boldon
--huge Config - 3a
--ulon
--horline
--boldoff
--uloff
--boldon




copyright (vor dem Editieren):

--beginoutput
This package was debianized by Nico Golde <nico@ngolde.de> on
Tue, 19 Feb 2004 16:43:41 +0200.

It was downloaded from <fill in ftp site>

Copyright:

Upstream Author(s): <put author(s) name and email here>

License:

<Must follow here>
--endoutput

--newpage Config-3a
--boldon
--huge Config - 3b
--ulon
--horline
--boldoff
--uloff
--boldon

   
   
--beginoutput

This package was debianized by Nico Golde <nico@ngolde.de> on
Wed, 19 Feb 2004 16:43:41 +0100.
It was downloaded from http://www.ngolde.de/binclock/ 

Upstream Author: Nico Golde <binclock@ngolde.de> 


This software is copyrighted (c) 2003-2004 by Nico Golde.

You are free to distribute this software under
the terms of the GNU General Public License.
On Debian systems, the complete text of the
GNU General Public License can be found
in the file `/usr/share/common-licenses/GPL'.
--endoutput

- Download Ort

- Autor des Programmes

- Copyright (sollte DFSG kompatibel sein)

--newpage Config-4
--boldon
--huge Config - 4
--ulon
--horline
--boldoff
--uloff
--boldon




dirs:

  - Verzeichnisse, die nicht vom Makefile angelegt werden

  - ohne / am Anfang, Bsp.: usr/man

conffiles.ex:

  - Konfigurationsdateienm, für manuelle Auswahl, in dem Fall /etc/binclockrc

  - WICHTIG: datei.ex immer in datei umbenennen, wenn sie verwendet wird


docs:

  - zu installierende Dokumentationsdatein, in dem Fall nur README


README.Debian:

  - nennenswerte Unterschied zum Original


--newpage Configis
--boldon
--huge Config - 5
--ulon
--horline
--boldoff
--uloff
--boldon




menu.ex:

  - Fenstermanager-Menu

vor dem Editieren:

--beginoutput
?package(binclock):needs="X11|text|vc|wm" section="Apps/see-menu-manual"\ 
  title="binclock" command="/usr/bin/binclock"
--endoutput

--beginoutput
?package(binclock): needs="text|X11" section="Apps/Tools" \
  title="BinClock" command="/usr/bin/binclock"
--endoutput

- Bestimmung von Oberfläche, Abteilung, Titel und das auszuführende Kommando

--newpage Config-5
--boldon
--huge Config - 6
--ulon
--horline
--boldoff
--uloff
--boldon



rules:
---
--## this doesn't works here, because there is no rules file
--##--exec vim rules
--exec echo "eigentlich wäre hier die rules datei, sie ist in diesem beispiel leider nicht enthalten" | vim -

--newpage Config-6
--boldon
--huge Config - 7
--ulon
--horline
--boldoff
--uloff
--boldon



Anpassung des Makefiles:

vor dem Editieren:

--beginoutput
INSPATH = /usr/local/bin/
MANPATH = /usr/man/man1/
CONF = /etc/
all : $(MAINSRC)
        gcc -02 --pedantic -Wall -o binclock ./src/binclock.c
        strip binclock
install :
        cp -pf CHANGELOG README COPYING
        cp -pf ./doc/binclock.1 $(MANPATH)
        cp -pf binclockrc $(CONF)binclockrc
        install -c -s -m 0755 binclock $(INSPATH)
clean :
        rm -f binclock
uninstall :
        rm -f $(INSPATH)binclock
        rm -f $(CONF)$(BIN)rc
        rm -f $(MANPATH)/binclock.1
--endoutput
--newpage Config-a
--boldon
--huge Config - 8
--ulon
--horline
--boldoff
--uloff
--boldon




Nach dem Editieren:

--beginoutput
--color green
INSPATH = $(DESTDIR)/usr/bin/
MANPATH = $(DESTDIR)/usr/share/man/man1/
CONF = $(DESTDIR)/etc/
all : $(MAINSRC)
--color white
        gcc --pedantic -Wall -o binclock ./src/binclock.c
        strip binclock
install :
        cp -pf ./doc/binclock.1 $(MANPATH)
        cp -pf binclockrc $(CONF)binclockrc
        install -c -s -m 0755 $(BIN) $(INSPATH)
clean :
        rm -f $(SOURCEPATH)$(BIN)
--endoutput

- Anpassung der Variablen mit $(DESTDIR)

- Entfernen von Regeln, die von debhelper übernommen werden

- bei Programmen mit configure Scripten normalerweise nicht nötig, 
  sondern in rules statt $(DESTDIR) prefix einsetzen


--newpage Config-7
--boldon
--huge Config-9
--ulon
--horline
--boldoff
--uloff
--boldon




Letzte Schritte:

.ex-Dateien:

  - Spezialfälle, je nach Bedarf editieren und umbennen

  - anschliessend übrige .ex Dateien löschen

  - eventuell Manual schreiben (so wie in der Policy beschrieben)

  - falls benötigt die Maintainer-Scripte editieren: postinst.ex, preinst.ex, 
    postrm.ex, prerm.ex
    -> werden ausgeführt bei Installation, Löschen oder Aktualisierung eines Paketes

  - umbenennen von binclock-1.5.tar.gz in binclock_1.5.orig.tar.gz

--newpage build
--boldon
--huge Build Prozess
--ulon
--horline
--boldoff
--uloff
--boldon




Schritt 1:

  - Zurückkehren in das Stammverzeichnis des Programms, i.d. Fall binclock-1.5/

Schritt 2:

  - Bauen des Paketes mittels dpkg-buildpackage -rfakeroot

---
--color red
--beginslideleft
==> Debian-Paket in binclock-1.5/../
--endslideleft
--color white
--newpage build2
--boldon
--huge Nach dem Build
--ulon
--horline
--boldoff
--uloff
--boldon




Neue Dateien in binclock-1.5/../ :

---
--beginshelloutput
$ ls
--color blue
binclock-1.5
--color white
binclock_1.5-1.diff.gz
binclock_1.5-1.dsc
binclock_1.5-1_i386.changes
binclock_1.5-1_i386.deb
binclock_1.5.orig.tar.gz
--endshelloutput

- Alle Änderungen am Originalquelltext (.diff.gz)

- Paketname, Version, Maintainer, Architektur, Build-Depends,
  Policy Version, Dateien mit md5 Summen (.dsc)

- Paketdatum, Version, Distribution, Maintainer,
  _Veränderungen_, Paketbeschreibung,
  Dateien mit md5 Summen (.changes)

- Alle zur installierenden Dateien mit Ordnern gezippt (.deb)

- Originalquellen (.orig.tar.gz)

--newpage test
--boldon
--huge Tests
--ulon
--horline
--boldoff
--uloff
--boldon

1. Testen auf Policy mit lintian (Paket-Checker):

---
--beginshelloutput
$ lintian binclock_1.5-1_i386.changes
E: binclock: binary-without-manpage binclock
--endshelloutput

- Fehler und Warnungen beseitigen (lintian -i für weiter Eklärungen)

2. Testen des Paketinhalts:
---

--beginshelloutput
$ dpkg -c binclock_1.5-1_i386.deb
drwxr-xr-x root/root         0 2004-10-17 16:38:42 ./
drwxr-xr-x root/root         0 2004-10-17 16:38:42 ./usr/
drwxr-xr-x root/root         0 2004-10-17 16:38:42 ./usr/bin/
-rwxr-xr-x root/root      7500 2004-10-17 16:38:42 ./usr/bin/binclock
drwxr-xr-x root/root         0 2004-10-17 16:38:41 ./usr/share/
drwxr-xr-x root/root         0 2004-10-17 16:38:41 ./usr/share/man/
drwxr-xr-x root/root         0 2004-10-17 16:38:43 ./usr/share/man/man1/
-rw-r--r-- root/root       882 2004-10-17 16:38:41 ./usr/share/man/man1/binclock.1.gz
drwxr-xr-x root/root         0 2004-10-17 16:38:41 ./usr/share/doc/
drwxr-xr-x root/root         0 2004-10-17 16:38:43 ./usr/share/doc/binclock/
-rw-r--r-- root/root      1698 2004-07-24 13:42:04 ./usr/share/doc/binclock/README
-rw-r--r-- root/root       484 2004-07-24 15:10:45 ./usr/share/doc/binclock/copyright
-rw-r--r-- root/root       319 2004-07-24 15:10:45 ./usr/share/doc/binclock/changelog.Debian.gz
drwxr-xr-x root/root         0 2004-10-17 16:38:42 ./usr/lib/
drwxr-xr-x root/root         0 2004-10-17 16:38:42 ./usr/lib/menu/
-rw-r--r-- root/root        99 2004-07-24 19:54:23 ./usr/lib/menu/binclock
drwxr-xr-x root/root         0 2004-10-17 16:38:41 ./etc/
--endshelloutput

- Installieren des Pakets mittels dpkg -i binclock-1.5-1_i386.deb (wahlweise in chroot)

--newpage Veröffentlichung
--boldon
--huge Veröffentlichung
--ulon
--horline
--boldoff
--uloff
--boldon




1. Kopieren des Quellpakets und Binärpakets in
   gewünschten Ordner (z.B. auf einen http-Server)

---
--beginshelloutput
$ ls
binclock_1.5-1.diff.gz   binclock_1.5-1.dsc
binclock_1.5-1_i386.deb  binclock_1.5.orig.tar.gz
--endshelloutput

2. Erstellen von Sources.gz (Namen, Version, Build-Depends)
   und Packages.gz (Beschreibung, Name, Abhängigkeiten)

---
--beginshelloutput
$ dpkg-scanpackages ./ /dev/null | gzip -9c > Packages.gz
 ** Packages in archive but missing from override file: **
  binclock

  Wrote 1 entries to output Packages file.
--endshelloutput
---

--beginshelloutput
$ dpkg-scansources ./ /dev/null | gzip -9c > ./Sources.gz
--endshelloutput

--beginshelloutput
$ echo thats all :)
--endshelloutput

--newpage Ende
--boldon
--huge Danke! Fragen?
--ulon
--horline
--boldoff
--uloff
--boldon



Feedback:

--center Nico Golde <nico@ngolde.de>
--center http://www.ngolde.de

--newpage Links
--boldon
--huge Links
--ulon
--horline
--boldoff
--uloff
--boldon




http://www.debian.org

http://www.debian.org/devel/

debian-reference, maint-guide, debian-policy

http://www.openoffice.de/linux/buch/debianpakete.html

http://mentors.debian.net/

debian-mentors@lists.debian.org

debian-devel@lists.debian.org

http://www.ngolde.de/papers.html

Vortragsunterlagen: http://www.ngolde.de/papers.html

Präsentationsprogramm: TPP <http://www.ngolde.de/tpp>
