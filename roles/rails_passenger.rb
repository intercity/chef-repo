name 'rails_passenger'
description 'This role configures a Rails stack using Passenger'
run_list "role[base]", "recipe[apt]", "recipe[build-essential]", "recipe[packages]", "recipe[mysql::server]", "recipe[rails::passenger]", "recipe[ruby_build]", "recipe[rbenv]", "recipe[rails::databases]", "recipe[git]", "recipe[ssh_deploy_keys]", "recipe[postfix]"
default_attributes(
  "nginx" => { "server_tokens" => "off" },
  "rbenv" => {
    "group_users" => ['deploy']
  },
  "deploy_users" => [
        "deploy"
  ]
)
