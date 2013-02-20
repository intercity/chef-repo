Description
===========

Manages the logrotate package and provides a definition to manage
application specific logrotate configuration.

Requirements
============

Should work on any platform that includes a 'logrotate' package and
writes logrotate configuration to /etc/logrotate.d. Tested on Ubuntu,
Debian and Red Hat/CentOS.

Definitions
===========

## logrotate\_app

This definition can be used to drop off customized logrotate config
files on a per application basis.

The definition takes the following params:

* path: specifies a single path (string) or multiple paths (array)
  that should have logrotation stanzas created in the config file. No
  default, this must be specified.
* enable: true/false, if true it will create the template in
  /etc/logrotate.d.
* frequency: sets the frequency for rotation. Default value is
  'weekly'. Valid values are: daily, weekly, monthly, yearly, see the
  logrotate man page for more information.
* size: Log files are rotated when they grow bigger than size bytes.
* template: sets the template source, default is "logrotate.erb".
* cookbook: select the template source from the specified cookbook. By
  default it will use the cookbook where the definition is used.
* create: creation parameters for the logrotate "create" config,
  follows the form "mode owner group". This is an optional parameter,
  and is nil by default.
* postrotate: lines to be executed after the log file is rotated
* prerotate: lines to be executed after the log file is rotated
* sharedscripts: if true, the sharedscripts options is specified which
  makes sure prescript and postscript commands are run only once (even
  if multiple files match the path)

See USAGE below.

USAGE
====

The default recipe will ensure logrotate is always up to date.

To create application specific logrotate configs, use the
`logrotate_app` definition. For example, to rotate logs for a tomcat
application named myapp that writes its log file to
/var/log/tomcat/myapp.log:

    logrotate_app "tomcat-myapp" do
      cookbook "logrotate"
      path "/var/log/tomcat/myapp.log"
      frequency "daily"
      rotate 30
      create "644 root adm"
    end

To rotate multiple logfile paths, specify the path as an array:

    logrotate_app "tomcat-myapp" do
      cookbook "logrotate"
      path [ "/var/log/tomcat/myapp.log", "/opt/local/tomcat/catalina.out" ]
      frequency "daily"
      create "644 root adm"
      rotate 7
    end

To specify which logrotate options, specify the options as an array:

    logrotate_app "tomcat-myapp" do
      cookbook "logrotate"
      path "/var/log/tomcat/myapp.log"
      options ["missingok", "delaycompress", "notifempty"]
      frequency "daily"
      rotate 30
      create "644 root adm"
    end

License and Author
==================

- Author:: Scott M. Likens (<scott@likens.us>)
- Author:: Joshua Timberman (<joshua@opscode.com>)
- Copyright:: 2009, Scott M. Likens
- Copyright:: 2011-2012, Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
