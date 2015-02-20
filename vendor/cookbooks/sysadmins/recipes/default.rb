#
# Cookbook Name:: sysadmins
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

node[:sysadmins].each do |username, user|
  home_dir = "/home/#{username}"
  # Create a user
  user username do
    home home_dir
    password user["password"] if user.attribute?(:password)

    shell "/bin/bash"
    manage_home true
    action :create
  end

  # Add ssh-keys to authorized_keys
  # Always create the file and dir, even if user did not provide
  # ssh-keys
  directory "#{home_dir}/.ssh" do
    owner username
    group username
    mode "0700"
  end
  if user["ssh_keys"]
    template "#{home_dir}/.ssh/authorized_keys" do
      source "authorized_keys.erb"
      owner username
      group username
      mode "0600"
      variables ssh_keys: user["ssh_keys"]
    end
  end

end

# Add users to the sysadmin group. This is the group used by
# the sudo cookbook to grant users sudo-access.
group "admin" do
  members node[:sysadmins].keys
end
