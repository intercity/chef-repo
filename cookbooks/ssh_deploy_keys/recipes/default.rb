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

if node[:ssh_deploy_keys]
  template "/home/deploy/.ssh/authorized_keys" do
    source "authorized_keys.erb"
    mode 0600
    owner "deploy"
    group "deploy"
    variables :keys => node[:ssh_deploy_keys]
  end
end