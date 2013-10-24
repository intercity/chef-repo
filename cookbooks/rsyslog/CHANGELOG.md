rsyslog Cookbook CHANGELOG
==========================
This file is used to list changes made in each version of the rsyslog cookbook.


v1.9.0
------
### New Feature
- **[COOK-3736](https://tickets.opscode.com/browse/COOK-3736)** - Support OmniOS

### Improvement
- **[COOK-3609](https://tickets.opscode.com/browse/COOK-3609)** - Add actionqueue to remote rsyslog configurations

### Bug
- **[COOK-3608](https://tickets.opscode.com/browse/COOK-3608)** - Add 50-default template knobs
- **[COOK-3600](https://tickets.opscode.com/browse/COOK-3600)** - SmartOS support


v1.8.0
------
### Improvement
- **[COOK-3573](https://tickets.opscode.com/browse/COOK-3573)** -  Add Test Kitchen, Specs, and Travis CI

### New Feature
- **[COOK-3435](https://tickets.opscode.com/browse/COOK-3435)** - Add support for relp

v1.7.0
------
### Improvement
- **[COOK-3253](https://tickets.opscode.com/browse/COOK-3253)** - Enable repeated message reduction
- **[COOK-3190](https://tickets.opscode.com/browse/COOK-3190)** - Allow specifying which logs to send to remote server
- **[COOK-2355](https://tickets.opscode.com/browse/COOK-2355)** - Support forwarding events to more than one server

v1.6.0
------
### New Feature
- [COOK-2831]: enable high precision timestamps

### Bug
- [COOK-2377]: calling node.save has adverse affects on nodes relying on a searched node's ohai attributes
- [COOK-2521]: rsyslog cookbook incorrectly sets directory ownership to rsyslog user
- [COOK-2540]: Syslogd needs to be disabled before starting rsyslogd on RHEL 5

### Improvement
- [COOK-2356]: rsyslog service supports status. Service should use it.
- [COOK-2357]: rsyslog cookbook copies in wrong defaults file on Ubuntu !9.10/10.04

v1.5.0
------
- [COOK-2141] - Add `$PreserveFQDN` configuration directive

v1.4.0
------
- [COOK-1877] - RHEL 6 support and refactoring

v1.3.0
------
- [COOK-1189] - template change does not restart rsyslog on Ubuntu

This actually went into 1.2.0 with action `:reload`, but that change has been reverted and the action is back to `:restart`.

v1.2.0
------
- [COOK-1678] - syslog user does not exist on debian 6.0 and ubuntu versions lower than 11.04
- [COOK-1650] - enable max message size configuration via attribute

v1.1.0
------
Changes from COOK-1167:

- More versatile server discovery - use the IP as an attribute, or use search (see README)
- Removed cron dependency.
- Removed log archival; logrotate is recommended.
- Add an attribute to select the per-host directory in the log dir
- Works with Chef Solo now.
- Set debian/ubuntu default user and group. Drop privileges to `syslog.adm`.


v1.0.0
------
- [COOK-836] - use an attribute to specify the role to search for instead of relying on the rsyslog['server'] attribute.
- Clean up attribute usage to use strings instead of symbols.
- Update this README.
- Better handling for chef-solo.
