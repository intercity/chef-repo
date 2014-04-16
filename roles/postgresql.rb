name 'postgresql'
description 'PostgreSQL Server Support'

run_list 'recipe[build-essential]',
         'recipe[postgresql::server_debian]'
