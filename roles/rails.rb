name 'rails'
description 'This role configures a Rails stack using Unicorn'
default_attributes(:bluepill => {:bin => "/usr/local/bin/bluepill"})
run_list "recipe[apt]", "recipe[build-essential]", "recipe[percona_mysql]", "recipe[packages]", "recipe[sudo]", "recipe[bundler]", "recipe[bluepill]", "recipe[nginx]", "recipe[haproxy]", "recipe[backup]", "recipe[rails]", "recipe[git]", "recipe[ssh_deploy_keys]"