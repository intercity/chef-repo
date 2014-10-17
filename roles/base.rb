name 'base'
description 'Base bootstrap for every box'
run_list "recipe[sysadmins]", "recipe[sudo]", "recipe[apt]", "recipe[build-essential]"
default_attributes(
  "authorization" => {
    "sudo" => {
      "groups" => ["admin"],
      "passwordless" => false,
      "include_sudoers_d" => true,
      "sudoers_default" => [
        "env_reset",
        "mail_badpass",
        "secure_path=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\""
      ],
    }
  }
)
