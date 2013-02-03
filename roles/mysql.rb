name 'mysql'
description 'MySQL server for apps'
run_list "recipe[percona_mysql]", "recipe[mysql::server]", "recipe[mysql::client]"