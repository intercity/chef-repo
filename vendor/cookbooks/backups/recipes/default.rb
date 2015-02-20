# Cookbook Name:: backups
# Recipe:: default
#
# Copyright 2014, Firmhouse
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

backup_node = node[:backups]

if backup_node
  deploy_user = backup_node[:deploy_user] || "deploy"

  package "ruby1.9.1-dev"
  package "libxml2-dev"
  package "libxslt-dev"

  # Speed up nokogiri install by using syslibs
  ENV["NOKOGIRI_USE_SYSTEM_LIBRARIES"] = "true"
  gem_package "backup"

  backup_node.each do |app, backup_info|
    compression_enabled = backup_info.fetch(:compression_enabled, true)

    ["/home/#{deploy_user}/Backup", "/home/#{deploy_user}/Backup/models"].each do |path|
      directory path do
        owner deploy_user
        group deploy_user
        mode "0755"
      end
    end

    template "/home/#{deploy_user}/Backup/config.rb" do
      source "config.rb.erb"
      mode 0600
      owner deploy_user
      group deploy_user
    end

    storage = {
      type: backup_info.fetch(:storage_type, "unknown").to_sym,
      dropbox_api_key: backup_info[:dropbox_api_key],
      dropbox_api_secret: backup_info[:dropbox_api_secret],
      dropbox_access_token: backup_info[:dropbox_access_token],
      s3_access_key: backup_info[:s3_access_key],
      s3_secret_access_key: backup_info[:s3_secret_access_key],
      s3_bucket: backup_info[:s3_bucket],
      s3_region: backup_info.fetch(:s3_region, "eu-west-1")
    }

    database = {
      type: backup_info.fetch(:database_type, "unknown").to_sym,
      username: backup_info[:database_username],
      password: backup_info[:database_password],
      host: backup_info[:database_host]
    }

    template "/home/#{deploy_user}/Backup/models/#{app}.rb" do
      source "backup_template.rb.erb"
      mode 0600
      owner deploy_user
      group deploy_user
      variables(app: app, storage: storage, database: database,
                compression_enabled: compression_enabled)
    end

    if backup_info[:enabled]
      cron "backup_#{app}" do
        minute "0"
        hour "0"
        user deploy_user
        command "/bin/bash -l -c 'cd /home/#{deploy_user}/Backup && /usr/local/bin/backup perform --trigger #{app}'"
      end
    else
      cron "backup_#{app}" do
        user deploy_user
        action :delete
      end
    end
  end
end
