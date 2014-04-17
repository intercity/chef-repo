name 'postgres'
description 'PostgreSQL Server Support'

run_list 'recipe[build-essential]',
         'recipe[postgresql::client]',
         'recipe[postgresql::server_debian]'
