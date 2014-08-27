name        "sidekiq"
description "Sidekiq Server Support"

run_list    "recipe[redisio]", "recipe[redisio::enable]", "recipe[sidekiq]"
