#
# Cookbook Name:: rails::remove_applications
# Recipe:: default
#
# Copyright 2012, Michiel Sikkes
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
applications_root = node[:rails][:applications_root]

include_recipe "nginx"

if node[:remove_applications]
  node[:remove_applications].each do |app|
    file "/etc/nginx/sites-enabled/#{app}.conf" do
      manage_symlink_source true
      action :delete
      notifies :reload, resources(service: "nginx")
    end

    file "/etc/nginx/sites-available/#{app}.conf" do
      action :delete
    end

    directory "#{applications_root}/#{app}" do
      recursive true
      action :delete
    end

    logrotate_app "rails-#{app}" do
      enable false
    end

    cron "backup_#{app}" do
      user "deploy"
      action :delete
    end

    file "/home/deploy/Backup/models/#{app}.rb" do
      action :delete
    end
  end
end
