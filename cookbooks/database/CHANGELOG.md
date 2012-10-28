## v1.3.4:

* [COOK-1561] - depend on mysql 1.3.0+ explicitly
* depend on postgresql 1.0.0 explicitly

## v1.3.2:

* Update the version for release (oops)

## v1.3.0:

* [COOK-932] - Add mysql recipe to conveniently include mysql::ruby
* [COOK-1228] - database resource should be able to execute scripts on disk
* [COOK-1291] - make the snapshot retention policy less confusing
* [COOK-1401] - Allow to specify the collation of new databases
* [COOK-1534] - Add postgresql recipe to conveniently include postgresql::ruby

## v1.2.0:

* [COOK-970] - workaround for disk [re]naming on ubuntu 11.04+
* [COOK-1085] - check RUBY_VERSION and act accordingly for role
* [COOK-749] - localhost should be a string in snapshot recipe

## v1.1.4:

* [COOK-1062] - Databases: Postgres exists should close connection

## v1.1.2:

* [COOK-975] - Change arg='DEFAULT' to arg=nil, :default => 'DEFAULT'
* [COOK-964] - Add parentheses around connection hash in example

## v1.1.0

* [COOK-716] - providers for PostgreSQL

## v1.0.0

* [COOK-683] - added `database` and `database_user` resources
* [COOK-684] - MySQL providers
* [COOK-685] - SQL Server providers
* refactored - `database::master` and `database::snapshot` recipes to leverage new resources

## v0.99.1

* Use Chef 0.10's `node.chef_environment` instead of `node['app_environment']`.
