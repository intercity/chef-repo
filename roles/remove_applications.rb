name "remove_applications"
description "This role safely removes applications from your server"
run_list(
  "recipe[rails::remove_applications]"
)
