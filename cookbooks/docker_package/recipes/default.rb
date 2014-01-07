#
# Cookbook Name:: docker_package
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

user "deploy" do
  comment "Deploy User"
  home "/home/deploy"
  shell "/bin/bash"

  supports(:manage_home => true )
end

group "deploy" do
  members ['deploy']
end

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"
include_recipe "rbenv::rbenv_vars"

# ruby_versions = ['2.1.0', '2.0.0-p353', '1.9.3-p484']

ruby_versions = ['2.0.0-p247']

ruby_versions.each do |ruby_version|

  rbenv_ruby ruby_version

  rbenv_gem "bundler" do
    ruby_version ruby_version
  end

end

Chef::Platform.set :platform => :ubuntu, :resource => :service, :provider => Chef::Provider::DockerPackageService

package "supervisor"
package "cron"

template "/etc/supervisor/conf.d/ssh.conf" do
  owner 'root'
  group 'root'
  source "supervisor.conf.erb"
  variables name: 'ssh', command: '/usr/sbin/sshd -D'
end

template "/etc/supervisor/conf.d/nginx.conf" do
  owner 'root'
  group 'root'
  source "supervisor.conf.erb"
  variables name: 'nginx', command: 'nginx'
end

template "/etc/supervisor/conf.d/mysql.conf" do
  owner 'root'
  group 'root'
  source "supervisor.conf.erb"
  variables name: 'mysql', command: "/usr/bin/pidproxy #{node['mysql']['pid_file']} /usr/bin/mysqld_safe"
end

template "/etc/supervisor/conf.d/cron.conf" do
  owner 'root'
  group 'root'
  source "supervisor.conf.erb"
  variables name: 'cron', command: 'cron -f'
end

execute "supervisorctl update" do
  user "root"
end