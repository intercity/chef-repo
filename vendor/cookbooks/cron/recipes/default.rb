#
# Cookbook Name:: cron
# Recipe:: default
#
# Copyright 2014, Bèr `berkes` Kessels
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

return unless node[:active_applications]

node[:active_applications].map do |app, app_info|
  app_info["cron"].each do |id, crontab|
    attributes = crontab.dup

    unscoped_command = attributes.delete("command")
    rails_env        = app_info['rails_env'] || "production"
    user             = attributes.delete("user") || app_info['deploy_user'] || "deploy"
    app_dir          = "#{node[:rails][:applications_root]}/#{app}/current"

    command = "cd #{app_dir} && ( PATH=/opt/rbenv/shims:$PATH RAILS_ENV=#{rails_env} bundle exec #{unscoped_command} )"

    cron "#{app}_#{id}" do
      command(command)
      user(user)
      attributes.each {|attribute, value| send(attribute, value) }
    end
  end
end
