#
# Cookbook Name:: rsyslog
# Recipe:: default
#
# Copyright 2009-2013, Opscode, Inc.
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

package "rsyslog" do
  action :install
end

directory "/etc/rsyslog.d" do
  mode 0755
end

directory "/var/spool/rsyslog" do
  mode 0755
end

# Our main stub which then does its own rsyslog-specific
# include of things in /etc/rsyslog.d/*
template "/etc/rsyslog.conf" do
  source 'rsyslog.conf.erb'
  mode 0644
  variables(:protocol => node['rsyslog']['protocol'])
  notifies :restart, "service[#{node['rsyslog']['service_name']}]"
end

template "/etc/rsyslog.d/50-default.conf" do
  source "50-default.conf.erb"
  backup false
  mode 0644
  notifies :restart, "service[#{node['rsyslog']['service_name']}]"
end

# syslog needs to be stopped before rsyslog can be started on RHEL versions before 6.0
if platform_family?('rhel') && node['platform_version'].to_i < 6
  service "syslog" do
    action [:stop, :disable]
  end
end

service node['rsyslog']['service_name'] do
  supports :restart => true, :reload => true, :status => true
  action [:enable, :start]
end
