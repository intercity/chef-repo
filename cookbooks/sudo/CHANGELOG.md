sudo Cookbook CHANGELOG
=======================
This file is used to list changes made in each version of the sudo cookbook.


v2.2.2
------
### Improvement
- **[COOK-3653](https://tickets.opscode.com/browse/COOK-3653)** - Change template attribute to kind_of String
- **[COOK-3572](https://tickets.opscode.com/browse/COOK-3572)** - Add Test Kitchen, Specs, and Travis CI

### Bug
- **[COOK-3610](https://tickets.opscode.com/browse/COOK-3610)** - Document "Runas" attribute not described in the LWRP Attributes section
- **[COOK-3431](https://tickets.opscode.com/browse/COOK-3431)** - Validate correctly with `visudo`


v2.2.0
------
### New Feature
- **[COOK-3056](https://tickets.opscode.com/browse/COOK-3056)** - Allow custom sudoers config prefix

v2.1.4
------
This is a bugfix for 11.6.0 compatibility, as we're not monkey-patching Erubis::Context.

### Bug
- [COOK-3399]: Remove node attribute in comment of sudoers templates

v2.1.2
------
### Bug
- [COOK-2388]: Chef::ShellOut is deprecated, please use Mixlib::ShellOut
- [COOK-2814]: Incorrect syntax in README example

v2.1.0
------
* [COOK-2388] - Chef::ShellOut is deprecated, please use Mixlib::ShellOut
* [COOK-2427] - unable to install users cookbook in chef 11
* [COOK-2814] - Incorrect syntax in README example

v2.0.4
------
* [COOK-2078] - syntax highlighting README on GitHub flavored markdown
* [COOK-2119] - LWRP template doesn't support multiple commands in a single block.

v2.0.2
------
* [COOK-2109] - lwrp uses incorrect action on underlying file resource.

v2.0.0
------
This is a major release because the LWRP's "nopasswd" attribute is changed from true to false, to match the passwordless attribute in the attributes file. This requires a change to people's LWRP use.

* [COOK-2085] - Incorrect default value in the sudo LWRP's nopasswd attribute

v1.3.0
------
* [COOK-1892] - Revamp sudo cookbook and LWRP
* [COOK-2022] - add an attribute for setting /etc/sudoers Defaults

v1.2.2
------
* [COOK-1628] - set host in sudo lwrp

v1.2.0
------
* [COOK-1314] - default package action is now :install instead of :upgrade
* [COOK-1549] - Preserve SSH agent credentials upon sudo using an attribute

v1.1.0
------
* [COOK-350] - LWRP to manage sudo files via includedir (/etc/sudoers.d)

v1.0.2
------
* [COOK-903] - freebsd support
