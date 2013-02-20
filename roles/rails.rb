name 'rails'
description 'This role configures a Rails stack using Unicorn'
run_list "recipe[apt]", "recipe[build-essential]", "recipe[percona_mysql]", "recipe[packages]", "recipe[sudo]", "recipe[ruby_build]", "recipe[rbenv::system]", "recipe[bundler]", "recipe[bluepill]", "recipe[nginx]", "recipe[haproxy]", "recipe[rails]", "recipe[backup]", "recipe[rails::databases]", "recipe[git]", "recipe[ssh_deploy_keys]", "recipe[wkhtmltopdf]"
