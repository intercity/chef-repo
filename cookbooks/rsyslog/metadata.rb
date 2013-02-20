name              "rsyslog"
maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures rsyslog"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.5.0"

recipe            "rsyslog", "Installs rsyslog"
recipe            "rsyslog::client", "Sets up a client to log to a remote rsyslog server"
recipe            "rsyslog::server", "Sets up an rsyslog server"

supports          "ubuntu", ">= 10.04"
supports          "debian", ">= 5.0"
supports          "redhat", ">= 6.0"

attribute "rsyslog",
  :display_name => "Rsyslog",
  :description => "Hash of Rsyslog attributes",
  :type => "hash"

attribute "rsyslog/log_dir",
  :display_name => "Rsyslog Log Directory",
  :description => "Filesystem location of logs from clients",
  :default => "/srv/rsyslog"

attribute "rsyslog/server",
  :display_name => "Rsyslog Server?",
  :description => "Is this node an rsyslog server?",
  :default => "false"

attribute "rsyslog/server_ip",
  :display_name => "Rsyslog Server IP Address",
  :description => "Set rsyslog server ip address explicitly"

attribute "rsyslog/server_search",
  :display_name => "Rsyslog Server Search Criteria",
  :description => "Set the search criteria for rsyslog server resolving",
  :default => "role:loghost"

attribute "rsyslog/protocol",
  :display_name => "Rsyslog Protocol",
  :description => "Set which network protocol to use for rsyslog",
  :default => "tcp"

attribute "rsyslog/port",
  :display_name => "Rsyslog Port",
  :description => "Port that Rsyslog listens for incoming connections",
  :default => "514"

attribute "rsyslog/remote_logs",
  :display_name => "Remote Logs",
  :description => "Specifies whether redirect all log from client to server",
  :default => "true"

attribute "rsyslog/user",
  :display_name => "User",
  :description => "The owner of Rsyslog config files and directories",
  :default => "root"

attribute "rsyslog/group",
  :display_name => "Group",
  :description => "The group-owner of Rsyslog config files and directories",
  :default => "adm"

attribute "rsyslog/service_name",
  :display_name => "Service name",
  :description => "The name of the service for the platform",
  :default => "rsyslog"

attribute "rsyslog/defaults_file",
  :display_name => "Defaults file",
  :description => "The full path to the service's defaults/sysconfig file",
  :default => "/etc/default/rsyslog"

attribute "rsyslog/max_message_size",
  :display_name => "Maximum Rsyslog message size",
  :description => "Specifies the maximum size of allowable Rsyslog messages",
  :default => "2k"

attribute "rsyslog/preserve_fqdn",
  :display_name => "Preserve FQDN",
  :description => "Specifies if the short or full host name will be used. The default off setting is more compatible.",
  :default => "off"

attribute "rsyslog/priv_seperation",
  :display_name => "Privilege separation",
  :description => "Whether or not to make use of Rsyslog privilege separation",
  :default => "false"
