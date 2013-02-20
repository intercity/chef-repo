name              "logrotate"
maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs logrotate package and provides a definition for logrotate configs"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.1.0"

recipe "logrotate", "Installs logrotate package"
provides "logrotate_app"

%w{ redhat centos debian ubuntu scientific amazon fedora }.each do |os|
  supports os
end
