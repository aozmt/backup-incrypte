install:
	install -D -m 755 -t /usr/local/bin ./backup-gpg-tar-lftp
	sed -i "s/VERSION=.*/VERSION='$(shell git describe)'/" /usr/local/bin/backup-gpg-tar-lftp
dist:
	mkdir /tmp/backup-gpg-tar-lftp-fakeroot
	install -D -m 755 -t /tmp/backup-gpg-tar-lftp-fakeroot/usr/local/bin ./backup-gpg-tar-lftp
	sed -i "s/VERSION=.*/VERSION='$(shell git describe)'/" /tmp/backup-gpg-tar-lftp-fakeroot/usr/local/bin/backup-gpg-tar-lftp
	tar czf backup-gpg-tar-lftp-$(shell git describe).tar.gz /tmp/backup-gpg-tar-lftp-fakeroot
	rm -rf /tmp/backup-gpg-tar-lftp-fakeroot
