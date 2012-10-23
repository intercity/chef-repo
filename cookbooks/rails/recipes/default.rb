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

user "deploy" do
  comment "Deploy User"
  home "/home/deploy"
  shell "/bin/bash"

  supports({ :manage_home => true })
end

group "deploy" do
  members ['deploy']
end

node[:active_applications].each do |app, app_info|
  directory "/u/apps/#{app}" do
    recursive true
    group "deploy"
    owner "deploy"
  end

  template "/etc/nginx/sites-available/#{app}.conf" do
    source "app_nginx.conf.erb"
    variables :name => name, :domain_names => app_info['domain_names']
    notifies :reload, resources(:service => "nginx")
  end

  nginx_site app do
    action :enable
  end

  logrotate app do
    files ["/u/apps/#{app}/current/log/*.log"]
    frequency "daily"
    rotate_count 14
    compress true
  end

end