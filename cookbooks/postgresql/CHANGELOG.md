## v1.0.0:

**Important note for this release**

This version no longer installs Ruby bindings in the client recipe by
default. Use the ruby recipe if you'd like the RubyGem. If you'd like
packages for your distribution, use them in your application's
specific cookbook/recipe, or modify the client packages attribute.

This resolves the following tickets.

* COOK-1011
* COOK-1534

The following issues are also resolved with this release.

* [COOK-1011] - Don't install postgresql packages during compile
  phase and remove pg gem installation
* [COOK-1224] - fix undefined variable on Debian
* [COOK-1462] - Add attribute for specifying listen address

## v0.99.4:

* [COOK-421] - config template is malformed
* [COOK-956] - add make package on ubuntu/debian

## v0.99.2:

* [COOK-916] - use < (with float) for version comparison.

## v0.99.0:

* Better support for Red Hat-family platforms
* Integration with database cookbook
* Make sure the postgres role is updated with a (secure) password
