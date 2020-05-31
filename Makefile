install:
	install -D -m 755 -t /usr/local/bin ./backup-incrypte
	sed -i "s/VERSION=.*/VERSION='$(shell git describe)'/" /usr/local/bin/backup-incrypte
dist:
	mkdir /tmp/backup-incrypte-fakeroot
	install -D -m 755 -t /tmp/backup-incrypte-fakeroot/usr/local/bin ./backup-incrypte
	sed -i "s/VERSION=.*/VERSION='$(shell git describe)'/" /tmp/backup-incrypte-fakeroot/usr/local/bin/backup-incrypte
	tar czf backup-incrypte-$(shell git describe).tar.gz /tmp/backup-incrypte-fakeroot
	rm -rf /tmp/backup-incrypte-fakeroot
