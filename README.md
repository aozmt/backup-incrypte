# backup-gpg-tar-lftp

This is the backup script that I created out of necessity since I needed the following features for my data:

+ State-of-the-art encryption
+ Differential backups to an sftp location without a local copy (Transfer- and storage efficiency)
+ Open-source backup program that I can audit
+ Recovery with common Linux tools

The software is provided as-is without any warranty.

## Configuration and data model

The program is configured via environment variables prefixed by BACKUP_:

```console
export BACKUP_ARCHIVES="home other"
export BACKUP_FILES_home="--exclude-vcs-ignores --exclude-ignore=.backupignore /home/user"
export BACKUP_FILES_other="--exclude-vcs-ignores --exclude-ignore=.backupignore /other"
export BACKUP_GPG_RECIPIENT=user@localhost
export BACKUP_OUTPUT_DIRECTORY=sftp://user:@localhost/home/user
```
Tar snapshots are retained under ~/.backup/snapshot.

## Features implemented '[X]' and to be implemented '[ ]'

- [X] Upload encrypted differential tar backups directly to SFTP
- [X] Be able to cancel ongoing backup
- [X] Define multiple patterns for an archive
- [X] Parallelize gz so it isn't a bottleneck on local network
- [X] Add verify subcommand for the truly paranoid
- [X] Count-down when in interactive shell before starting
- [X] Filter away tar's superflous listing of directories 
     -> Tar also backs up and restores directory listings. That's why there is an entry for them.
- [X] Consider describing each archive by a file under .backup/archive-from/NAME
      -> It's better to keep everything in environment variables.
- [X] Keep log
- [ ] Do not run multiple instances simultaneously, keep a lock!
- [ ] Calculate estimated time to complete and show progress
- [ ] Automate .ssh known_hosts entry and gpg public key import
- [ ] Write tests for all features, incl. cancellation
- [ ] Use temporary generated GPG key in tests
- [ ] Check lftp gotcha and warn: LFTP can use SSH's PKI, but still needs to be provided an empty password, otherwise it will prompt for one.    https://unix.stackexchange.com/questions/181781/using-lftp-with-ssh-agent/205067#205067 .
