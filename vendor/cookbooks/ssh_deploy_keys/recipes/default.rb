#
# Cookbook Name:: ssh_deploy_keys
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

if node[:deploy_users] && node[:ssh_deploy_keys]
  node[:deploy_users].each do |deploy_user|
    directory "/home/#{deploy_user}/.ssh" do
      mode 0700
      owner deploy_user
      group deploy_user
    end

    template "/home/#{deploy_user}/.ssh/authorized_keys" do
      source "authorized_keys.erb"
      mode 0600
      owner deploy_user
      group deploy_user
      variables :keys => node[:ssh_deploy_keys]
    end
  end
end