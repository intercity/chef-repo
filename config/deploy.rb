require 'json'

default_run_options[:pty] = true
set :user, "locomotive" 

task :app1 do
  role :server, "beta.apphakker.nl"
end

server "beta.apphakker.nl", :chef, :attributes => {
  "active_applications" => {
    "apphakker" => {
      "domain_names" => ["beta.apphakker.nl"],
      "database_info" => {
        "adapter" => "mysql2",
        "host" => "localhost",
        "username" => "apphakker",
        "password" => "apphakker_password"
      },
      "packages" => ["nodejs", "libpq-dev"]
    }
  },
  "authorization" => {
    "sudo" => {
      "include_sudoers_d" => true,
      "users" => ["locomotive"],
      "passwordless" => true
    }
  },
  "mysql" => {
    "server_debian_password" => "test",
    "server_root_password" => "test",
    "server_repl_password" => "test"
  },
  "ssh_deploy_keys" => [
    "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAzhkBf6REh0MTLJko7y8mxmqF+9Cn1CIUblYas+hOgawwwzUAG4zbikKEZrNd+79oyh1qBNZcwMljN0EKHwKgwGpEhxg7EGpRLtqD8ePGl5dOql1hIjP9Q+gw+eBjbpM1uBeWE5QaV0DEMQCVAOEn2Tr18mqNY/MGY9hSFUARGrXcBHERsbCNmEpnopUBpQO9OcgJDcMuO6kPWvCM5QfcU+88aaZq4ECOvw6NZKVP5Ovv+wNTP6SFAcCf0SZEU0ossCBtoI8V5lh+DK9ivxmvRHXbxZBYMY34HSqYZSrw60qzBBu4+Zi71Hq2N0/GwTLRcayxseWjLstnc6Gs7DahpQ== michiel@Michiel-Sikkess-MacBook-Pro.local"
  ],
  "run_list" => ["role[rails]", "role[mysql]"]
}

namespace :chef do

  task :bootstrap do
    run "#{sudo} aptitude update"
    run "#{sudo} aptitude install -y ruby1.9.3 build-essential wget"
    run "#{sudo} gem update --no-rdoc --no-ri"
    run "#{sudo} gem install ohai --no-rdoc --no-ri --verbose"
    run "#{sudo} gem install chef --no-rdoc --no-ri --verbose"
    run "#{sudo} mkdir -p /etc/chef"
    run "#{sudo} mkdir -p /var/chef-solo"
    run "#{sudo} mkdir -p /var/chef-solo/roles"

    chef_config = <<-EOF
file_cache_path "/var/chef-solo"
cookbook_path "/var/chef-solo/cookbooks"
role_path "/var/chef-solo/roles"
    EOF

    put chef_config, "solo.rb"

    run "#{sudo} cp solo.rb /etc/chef-solo/solo.rb"
  end

  task :update do
    system "tar czvf recipes.tgz ./cookbooks"
    upload "recipes.tgz", "recipes.tar.gz"
    run "#{sudo} rm -rf /var/chef-solo/cookbooks"
    run "cd /var/chef-solo && #{sudo} tar zxvf ~/recipes.tar.gz"

    Dir["roles/*.rb"].each do |role|
      role_basename = File.basename(role)
      upload role, role_basename
      run "#{sudo} mv #{role_basename} /var/chef-solo/roles"
    end
  end

  task :apply do
    servers = find_servers_for_task(current_task)
    servers.each do |cool_server|
      put(cool_server.options[:attributes].to_json, "/home/#{user}/node.json")
    end

    run "#{sudo} chef-solo -j ~/node.json -c ~/solo.rb"
    run "rm -f ~/node.json"
  end

  task :whyrun do
    servers = find_servers_for_task(current_task)
    servers.each do |cool_server|
      put(cool_server.options[:attributes].to_json, "/home/#{user}/node.json")
    end

    run "#{sudo} chef-solo -W -j ~/node.json -c ~/solo.rb"
    run "rm -f ~/node.json"
  end

end