#
# Cookbook Name:: rails
# Recipe:: default
#
# Copyright 2012, Michiel Sikkes
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "sudo"
include_recipe "nginx"
include_recipe "bluepill"
include_recipe "rails::dependencies"

user "deploy" do
  comment "Deploy User"
  home "/home/deploy"
  shell "/bin/bash"

  supports(:manage_home => true )
end

group "deploy" do
  members ['deploy']
end

sudo "deploy" do
  user "deploy"
  commands ["/usr/local/bin/bluepill"]
  nopasswd true
end

node[:active_applications].each do |app, app_info|
  directory "/u/apps/#{app}" do
    recursive true
    group "deploy"
    owner "deploy"
  end

  ['config', 'shared', 'shared/config', 'shared/sockets', 'shared/pids', 'shared/log', 'releases'].each do |dir| 
    directory "/u/apps/#{app}/#{dir}" do
      recursive true
      group "deploy"
      owner "deploy"
    end
  end

  template "/etc/nginx/sites-available/#{app}.conf" do
    source "app_nginx.conf.erb"
    variables :name => app, :domain_names => app_info['domain_names']
    notifies :reload, resources(:service => "nginx")
  end

  template "/u/apps/#{app}/config/unicorn.rb" do
    mode 0644
    source "app_unicorn.rb.erb"
    variables :name => app, :number_of_workers => app_info['number_of_workers'] || 2
  end

  template "#{node[:bluepill][:conf_dir]}/#{app}.pill" do
    mode 0644
    source "bluepill_unicorn.rb.erb"
    variables :name => app
  end

  bluepill_service app do
    action [:enable, :load, :start]
  end

  nginx_site "#{app}.conf" do
    action :enable
  end

  logrotate_app "rails-#{app}" do
    cookbook "logrotate"
    path ["/u/apps/#{app}/current/log/*.log"]
    frequency "daily"
    rotate 14
    compress true
    create "644 deploy deploy"
  end

end