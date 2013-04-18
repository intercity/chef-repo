name 'postgresql'
description 'Postgresql server for apps'
run_list "recipe[postgresql::client]","recipe[postgresql::server]"