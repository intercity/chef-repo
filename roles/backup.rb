name "backup"
description "This role configures the backups on your server"
run_list(
  "role[base]",
  "recipe[packages]",
  "recipe[backups]"
)
