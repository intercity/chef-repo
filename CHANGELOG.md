# Changelog
All notable changes to this project will be documented in this file.
This project makes use of the [Sementic Versioning](http://semver.org/)

## Master - TBA

### Added
- .ruby-version file is placed in app_folder/shared so you can symlink it to your app

### Deprecated
- Nothing

### Removed
- Nothing

### Fixed
- Fixed 'uninitialized constant ActiveRecord' in Unicorn configuration when a the app does not have ActiveRecord.

### Misc
- Nothing

## 2.2.0 - 2014-10-28

### Added
- Backup support (Support for filesystem, mysql and postgresql, backup to S3)
- Backup compression using GZip
- Added ruby 2.1.3 to the ruby binary list
- test-kitchen to automatically test the cookbooks and resulting server setup
- Sysadmins recipe which allows you to provide sysadmin users in the node configuration.

### Deprecated
- Nothing

### Removed
- Removed the sudos cookbook because it is not needed for the Unicorn stack anymore

### Fixed
- Removed spaces from the .rbenv-vars template file

### Misc
- Upgraded the chef-repo ruby version to 2.1.2
- Sudo recipe configuration changed to match Ubuntu's default sudo
  behaviour more closely.

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
