#
# Cookbook Name:: bluepill
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
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

gem_package "i18n" do
  action :install
end

gem_package "bluepill" do
  version node["bluepill"]["version"] if node["bluepill"]["version"]
  action :install
end

[
  node["bluepill"]["conf_dir"],
  node["bluepill"]["pid_dir"],
  node["bluepill"]["state_dir"]
].each do |dir|
  directory dir do
    recursive true
    owner "root"
    group node["bluepill"]["group"]
  end
end

file node["bluepill"]["logfile"] do
  owner "root"
  group node["bluepill"]["group"]
  mode "0755"
  action :create_if_missing
end

include_recipe "bluepill::rsyslog" if node['bluepill']['use_rsyslog']
