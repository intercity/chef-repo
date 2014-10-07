# Changelog
All notable changes to this project will be documented in this file.
This project makes use of the [Sementic Versioning](http://semver.org/)

## 2.2.0 - TBA

### Added
- Backup support (Support for filesystem, mysql and postgresql, backup to S3)
- Backup compression using GZip

### Deprecated
- Nothing

### Removed
- Nothing

### Fixed
- Removed spaces from the .rbenv-vars template file

### Misc
- Upgraded the chef-repo ruby version to 2.1.2

## 2.1.0 - 2014-08-18

See [UPGRADING.md](UPGRADING.md) for upgrade instructions if you're using the Unicorn stack.

### Added
- Started working with a [Changelog](http://keepachangelog.com/)
- Configure ENV vars for your apps [Rbenv-vars](https://github.com/sstephenson/rbenv-vars)
- Speed up Ruby installation with binary packages
- [Unicorn Stack] Use Upstart to start Unicorn
- Wrote UPGRADING.md with upgrade instructions to 2.1.0

### Deprecated
- Nothing.

### Removed
- [Unicorn Stack] Don't use Bluepill monitoring for Unicorn anymore.

### Fixed
- Nothing.

## 2.0.0 - 2014-04-28

### Added
- Use Phusion Passenger as default Rails stack.
- Use Postgresql as your database
- Use Cheffile with Librarian-Chef to manage cookbooks

### Deprecated
- Nothing.

### Removed
- Nothing.

### Fixed
- Nothing.

## 1.1.0 - 2013-08-19

### Added
- You can now specify what user you want to use for deployments

### Deprecated
- Nothing.

### Removed
- Nothing.

### Fixed
- Nothing.

## 1.0.0 - 2013-07-19

### Added
- This is the initial release of the chef-repo

### Deprecated
- Nothing.

### Removed
- Nothing.

### Fixed
- Nothing.
