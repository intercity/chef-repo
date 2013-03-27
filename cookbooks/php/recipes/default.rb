#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2013, Michiel Sikkes
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

package "php5-fpm"
package "php5-mysql"

service "php5-fpm" do
  supports :restart => true, :status => true, :reload => true
  action [ :enable ]
end

directory "/var/run/php5-fpm" do
  user "root"
  owner "root"
  mode "0755"
end

template "/etc/php5/fpm/pool.d/www.conf" do
  source "pool.conf.erb"
  variables({
    :pool => "www",
    :listen => "/var/run/php5-fpm/www.sock",
    :user => "www-data",
    :group => "www-data"
  })
  notifies :restart, resources(:service => "php5-fpm"), :immediately
end