CHANGELOG
=========

master
------
- Support Windows (thanks @igantt-daptiv)
- Specs + Travis support
- Throw fatal error if hostsfile does not exist (@jkerzner)
- Write priorities in hostsfile so they are read on subsequent Chef runs

v0.2.0
------
- Updated README to require Ruby 1.9
- Allow hypens in hostnames
- Ensure newline at end of file
- Allow priority ordering in hostsfile

v0.1.1
------
- Fixed issue #1
- Better unique object filtering
- Better handing of aliases

v0.1.0
------
- Initial release
