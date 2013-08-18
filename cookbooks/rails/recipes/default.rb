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

template "/home/deploy/.bashrc" do
  source "bashrc.erb"
  owner "deploy"
  group "deploy"
end

group "deploy" do
  members ['deploy']
end

sudo "deploy" do
  user "deploy"
  commands ["#{node[:bluepill][:bin]}"]
  nopasswd true
end

if node[:deploy_users]
  node[:deploy_users].each do |deploy_user|
    user deploy_user do
      comment "Deploy User #{deploy_user}"
      home "/home/#{deploy_user}"
      shell "/bin/bash"

      supports(:manage_home => true )
    end

    template "/home/#{deploy_user}/.bashrc" do
      source "bashrc.erb"
      owner "#{deploy_user}"
      group "#{deploy_user}"
    end

    group deploy_user do
      members [deploy_user]
    end

    sudo deploy_user do
      user deploy_user
      commands ["#{node[:bluepill][:bin]}"]
      nopasswd true
    end
  end
end

if node[:active_applications]

  node[:active_applications].each do |app, app_info|
    rails_env = app_info['rails_env'] || "production"
    deploy_user = app_info['deploy_user'] || "deploy"

    directory "/u/apps/#{app}" do
      recursive true
      group deploy_user
      owner deploy_user
    end

    ['config', 'shared', 'shared/config', 'shared/sockets', 'shared/pids', 'shared/log', 'shared/system', 'releases'].each do |dir|
      directory "/u/apps/#{app}/#{dir}" do
        recursive true
        group deploy_user
        owner deploy_user
      end
    end

    if app_info['database_info']

      template "/u/apps/#{app}/shared/config/database.yml" do
        owner deploy_user
        group deploy_user
        mode 0600
        source "app_database.yml.erb"
        variables :database_info => app_info['database_info'], :rails_env => rails_env
      end

    end

    if app_info['packages'] && app_info['packages'].include?('sphinxsearch')
      directory "/u/apps/#{app}/shared/sphinx" do
        recursive true
        group deploy_user
        owner deploy_user
      end
    end

    template "/etc/nginx/sites-available/#{app}.conf" do
      source "app_nginx.conf.erb"
      variables :name => app, :domain_names => app_info['domain_names'], :enable_ssl => File.exists?("/u/apps/#{app}/shared/config/certificate.crt")
      notifies :reload, resources(:service => "nginx")
    end

    template "/u/apps/#{app}/shared/config/unicorn.rb" do
      mode 0644
      source "app_unicorn.rb.erb"
      variables :name => app, :deploy_user => deploy_user, :number_of_workers => app_info['number_of_workers'] || 2
    end

    template "#{node[:bluepill][:conf_dir]}/#{app}.pill" do
      mode 0644
      source "bluepill_unicorn.rb.erb"
      variables :name => app, :deploy_user => deploy_user, :app_env => app_info['app_env'], :rails_env => rails_env
    end

    bluepill_service app do
      action [:enable, :load, :start]
    end

    template "/etc/init/#{app}.conf" do
      mode 0644
      source "bluepill_upstart.erb"
      variables :name => app
    end

    service "#{app}" do
      provider Chef::Provider::Service::Upstart
      action [ :enable ]
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
      create "644 #{deploy_user} #{deploy_user}"
    end

  end

end