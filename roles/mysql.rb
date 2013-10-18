name 'mysql'
description 'MySQL server for apps'
run_list "recipe[build-essential]", "recipe[mysql::server]", "recipe[mysql::client]"