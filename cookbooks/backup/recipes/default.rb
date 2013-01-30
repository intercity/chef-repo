#
# Cookbook Name:: backup
# Recipe:: default
#
# Copyright 2013, Alexander Zaytsev
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

gem_package 'backup'
gem_package 'dropbox-sdk' do
  version '~> 1.2.0'
end


directory "/home/deploy/Backup" do
  group "deploy"
  owner "deploy"
end

directory "/home/deploy/Backup/models" do
  group "deploy"
  owner "deploy"
end

template "/home/deploy/Backup/config.rb" do
  owner "deploy"
  group "deploy"
  mode 0600
  source "config.rb.erb"
end

if node[:active_applications]
  node[:active_applications].each do |app, app_info|
    if app_info['backup_info'] && app_info['database_info']
      template "/home/deploy/Backup/models/#{app_info['database_info']['database']}.rb" do
        owner "deploy"
        group "deploy"
        mode 0600
        source "model.rb.erb"
        variables :backup_info => app_info['backup_info'], :database_info => app_info['database_info']
      end
    end
  end
end