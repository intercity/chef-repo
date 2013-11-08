name 'cakephp'
description 'This role configures a Cakephp stack with PHP-FPM'
run_list "recipe[apt]", "recipe[build-essential]", "recipe[mysql::server]", "recipe[packages]", "recipe[sudo]", "recipe[nginx]", "recipe[php]", "recipe[cakephp]", "recipe[cakephp::databases]", "recipe[git]", "recipe[ssh_deploy_keys]", "recipe[postfix]"