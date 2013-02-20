require 'json'
default_run_options[:pty] = true

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
  end

  task :update do
    system "tar czvf recipes.tgz ./cookbooks"
    upload "recipes.tgz", "recipes.tar.gz"
    run "#{sudo} rm -rf /var/chef/cookbooks"
    run "#{sudo} mkdir -p /var/chef/roles"
    run "cd /var/chef && #{sudo} tar zxvf ~/recipes.tar.gz"

    chef_config = <<-EOF
file_cache_path "/var/chef"
cookbook_path "/var/chef/cookbooks"
role_path "/var/chef/roles"
    EOF

    put chef_config, "solo.rb"
    run "#{sudo} mv solo.rb /etc/chef/solo.rb"

    Dir["roles/*.rb"].each do |role|
      role_basename = File.basename(role)
      upload role, role_basename
      run "#{sudo} mv #{role_basename} /var/chef/roles"
    end
  end

  task :apply do
    servers = find_servers_for_task(current_task)
    servers.each do |cool_server|
      put(server_attributes[cool_server.to_s].to_json, "/home/#{user}/node.json", :host => cool_server)
    end

    run "#{sudo} chef-solo -j ~/node.json"
    run "rm -f ~/node.json"
  end

  task :whyrun do
    servers = find_servers_for_task(current_task)
    servers.each do |cool_server|
      put(server_attributes[cool_server.to_s].to_json, "/home/#{user}/node.json", :host => cool_server)
    end

    run "#{sudo} chef-solo -W -j ~/node.json -c ~/solo.rb"
    run "rm -f ~/node.json"
  end

end