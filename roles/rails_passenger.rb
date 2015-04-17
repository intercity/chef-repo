name 'rails_passenger'
description 'This role configures a Rails stack using Passenger'
run_list(
  "role[base]",
  "recipe[packages]",
  "recipe[rails::passenger]",
  "recipe[ruby_build]",
  "recipe[rbenv]",
  "recipe[rails::databases]",
  "recipe[rails::env_vars]",
  "recipe[git]",
  "recipe[ssh_deploy_keys]",
  "recipe[postfix]",
  "recipe[apt::unattended-upgrades]"
)

default_attributes(
  "nginx" => { "server_tokens" => "off", "package_name" => "nginx-extras" },
  "rbenv" => {
    "group_users" => ['deploy']
  },
  "deploy_users" => [
        "deploy"
  ]
)
