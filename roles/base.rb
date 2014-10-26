name 'base'
description 'Base bootstrap for every box'
run_list "recipe[apt]", "recipe[build-essential]"
