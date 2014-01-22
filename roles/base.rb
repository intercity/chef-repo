name 'base'
description 'Base bootstrap for every box'
run_list "recipe[sudo]"
default_attributes(
  "authorization" => {
    "sudo" => {
      "passwordless" => true,
      "include_sudoers_d" => true,
      "sudoers_default" => [
        'env_reset',
        'secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"'
      ],
    }
  }
)