# Makefile for frugalware
#
# Copyright (C) 2007, 2008 Miklos Vajna <vmiklos@frugalware.org>
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

VERSION = 0.8rc1
CODENAME = Kalgan

FRUGALWARE_LANGS = de hu it
SERVICE_LANGS = de hu

INSTALL = /usr/bin/install -c
DESTDIR =

all:
	chmod +x var/service
	help2man -n "manages Frugalware services" -S Frugalware -N var/service |sed 's/\\(co/(c)/' >var/service.1

install:
	$(INSTALL) -d $(DESTDIR)/bin
	$(INSTALL) -d $(DESTDIR)/boot
	$(INSTALL) -d $(DESTDIR)/dev
	$(INSTALL) -d $(DESTDIR)/etc
	sed 's/@VERSION@/$(VERSION)/;s/@CODENAME@/$(CODENAME)/' etc/frugalware-release.in > $(DESTDIR)/etc/frugalware-release
	sed 's/@VERSION@/$(VERSION)/;s/@CODENAME@/$(CODENAME)/' etc/issue.in > $(DESTDIR)/etc/issue
	$(INSTALL) -m644 etc/issue.net $(DESTDIR)/etc/
	$(INSTALL) -m644 etc/ld.so.conf $(DESTDIR)/etc/
	$(INSTALL) -m644 etc/nsswitch.conf $(DESTDIR)/etc/
	$(INSTALL) -m644 etc/securetty $(DESTDIR)/etc/
	$(INSTALL) -m644 etc/termcap $(DESTDIR)/etc/
	$(INSTALL) -d $(DESTDIR)/etc/pacman-g2/hooks/
	$(INSTALL) -m644 etc/update-frugalware-version $(DESTDIR)/etc/pacman-g2/hooks/
	$(INSTALL) -d $(DESTDIR)/etc/X11
	$(INSTALL) -d $(DESTDIR)/etc/rc.d
	for i in $(FRUGALWARE_LANGS); do \
		mkdir -p $(DESTDIR)/lib/initscripts/messages/$${i}_`echo $$i|tr [:lower:] [:upper:]`/LC_MESSAGES/; \
	done
	for i in $(SERVICE_LANGS); do \
		mkdir -p $(DESTDIR)/var/lib/frugalware/messages/$${i}_`echo $$i|tr [:lower:] [:upper:]`/LC_MESSAGES/; \
	done
	$(INSTALL) etc/rc.d/rc.frugalware $(DESTDIR)/etc/rc.d
	for i in $(FRUGALWARE_LANGS); do \
		msgfmt -c --statistics -o $(DESTDIR)/lib/initscripts/messages/$${i}_`echo $$i|tr [:lower:] [:upper:]`/LC_MESSAGES/frugalware.mo etc/rc.d/rc.frugalware-$$i; \
	done
	$(INSTALL) -d $(DESTDIR)/etc/skel
	$(INSTALL) -d $(DESTDIR)/etc/sysconfig
	ln -sf ../profile.d/lang.sh $(DESTDIR)/etc/sysconfig/language
	$(INSTALL) -d $(DESTDIR)/home
	$(INSTALL) -d $(DESTDIR)/mnt
	$(INSTALL) -d $(DESTDIR)/proc
	$(INSTALL) -d -m710 $(DESTDIR)/root
	$(INSTALL) -d $(DESTDIR)/sbin
	$(INSTALL) -d $(DESTDIR)/sys
	$(INSTALL) -d -m1777 $(DESTDIR)/tmp
	$(INSTALL) -d -m1777 $(DESTDIR)/tmp/.ICE-unix
	$(INSTALL) -d -m1777 $(DESTDIR)/tmp/.X11-unix
	$(INSTALL) -d $(DESTDIR)/usr
	ln -sf /var/adm $(DESTDIR)/usr/
	$(INSTALL) -d $(DESTDIR)/usr/bin
	$(INSTALL) -d $(DESTDIR)/usr/dict
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
	$(INSTALL) -d $(DESTDIR)/usr/local/man
	for i in {cat,man}{1,2,3,4,5,6,7,8,9,n}; do \
		$(INSTALL) -d $(DESTDIR)/usr/local/man/$$i; \
	done
	$(INSTALL) -d $(DESTDIR)/usr/local/sbin
	$(INSTALL) -d $(DESTDIR)/usr/local/src
	$(INSTALL) -d $(DESTDIR)/usr/sbin
	$(INSTALL) -d $(DESTDIR)/usr/share
	$(INSTALL) -d $(DESTDIR)/usr/share/man
	for i in man{1,2,3,4,5,6,7,8,9,n}; do \
		$(INSTALL) -d $(DESTDIR)/usr/share/man/$$i; \
	done
	for i in cat{1,2,3,4,5,6,7,8,9,n}; do \
		ln -sf ../../var/man/$$i $(DESTDIR)/usr/share/man/$$i; \
	done
	ln -sf /var/spool $(DESTDIR)/usr/spool
	$(INSTALL) -d $(DESTDIR)/usr/src
	ln -sf /var/tmp $(DESTDIR)/usr/tmp
	$(INSTALL) -d $(DESTDIR)/var
	ln -sf log $(DESTDIR)/var/adm
	$(INSTALL) -d $(DESTDIR)/var/lib
	$(INSTALL) -d $(DESTDIR)/var/lib/frugalware
	$(INSTALL) -d $(DESTDIR)/var/lib/frugalware/messages
	$(INSTALL) -m644 var/rc.messages $(DESTDIR)/var/lib/frugalware/messages/rc.messages
	$(INSTALL) -d $(DESTDIR)/var/lib/frugalware/system
	$(INSTALL) var/service $(DESTDIR)/var/lib/frugalware/system/
	$(INSTALL) -m644 var/service.1 $(DESTDIR)/usr/share/man/man1/
	ln -s ../var/lib/frugalware/system/service $(DESTDIR)/sbin/service
	for i in $(SERVICE_LANGS); do \
		msgfmt -c --statistics -o $(DESTDIR)/var/lib/frugalware/messages/$${i}_`echo $$i|tr [:lower:] [:upper:]`/LC_MESSAGES/service.mo var/service-$$i; \
	done
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
	$(INSTALL) -d $(DESTDIR)/var/man
	$(INSTALL) -d -m1777 $(DESTDIR)/var/tmp
	ln -sf /var/spool/rwho $(DESTDIR)/var/rwho
ifeq ($(shell uname -m),x86_64)
	ln -sf /lib $(DESTDIR)/lib64
	ln -sf /usr/lib $(DESTDIR)/usr/lib64
	ln -sf /usr/local/lib $(DESTDIR)/usr/local/lib64
endif

dist:
	git-archive --format=tar --prefix=frugalware-$(VERSION)/ HEAD > frugalware-$(VERSION).tar
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
