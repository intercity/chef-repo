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

include_recipe "rails::setup"
include_recipe "rails::imagemagick"

applications_root = node[:rails][:applications_root]

if node[:active_applications]

  node[:active_applications].each do |app, app_info|
    rails_env = app_info['rails_env'] || "production"
    deploy_user = app_info['deploy_user'] || "deploy"
    application_root = "#{applications_root}/#{app}"
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

    ["shared/config",
     "shared/bin",
     "shared/vendor",
     "shared/public",
     "shared/bundle",
     "shared/tmp",
     "shared/tmp/sockets",
     "shared/tmp/cache",
     "shared/tmp/sockets",
     "shared/tmp/pids",
     "shared/log",
     "shared/system",
     "releases"].each do |dir|
      directory "#{applications_root}/#{app}/#{dir}" do
        recursive true
        group deploy_user
        owner deploy_user
      end
    end

    template "#{application_root}/shared/.ruby-version" do
      owner deploy_user
      group deploy_user
      mode 0600
      source "ruby-version.erb"
      variables ruby_version: app_info["ruby_version"]
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
      source "app_nginx.conf.erb"
      variables :name => app, :domain_names => app_info['domain_names'], :enable_ssl => File.exists?("#{applications_root}/#{app}/shared/config/certificate.crt")
      notifies :reload, resources(:service => "nginx")
    end

    template "#{applications_root}/#{app}/shared/config/unicorn.rb" do
      mode 0644
      source "app_unicorn.rb.erb"
      variables :name => app, :deploy_user => deploy_user, :number_of_workers => app_info['number_of_workers'] || 2
    end

    template "/etc/init/#{app}.conf" do
      mode 0644
      source "unicorn_upstart.erb"
      variables(
        name: app,
        rails_env: rails_env,
        deploy_user: deploy_user,
        application_root: application_root
      )
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
      path ["#{applications_root}/#{app}/current/log/*.log"]
      frequency "daily"
      rotate 14
      compress true
      create "644 #{deploy_user} #{deploy_user}"
    end

  end

end
