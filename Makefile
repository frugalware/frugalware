# Makefile for frugalware
#
# Copyright (C) 2007, 2008, 2009, 2010, 2011, 2012 Miklos Vajna <vmiklos@frugalware.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#

VERSION = 2.1
CODENAME = Derowd

INSTALL = /usr/bin/install -c
DESTDIR =

all:

install:
	$(INSTALL) -d $(DESTDIR)/boot
	$(INSTALL) -d $(DESTDIR)/dev
	$(INSTALL) -d $(DESTDIR)/etc
	sed 's/@VERSION@/$(VERSION)/;s/@CODENAME@/$(CODENAME)/' etc/frugalware-release.in > $(DESTDIR)/etc/frugalware-release
	sed 's/@VERSION@/$(VERSION)/;s/@CODENAME@/$(CODENAME)/' etc/os-release.in > $(DESTDIR)/etc/os-release
	sed 's/@VERSION@/$(VERSION)/;s/@CODENAME@/$(CODENAME)/' etc/issue.in > $(DESTDIR)/etc/issue
	$(INSTALL) -m644 etc/issue.net $(DESTDIR)/etc/
	$(INSTALL) -m644 etc/motd $(DESTDIR)/etc/
	$(INSTALL) -m644 etc/ld.so.conf $(DESTDIR)/etc/
	$(INSTALL) -m644 etc/nsswitch.conf $(DESTDIR)/etc/
	$(INSTALL) -m644 etc/securetty $(DESTDIR)/etc/
	$(INSTALL) -m644 etc/termcap $(DESTDIR)/etc/
	$(INSTALL) -d $(DESTDIR)/etc/X11
	$(INSTALL) -d $(DESTDIR)/etc/rc.d
	$(INSTALL) -d $(DESTDIR)/etc/skel
	$(INSTALL) -d $(DESTDIR)/etc/sysconfig
	$(INSTALL) -d $(DESTDIR)/etc/ld.so.conf.d
	$(INSTALL) -d $(DESTDIR)/home
	$(INSTALL) -d $(DESTDIR)/mnt
	$(INSTALL) -d $(DESTDIR)/media
	$(INSTALL) -d $(DESTDIR)/run
	$(INSTALL) -d $(DESTDIR)/opt
	$(INSTALL) -d $(DESTDIR)/proc
	$(INSTALL) -d -m710 $(DESTDIR)/root
	$(INSTALL) -d $(DESTDIR)/sys
	$(INSTALL) -d -m1777 $(DESTDIR)/tmp
	$(INSTALL) -d -m1777 $(DESTDIR)/tmp/.ICE-unix
	$(INSTALL) -d -m1777 $(DESTDIR)/tmp/.X11-unix
	$(INSTALL) -d $(DESTDIR)/usr
	ln -sf /var/adm $(DESTDIR)/usr/
	$(INSTALL) -d $(DESTDIR)/usr/bin
	$(INSTALL) -d $(DESTDIR)/usr/include
	$(INSTALL) -d $(DESTDIR)/usr/info
	$(INSTALL) -d $(DESTDIR)/usr/lib
	$(INSTALL) -d $(DESTDIR)/usr/local
	$(INSTALL) -d $(DESTDIR)/usr/local/bin
	$(INSTALL) -d $(DESTDIR)/usr/local/etc
	$(INSTALL) -d $(DESTDIR)/usr/local/games
	$(INSTALL) -d $(DESTDIR)/usr/local/include
	$(INSTALL) -d $(DESTDIR)/usr/local/info
	$(INSTALL) -d $(DESTDIR)/usr/local/lib
	$(INSTALL) -d $(DESTDIR)/usr/local/share/man
	for i in {cat,man}{1,2,3,4,5,6,7,8,9,n}; do \
		$(INSTALL) -d $(DESTDIR)/usr/local/share/man/$$i; \
	done
	$(INSTALL) -d $(DESTDIR)/usr/local/src
	$(INSTALL) -d $(DESTDIR)/usr/share
	$(INSTALL) -d $(DESTDIR)/usr/share/man
	for i in man{1,2,3,4,5,6,7,8,9,n}; do \
		$(INSTALL) -d $(DESTDIR)/usr/share/man/$$i; \
	done
	for i in cat{1,2,3,4,5,6,7,8,9,n}; do \
		ln -sf ../../../var/man/$$i $(DESTDIR)/usr/share/man/$$i; \
	done
	ln -sf /var/spool $(DESTDIR)/usr/spool
	$(INSTALL) -d $(DESTDIR)/usr/src
	ln -sf /var/tmp $(DESTDIR)/usr/tmp
	$(INSTALL) -d $(DESTDIR)/var
	ln -sf log $(DESTDIR)/var/adm
	$(INSTALL) -d $(DESTDIR)/var/lib
	$(INSTALL) -d $(DESTDIR)/var/lib/frugalware
	$(INSTALL) -d $(DESTDIR)/var/lib/frugalware/system
	$(INSTALL) -d $(DESTDIR)/var/lib/frugalware/tmp
	$(INSTALL) -d $(DESTDIR)/var/lib/frugalware/tools
	$(INSTALL) -d $(DESTDIR)/var/lib/frugalware/user
	$(INSTALL) -d $(DESTDIR)/var/lock
	$(INSTALL) -d $(DESTDIR)/var/log
	ln -sf spool/mail $(DESTDIR)/var/mail
	$(INSTALL) -d $(DESTDIR)/var/man
	for i in cat{1,2,3,4,5,6,7,8,9,n}; do \
		$(INSTALL) -d -m700 $(DESTDIR)/var/man/$$i; \
	done
	$(INSTALL) -d $(DESTDIR)/var/run
	$(INSTALL) -d $(DESTDIR)/var/spool
	$(INSTALL) -d $(DESTDIR)/var/spool/mail
	$(INSTALL) -d -m1777 $(DESTDIR)/var/tmp
ifeq ($(shell uname -m),x86_64)
	ln -sf /usr/lib $(DESTDIR)/lib64
	ln -sf /usr/lib $(DESTDIR)/usr/lib64
	ln -sf /usr/local/lib $(DESTDIR)/usr/local/lib64
endif
	ln -sf /usr/lib $(DESTDIR)/lib
	ln -sf /usr/bin $(DESTDIR)/bin
	ln -sf /usr/bin $(DESTDIR)/sbin
	ln -sf /usr/bin $(DESTDIR)/usr/sbin

dist:
	git archive --format=tar --prefix=frugalware-$(VERSION)/ HEAD > frugalware-$(VERSION).tar
	mkdir -p frugalware-$(VERSION)
	git log --no-merges |git name-rev --tags --stdin > frugalware-$(VERSION)/Changelog
	tar rf frugalware-$(VERSION).tar frugalware-$(VERSION)/Changelog
	rm -rf frugalware-$(VERSION)
	gzip -f -9 frugalware-$(VERSION).tar
	gpg --comment "See http://ftp.frugalware.org/pub/README.GPG for info" \
		-ba -u 20F55619 frugalware-$(VERSION).tar.gz
	mv frugalware-$(VERSION).tar.gz{,.asc} ../

release:
	git tag -l |grep -q $(VERSION) || dg tag $(VERSION)
	$(MAKE) dist
