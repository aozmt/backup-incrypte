# backup-incrypte bash shell script

backup-incrypte is a bash shell script for *incr*emental, en*crypt*ed and
remo*te* backup suitable for the 3-2-1 backup strategy. I have create this
script since I needed the following features for my backups:

- Particularly suitable for 3-2-1 backup strategy
- Incremental backups
- Remote location via sftp
- Strong encryption
- Auditability, preferrably open-source
- Compatibility of the archive format with easily available tools
- Runs on Windows (with Msys2) & Linux
- Easily deployable

With these requirements, I have considered following from
https://en.wikipedia.org/wiki/List_of_backup_software in detail:

- Windows-Backup via File History: Imaginable to use in combination with a
  Bitlocker volume that gets differentially syncronized to OneDrive. Possible as
  of 31.5.2020. File restoration nicely integrated with Windows, as long as the
  operating system is intact. Restoring on other Windows instances not
  trivial. I missed the information over backup progress and the target file
  system layout.

- duplicity: Satisfies all the requirements except formulated above, except that
  I didn't succeed in using on Windows with Msys2.

- Bacula: Seems worth to investigate for multi-node situations. Too much
  initial effort needed for a single machine.

None of the solutions was easy enough to use and met my requirements. For this
reason I have implemented my own.

The software is provided under GPL 3 or later. Enjoy.

## Usage from command line

The basic functionality accessible from the command line includes:

```console
▶ ./backup-incrypte -h
./backup-incrypte [-h|--help] [-V|--version] [SUBCOMMAND]
Bash shell script for *incr*emental, en*crypt*ed and remo*te* backup
suitable for the 3-2-1 backup strategy

Where SUBCOMMAND is one of:
  save   [-v|--verbose]  [-t|--timestamp] [-f|--full] [-n|--dry-run] 
         [-o|--output-directory PATH] [ARCHIVES]
  verify [-v|--verbose] [ARCHIVES]
  upload [-v|--verbose]
  download [-v|--verbose]
  save+upload
  save+verify+upload
```

Subcommand `save` is incremantal by default. A full backup is performed if there
is no previous snapshot or `--full` parameter is specified. Subcommand `verify`
decrypts & extracts files from the archive and compares last modification dates
with the files on disk. Currently this operation may take some time. Subcommand
`upload` syncronizes the archies in the `BACKUP_OUTPUT_DIRECTORY` (usually
local) to `BACKUP_MIRROR` (usually remote). Subcommand `download` does the opposite.

Even though it can ba automated quite easily from the shell, for convenience,
functionality to be called from daily backup scripts; `save+upload` and
`save+verify+upload`.

## Configuration via environment variables

The program is configured via environment variables prefixed by BACKUP_. An
archive is configured by defining tar parameteters `BACKUP_FILES_<name>` and
including `<name>` in BACKUP_ARCHIVES:

```console
export BACKUP_ARCHIVES="myhome"
export BACKUP_FILES_myhome="--exclude-vcs-ignores --exclude-ignore=.backupignore /home/user"
```

Configuration contains the defaults:

```console
export BACKUP_HOME="$HOME/.backup"
export BACKUP_GPG_RECIPIENT="$USERNAME@$HOST"
export BACKUP_OUTPUT_DIRECTORY="$BACKUP_HOME/archives"
export BACKUP_MIRROR=""
```

`BACKUP_OUTPUT_DIRECTORY` is where the resulting archives are saved and
`BACKUP_MIRROR` a mirror directory, preferrably remote, that can be configured
such as:

```console
export BACKUP_MIRROR="sftp://user:@localhost/home/user"
```

## Installation

The script uses tar, gpg, lftp and optionally pigz. Provided that these are in
your path, you can just clone the repository and use `make install`.

## File system layout

- $BACKUP_HOME: Root directory, defaults to $HOME/.backup
  - snaphots: Target directory for tar snapshots, which are manifests necessary
    for creation of incremental archives. (More in the tar man page)
  - tmp: Temporary directory where files are places while they are being created.
  - archives: Default output directory for archive files.
    - myhome-20200520-185934-full.tar.gz.gpg: A full backup
    - myhome-20200521-185934.tar.gz.gpg: An incremental backup
    - ...

## Features

Implemented '[X]' and to be implemented '[ ]'.

- [X] Capability to upload encrypted differential tar backups directly to SFTP
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
- [ ] Use temporary generated GPG key in tests
- [ ] Be more robust with utf-8 chars and symbolic links
- [ ] Be faster with I/O
- [ ] Do not run multiple instances simultaneously, keep a lock!
- [ ] Calculate estimated time to complete and show progress
- [ ] Automate .ssh known_hosts entry and gpg public key import
- [ ] Write tests for all features, incl. cancellation
- [ ] Check lftp gotcha and warn: LFTP can use SSH's PKI, but still needs to be provided an empty password, otherwise it will prompt for one. https://unix.stackexchange.com/questions/181781/using-lftp-with-ssh-agent/205067#205067 .

## Performance

Following performance was shown on a i7 machine from 2017. The
`BACKUP_OUTPUT_DIRECTORY` was on an usb stick with full-encryption. The
upload bandwidth to `BACKUP_MIRROR` was 10 Mbit.

- save 1 min/GB
- verify 2 min/GB
- upload  15 min/GB

Bear in mind that due to the incremental backup, only modified files will be
uploaded.
