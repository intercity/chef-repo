name 'rails'
description 'This role configures a Rails stack using Unicorn'
default_attributes(
  "bluepill" => {
    "bin" => "/usr/local/bin/bluepill"
  }
)
run_list "recipe[percona_mysql]", "recipe[apt]", "recipe[packages]", "recipe[sudo]", "recipe[bluepill]","recipe[nginx]", "recipe[rails]", "recipe[git]", "recipe[bundler]", "recipe[ssh_deploy_keys]"