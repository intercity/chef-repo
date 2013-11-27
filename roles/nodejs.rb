name 'nodejs'
description 'installing nodeJS'
run_list "recipe[build-essential]","recipe[apt]", "nodejs::install_from_binary"