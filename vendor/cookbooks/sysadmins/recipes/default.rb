#
# Cookbook Name:: sysadmins
# Recipe:: default
#
# Copyright 2014, Bèr `berkes` Kessels
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

sysadmin_users = []

node[:sysadmins].each do |user|
  sysadmin_users << user["username"]

  home_dir = "/home/#{user["username"]}"
  # Create a user
  user user["username"] do
    home home_dir
    password user["password"] if user["password"]

    manage_home true
    action :create
  end

  # Add ssh-keys to authorized_keys
  # Always create the file and dir, even if user did not provide
  # ssh-keys
  directory "#{home_dir}/.ssh" do
    owner user["username"]
    group user["username"]
    mode "0700"
  end
  if user["ssh_keys"]
    template "#{home_dir}/.ssh/authorized_keys" do
      source "authorized_keys.erb"
      owner user["username"]
      group user["username"]
      mode "0600"
      variables ssh_keys: user["ssh_keys"]
    end
  end

end

## Add users to the sysadmin group
group "admin" do
  members sysadmin_users
end
