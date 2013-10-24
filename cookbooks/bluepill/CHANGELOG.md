bluepill Cookbook CHANGELOG
===========================
This file is used to list changes made in each version of the bluepill cookbook.


v2.3.0
------
### Improvement
- **[COOK-3503](https://tickets.opscode.com/browse/COOK-3503)** - Add why-run support

v2.2.2
------
- [COOK-2507] - stringify language attributes

v2.2.0
------
- [COOK-547] - Add `load` action to provider to reload services when template changes.

v2.1.0
------
- [COOK-1295] - The bluepill cookbook does not create the default log file
- [COOK-1840] - Enable bluepill to log to rsyslog

v2.0.0
------
This version uses platform_family attribute (in the provider), making the cookbook incompatible with older versions of Chef/Ohai, hence the major version bump.

- [COOK-1644] - Bluepill cookbook fails on Redhat due to missing default or redhat template directory.
- [COOK-1920] - init script should have a template file named after platform_family instead of using file specificity

v1.1.2
------
- [COOK-1730] - Add ability to specify which version of bluepill to install

v1.1.0
------
- [COOK-1592] - use mixlib-shellout instead of execute, add test-kitchen

v1.0.6
------
- [COOK-1304] - support amazon linux
- [COOK-1427] - resolve foodcritic warnings

v1.0.4
------
- [COOK-1106] - fix chkconfig loader for CentOS 5
- [COOK-1107] - use integer for GID instead of string

v1.0.2
------
- [COOK-1043] - Bluepill cookbook fails on OS X because it tries to use root group

v1.0.0
------
- [COOK-943] - add init script for freebsd

v0.3.0
------
- [COOK-867] - enable bluepill service on RHEL family
- [COOK-550] - add freebsd support

v0.2.2
------
- Fixes COOK-524, COOK-632
