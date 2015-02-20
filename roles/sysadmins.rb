name "sysadmins"
description "This role configures sysadmins, users with sudo-rights on your server"
run_list(
  "role[base]",
  "recipe[packages]",
  "recipe[sysadmins]",
  "recipe[sudo]"
)
# Configure the sudo recipe so it mirrors Ubuntu's default behaviour
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
