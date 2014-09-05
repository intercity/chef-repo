name 'mysql'
description 'MySQL server for apps'
run_list "role[base]", "recipe[mysql::server]", "recipe[mysql::client]"
default_attributes("mysql" => { "bind_address" => "0.0.0.0" })