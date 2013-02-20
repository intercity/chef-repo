Description
===========

Installs and configures rsyslog to replace sysklogd for client and/or
server use. By default, the service will be configured to log to
files on local disk. See the __Recipes__ and __Examples__ sections 
for other uses.

**Major Changes in 1.2.0**: See CHANGELOG.md

**Important Changes in 1.1.0**: See the CHANGELOG.md file for
  important changes to this cookbook. There are some incompatibilities
  with existing installations. Use version 1.0.0 if you're not ready
  for these changes.

Requirements
============

Platform
--------

Tested on Ubuntu 9.10, 10.04 and Red Hat 6.3

Ubuntu 8.04, 8.10, and 9.04 are no longer supported releases and have not been tested with this cookbook.

Other
-----

To use the `recipe[rsyslog::client]` recipe, you'll need to set up the `rsyslog.server_search` or `rsyslog.server_ip` attributes.  See the __Recipes__ and __Examples__ sections below.

Attributes
==========

See `attributes/default.rb` for default values.

* `node['rsyslog']['log_dir']` - If the node is an rsyslog server,
  this specifies the directory where the logs should be stored.
* `node['rsyslog']['server']` - Determined automaticaly and set to true on
  the server.
* `node['rsyslog']['server_ip']` - If not defined then search will be used
  to determine rsyslog server. Default is `nil`.
* `node['rsyslog']['server_search']` - Specify the criteria for the server
  search operation. Default is `role:loghost`.
* `node['rsyslog']['protocol']` - Specify whether to use `udp` or
  `tcp` for remote loghost. Default is `tcp`.
* `node['rsyslog']['port']` - Specify the port which rsyslog should
  connect to a remote loghost.
* `node['rsyslog']['remote_logs']` - Specify wether to send all logs
  to a remote server (client option). Default is `true`.
* `node['rsyslog']['per_host_dir']` - "PerHost" directories for
  template statements in `35-server-per-host.conf`. Default value is
  the previous cookbook version's value, to preserve compatibility.
  See __server__ recipe below.
* `node['rsyslog']['user']` - Specify the user to run and write files as.
* `node['rsyslog']['group']` - Specify the group to run and write files as.
* `node['rsyslog']['priv_seperation']` - Whether to use privilege seperation or
   not.
* `node['rsyslog']['max_message_size']` - Specify the maximum allowed
  message size. Default is 2k.
* `node['rsyslog']['preserve_fqdn']` - Specify if the full host name
  will be used. Default is off.
* `node['rsyslog']['user']` - Who should own the configuration files and directories
* `node['rsyslog']['group']` - Who should group-own the configuration files
  and directories
* `node['rsyslog']['defaults_file']` - The full path to the defaults/sysconfig file
  for the service.
* `node['rsyslog']['service_name']` - The platform-specific name of the service
* `node['rsyslog']['preserve_fqdn']` - Value of the `$PreserveFQDN`
  configuration directive in `/etc/rsyslog.conf`. Default is 'off' for
  compatibility purposes.

Recipes
=======

default
-------

Installs the rsyslog package, manages the rsyslog service and sets up basic
configuration for a standalone machine.

client
------

Includes `recipe[rsyslog]`.

Uses `node['rsyslog']['server_ip']` or Chef search (in that precedence order)
to determine the remote syslog server's IP address. If search is used, the
search query will look for the first `ipaddress` returned from the criteria
specified in `node['rsyslog']['server_search']`.

If the node itself is a rsyslog server ie it has `rsyslog.server` set to true
then the configuration is skipped.

If the node had an `/etc/rsyslog.d/35-server-per-host.conf` file previously configured,
this file gets removed to prevent duplicate logging.

Any previous logs are not cleaned up from the `log_dir`.

server
------

Configures the node to be a rsyslog server. The chosen rsyslog server
node should be defined in the `server_ip` attribute or resolvable by
the specified search criteria specified in `node['rsyslog']['server_search]`
(so that nodes making use of the `client` recipe can find the server to log to).

This recipe will create the logs in `node['rsyslog']['log_dir']`, and
the configuration is in `/etc/rsyslog.d/server.conf`. This recipe also
removes any previous configuration to a remote server by removing the
`/etc/rsyslog.d/remote.conf` file.

The cron job used in the previous version of this cookbook is removed,
but it does not remove any existing cron job from your system (so it
doesn't break anything unexpectedly). We recommend setting up
logrotate for the logfiles instead.

The `log_dir` will be concatenated with `per_host_dir` to store the
logs for each client. Modify the attribute to have a value that is
allowed by rsyslogs template matching values, see the rsyslog
documentation for this.

Directory structure:

    <%= @log_dir %>/<%= @per_host_dir %>/"logfile"

For example for the system with hostname `www`:

    /srv/rsyslog/2011/11/19/www/messages

For example, to change this to just the hostname, set the attribute
`node['rsyslog']['per_host_dir']` via a role:

    "rsyslog" => { "per_host_dir" => "%HOSTNAME%" }

At this time, the server can only listen on UDP *or* TCP.

Usage
=====

Use `recipe[rsyslog]` to install and start rsyslog as a basic
configured service for standalone systems.

Use `recipe[rsyslog::client]` to have nodes log to a remote server
(which is found via the `server_ip` attribute or by the recipe's
search call -- see __client__)

Use `recipe[rsyslog::server]` to set up a rsyslog server. It will listen on
`node['rsyslog']['port']` protocol `node['rsyslog']['protocol']`.

If you set up a different kind of centralized loghost (syslog-ng,
graylog2, logstash, etc), you can still send log messages to it as
long as the port and protocol match up with the server
software. See __Examples__


Examples
--------

A `base` role (e.g., roles/base.rb), applied to all nodes so they are syslog clients:

    name "base"
    description "Base role applied to all nodes
    run_list("recipe[rsyslog::client]")

Then, a role for the loghost (should only be one):

    name "loghost"
    description "Central syslog server"
    run_list("recipe[rsyslog::server]")

By default this will set up the clients search for a node with the
`loghost` role to talk to the server on TCP port 514. Change the
`protocol` and `port` rsyslog attributes to modify this.

If you want to specify another syslog compatible server with a role other
than loghost, simply fill free to use the `server_ip` attribute or
the `server_search` attribute.

Example role that sets the per host directory:

    name "loghost"
    description "Central syslog server"
    run_list("recipe[rsyslog::server]")
    default_attributes(
      "rsyslog" => { "per_host_dir" => "%HOSTNAME%" }
    )

License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)
Author:: Denis Barishev (<denz@twiket.com>)

Copyright:: 2009-2012, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
