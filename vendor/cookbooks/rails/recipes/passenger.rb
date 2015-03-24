#
# Cookbook Name:: rails::passenger
# Recipe:: default
#
# Copyright 2012, Michiel Sikkes
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

package "apt-transport-https"

apt_repository "passenger" do
  uri "https://oss-binaries.phusionpassenger.com/apt/passenger"
  distribution node['lsb']['codename']
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

include_recipe "rails::setup"

applications_root = node[:rails][:applications_root]

if node[:active_applications]

  # Include library helpers
  ::Chef::Resource.send(:include, Rails::Helpers)

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

    template "#{applications_root}/#{app}/shared/.ruby-version" do
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

    has_ssl_info = false
    if app_info['ssl_info']
      template "#{applications_root}/#{app}/shared/config/certificate.crt" do
        owner "deploy"
        group "deploy"
        mode 0644
        source "app_cert.crt.erb"
        variables :app_crt=> app_info['ssl_info']['crt']
        notifies :reload, resources(service: "nginx")
      end

      template "#{applications_root}/#{app}/shared/config/certificate.key" do
        owner "deploy"
        group "deploy"
        mode 0644
        source "app_cert.key.erb"
        variables :app_key=> app_info['ssl_info']['key']
        notifies :reload, resources(service: "nginx")
      end
      has_ssl_info = true
    end

    enable_ssl = has_ssl_info ||
      File.exists?("#{applications_root}/#{app}/shared/config/certificate.crt")
    template "/etc/nginx/sites-available/#{app}.conf" do
      source "app_passenger_nginx.conf.erb"
      variables(
        name: app,
        rails_env: rails_env,
        domain_names: app_info["domain_names"],
        redirect_domain_names: app_info["redirect_domain_names"],
        client_max_body_size: app_info["client_max_body_size"],
        enable_ssl: enable_ssl,
        custom_configuration: nginx_custom_configuration(app_info))
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
