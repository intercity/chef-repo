#
# Cookbook Name:: percona_mysql
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

include_recipe "apt"

template "/etc/apt/sources.list.d/my_sources.list" do
  variables :version => node['lsb']['codename']
  notifies :run, resources(:execute => "apt-get update"), :immediately
end

apt_repository "percona" do
  uri "http://repo.percona.com/apt"
  distribution node['lsb']['codename']
  components ["main"]
  deb_src true
  keyserver "hkp://minsky.surfnet.nl"
  key "1C4CBDCDCD2EFD2A"
end

chef_gem "mysql" do
  action :nothing
end

package "libmysqlclient-dev" do
  action :install
  notifies :install, "chef_gem[mysql]", :immediately
end