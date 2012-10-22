#
# Cookbook Name:: bluepill
# Provider:: service
#
# Copyright 2010, Opscode, Inc.
# Copyright 2012, Heavy Water Operations, LLC
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

require 'chef/mixin/shell_out'
require 'chef/mixin/language'

include Chef::Mixin::ShellOut

action :enable do
  config_file = ::File.join(node['bluepill']['conf_dir'],
                            "#{new_resource.service_name}.pill")
  unless @current_resource.enabled
    link "#{node['bluepill']['init_dir']}/#{new_resource.service_name}" do
      to node['bluepill']['bin']
      only_if { ::File.exists?(config_file) }
    end
    case node['platform']
    when "centos", "redhat", "freebsd", "amazon", "scientific", "fedora"
      template "#{node['bluepill']['init_dir']}/bluepill-#{new_resource.service_name}" do
        source "bluepill_init.erb"
        cookbook "bluepill"
        owner "root"
        group node['bluepill']['group']
        mode "0755"
        variables(
                  :service_name => new_resource.service_name,
                  :config_file => config_file
                  )
      end

      service "bluepill-#{new_resource.service_name}" do
        action [ :enable ]
      end
    end
    new_resource.updated_by_last_action(true)
  end
end

action :load do
  unless @current_resource.running
    shell_out!(load_command)
    new_resource.updated_by_last_action(true)
  end
end

action :start do
  unless @current_resource.running
    shell_out!(start_command)
    new_resource.updated_by_last_action(true)
  end
end

action :disable do
  if @current_resource.enabled
    file "#{node['bluepill']['conf_dir']}/#{new_resource.service_name}.pill" do
      action :delete
    end
    link "#{node['bluepill']['init_dir']}/#{new_resource.service_name}" do
      action :delete
    end
    new_resource.updated_by_last_action(true)
  end
end

action :stop do
  if @current_resource.running
    shell_out!(stop_command)
    new_resource.updated_by_last_action(true)
  end
end

action :restart do
  if @current_resource.running
    Chef::Log.debug "Restarting #{new_resource.service_name}"
    shell_out!(restart_command)
    new_resource.updated_by_last_action(true)
    Chef::Log.debug "Restarted #{new_resource.service_name}"
  end
end

def load_current_resource
  @current_resource = Chef::Resource::BluepillService.new(new_resource.name)
  @current_resource.service_name(new_resource.service_name)

  Chef::Log.debug("Checking status of service #{new_resource.service_name}")

  determine_current_status!

  @current_resource
end

protected

def status_command
  "#{node['bluepill']['bin']} #{new_resource.service_name} status"
end

def load_command
  "#{node['bluepill']['bin']} load #{node['bluepill']['conf_dir']}/#{new_resource.service_name}.pill"
end

def start_command
  "#{node['bluepill']['bin']} #{new_resource.service_name} start"
end

def stop_command
  "#{node['bluepill']['bin']} #{new_resource.service_name} stop"
end

def restart_command
  "#{node['bluepill']['bin']} #{new_resource.service_name} restart"
end

def determine_current_status!
  service_running?
  service_enabled?
end

def service_running?
  begin
    if shell_out(status_command).exitstatus == 0
      @current_resource.running true
      Chef::Log.debug("#{new_resource} is running")
    end
  rescue Mixlib::ShellOut::ShellCommandFailed, SystemCallError
    @current_resource.running false
    nil
  end
end

def service_enabled?
  if ::File.exists?("#{node['bluepill']['conf_dir']}/#{new_resource.service_name}.pill") &&
      ::File.symlink?("#{node['bluepill']['init_dir']}/#{new_resource.service_name}")
    @current_resource.enabled true
  else
    @current_resource.enabled false
  end
end
