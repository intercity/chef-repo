#
# Cookbook Name:: cakephp
# Recipe:: default
#
# Copyright 2013, Youri van der Lans
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

include_recipe "nginx"
include_recipe "cakephp::dependencies"

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
  end
end

if node[:active_cakephp_applications]

  node[:active_cakephp_applications].each do |app, app_info|
    deploy_user = app_info['deploy_user'] || "deploy"

    directory "/u/apps/#{app}" do
      recursive true
      group deploy_user
      owner deploy_user
    end

    ['config', 'shared', 'shared/config', 'shared/sockets', 'shared/log', 'shared/system', 'releases'].each do |dir|
      directory "/u/apps/#{app}/#{dir}" do
        recursive true
        group deploy_user
        owner deploy_user
      end
    end

    if app_info['database_info']
      template "/u/apps/#{app}/shared/config/database.php" do
        owner deploy_user
        group deploy_user
        mode 0600
        source "app_database.php.erb"
        variables :database_info => app_info['database_info']
        not_if do ::File.exists?("/u/apps/#{app}/shared/config/database.php") end
      end
    end

    template "/u/apps/#{app}/shared/config/bootstrap.php" do
      owner deploy_user
      group deploy_user
      mode 0600
      source "app_bootstrap.php.erb"
      not_if do ::File.exists?("/u/apps/#{app}/shared/config/bootstrap.php") end
    end

    template "/etc/php5/fpm/pool.d/#{app}.conf" do
      cookbook "php"
      source "pool.conf.erb"
      variables({
        :pool => app,
        :listen => "/u/apps/#{app}/shared/sockets/fpm.sock",
        :user => deploy_user,
        :group => deploy_user,
        :chroot => "/u/apps/#{app}"
      })
      notifies :reload, resources(:service => "php5-fpm"), :immediately
    end

    template "/etc/nginx/sites-available/#{app}.conf" do
      source "app_nginx.conf.erb"
      variables :name => app, :domain_names => app_info['domain_names']
      notifies :reload, resources(:service => "nginx")
    end

    nginx_site "#{app}.conf" do
      action :enable
      timing :immediately
    end

    bash "setup chroot" do
      code <<-EOC
      mkdir -p /u/apps/#{app}/etc
      mkdir -p /u/apps/#{app}/tmp
      chmod a+w /u/apps/#{app}/tmp
      ln /etc/hosts /u/apps/#{app}/etc/hosts
      ln /etc/localtime /u/apps/#{app}/etc/localtime
      cp /etc/resolv.conf /u/apps/#{app}/etc/resolv.conf
      ln /etc/nsswitch.conf /u/apps/#{app}/etc/nsswitch.conf
      ln /etc/ld.so.cache /u/apps/#{app}/etc/ld.so.cache
      mkdir -p /u/apps/#{app}/lib/x86_64-linux-gnu
      cp -r /lib/x86_64-linux-gnu/libnss* /u/apps/#{app}/lib/x86_64-linux-gnu
      pecl install timezonedb
      echo 'extension=timezonedb.so' > /etc/php5/conf.d/timezonedb.ini
      EOC
    end
  end

end