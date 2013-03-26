#
# Cookbook Name:: vagrant
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

if node[:vagrant][:host_entries]

  node[:vagrant][:host_entries].each do |host_entry|

    if host_entry[:point_to_host]
      address = node[:network][:interfaces][:eth0][:routes].first["via"]
    else
      address = host_entry[:address]
    end

    hostsfile_entry address do
      hostname host_entry[:hostname] # 'www.themedemo.dev'
      aliases  host_entry[:aliases] # ['themedemo.dev']
      action :create
    end

  end

end

template "/etc/chef/solo.rb" do
  source "solo.rb.erb"
end

if node[:vagrant][:local_key]
  bash "add local key to vagrant" do
    code <<-EOH
      echo "#{node[:vagrant][:local_key]}" >> /home/vagrant/.ssh/authorized_keys
    EOH
  end
end