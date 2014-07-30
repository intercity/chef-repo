name 'rails'
description 'This role configures a Rails stack using Unicorn'
run_list "role[base]", "recipe[packages]", "recipe[bluepill]", "recipe[nginx]", "recipe[rails]", "recipe[ruby_build]", "recipe[rbenv]", "recipe[rails::databases]", "recipe[git]", "recipe[ssh_deploy_keys]", "recipe[postfix]"
default_attributes(
  "nginx" => { "server_tokens" => "off" },
  "bluepill" => { "bin" => "/usr/local/bin/bluepill" },
  "rbenv" => {
    "group_users" => ['deploy']
  },
  "deploy_users" => [
        "deploy"
  ]
)
