name        "postgresql"
description "PostgreSQL Server Support"

run_list    "role[base]", "recipe[postgresql::server]", "recipe[postgresql::client]"
