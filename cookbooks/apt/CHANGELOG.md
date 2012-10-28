## v1.4.8:

* Adds test-kitchen support
* [COOK-1435] - repository lwrp is not idempotent with http key

## v1.4.6:

* [COOK-1530] - apt_repository isn't aware of update-success-stamp
  file (also reverts COOK-1382 patch).

## v1.4.4:

* [COOK-1229] - Allow cacher IP to be set manually in non-Chef Solo
  environments
* [COOK-1530] - Immediately update apt-cache when sources.list file is dropped off

## v1.4.2:

* [COOK-1155] - LWRP for apt pinning

## v1.4.0:

* [COOK-889] - overwrite existing repo source files
* [COOK-921] - optionally use cookbook\_file or remote\_file for key
* [COOK-1032] - fixes problem with apt repository key installation
