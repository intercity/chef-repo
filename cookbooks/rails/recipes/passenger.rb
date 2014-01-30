#
# Cookbook Name:: rails::passenger
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

package "apt-transport-https"

apt_repository "passenger" do
  uri "https://oss-binaries.phusionpassenger.com/apt/passenger"
  distribution "precise"
  components ["main"]
  key "561F9B9CAC40B2F7"
  keyserver "keyserver.ubuntu.com"
end

include_recipe "nginx"

template "/etc/nginx/conf.d/passenger.conf" do
  source "passenger.conf.erb"
  owner 'root'
  group 'root'
  mode '0600'
  notifies :restart, "service[nginx]"
end

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
  commands ["#{node[:bluepill][:bin]}"]
  nopasswd true
end

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

include_recipe "rails::dependencies"

applications_root = node[:rails][:applications_root]

if node[:active_applications]

  node[:active_applications].each do |app, app_info|
    rails_env = app_info['rails_env'] || "production"
    deploy_user = app_info['deploy_user'] || "deploy"
    app_env = app_info['app_env'] || {}
    app_env['RAILS_ENV'] = rails_env

    rbenv_ruby app_info['ruby_version']

    rbenv_gem "bundler" do
      ruby_version app_info['ruby_version']
    end

    directory "#{applications_root}/#{app}" do
      recursive true
      group deploy_user
      owner deploy_user
    end

    ['config', 'shared', 'shared/config', 'shared/sockets', 'shared/pids', 'shared/log', 'shared/system', 'releases'].each do |dir|
      directory "#{applications_root}/#{app}/#{dir}" do
        recursive true
        group deploy_user
        owner deploy_user
      end
    end

    if app_info['database_info']

      template "#{applications_root}/#{app}/shared/config/database.yml" do
        owner deploy_user
        group deploy_user
        mode 0600
        source "app_database.yml.erb"
        variables :database_info => app_info['database_info'], :rails_env => rails_env
      end

    end

    if app_info['ssl_info']
      template "#{applications_root}/#{app}/shared/config/certificate.crt" do
        owner "deploy"
        group "deploy"
        mode 0644
        source "app_cert.crt.erb"
        variables :app_crt=> app_info['ssl_info']['crt']
      end

      template "#{applications_root}/#{app}/shared/config/certificate.key" do
        owner "deploy"
        group "deploy"
        mode 0644
        source "app_cert.key.erb"
        variables :app_key=> app_info['ssl_info']['key']
      end
    end

    template "/etc/nginx/sites-available/#{app}.conf" do
      source "app_passenger_nginx.conf.erb"
      variables :name => app, :domain_names => app_info['domain_names'], :enable_ssl => File.exists?("#{applications_root}/#{app}/shared/config/certificate.crt")
      notifies :reload, resources(:service => "nginx")
    end

    nginx_site "#{app}.conf" do
      action :enable
    end

    logrotate_app "rails-#{app}" do
      cookbook "logrotate"
      path ["#{applications_root}/#{app}/current/log/*.log"]
      frequency "daily"
      rotate 14
      compress true
      create "644 #{deploy_user} #{deploy_user}"
    end

  end

end