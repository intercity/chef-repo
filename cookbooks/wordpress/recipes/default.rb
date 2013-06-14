#
# Cookbook Name:: wordpress
# Recipe:: default
#
# Copyright 2013, Michiel Sikkes
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

include_recipe "nginx"

directory "/u/wordpress" do
  recursive true
  group "root"
  owner "root"
end

remote_file "/tmp/wordpress-3.5.1.tar.gz" do
  source "http://wordpress.org/wordpress-3.5.1.tar.gz"
  checksum "409889c98b13cbdbb9fd121df859ae3e"
  mode "0644"
  not_if { File.exist? "/tmp/wordpress-3.5.1.tar.gz"}
end

if node[:wordpress]

  node[:wordpress].each do |app, app_info|

    group "wp_#{app}"

    user "wp_#{app}" do
      comment "User for WordPress site #{app}"
      home "/u/wordpress/#{app}"
      shell "/bin/false"
      gid "wp_#{app}"
      supports ( { :manage_home => true })
    end

    directory "/u/wordpress/#{app}" do
      recursive true
      owner "wp_#{app}"
      group "wp_#{app}"
      mode "0775"
    end

    directory "/u/wordpress/#{app}/log" do
      recursive true
      owner "wp_#{app}"
      group "wp_#{app}"
      mode "0775"
    end

    if app_info['snapshot']
      bash "copy-snapshot-to-#{app}" do
        code <<-EOC
          cp -r /u/wordpress/#{app_info['snapshot']['name']}/* /u/wordpress/#{app}/
        EOC
        user "wp_#{app}"
      end
    else

      bash "extract-wordpress-#{app}" do
        code <<-EOC
  cd /u/wordpress/#{app} && tar zxf /tmp/wordpress-3.5.1.tar.gz
        EOC
        user "wp_#{app}"
        not_if { File.exist? "/u/wordpress/#{app}/wordpress/wp-config.php" }
      end
    end

    template "/etc/php5/fpm/pool.d/#{app}.conf" do
      cookbook "php"
      source "pool.conf.erb"
      variables({
        :pool => app,
        :listen => "/u/wordpress/#{app}/fpm.sock",
        :user => "wp_#{app}",
        :group => "wp_#{app}",
        :chroot => "/u/wordpress/#{app}"
      })
      notifies :reload, resources(:service => "php5-fpm"), :immediately
    end

    template "/etc/nginx/sites-available/wordpress_#{app}.conf" do
      source "wordpress_nginx.conf.erb"
      variables({
        :name => "wordpress_#{app}",
        :domain_names => app_info['domain_names'],
        :root => "/u/wordpress/#{app}/wordpress",
        :socket => "/u/wordpress/#{app}/fpm.sock"
      })
      notifies :reload, resources(:service => "nginx")
    end

    nginx_site "wordpress_#{app}.conf" do
      action :enable
      timing :immediately
    end

    template "/u/wordpress/#{app}/wordpress/wp-config.php" do
      source "wp-config.php.erb"
      variables({
        :database_info => app_info['database_info'],
        :keys => app_info['keys'],
        :disallow_file_mods => app_info['disallow_file_mods'] || false
      })
      mode "0755"
    end

    if app_info['install_themes']

      app_info['install_themes'].each do |filename, url|

        remote_file "/u/wordpress/#{app}/wordpress/wp-content/themes/#{filename}.zip" do
          source url
          mode "00640"
          owner "wp_#{app}"
          group "wp_#{app}"
        end

        bash 'extract-theme' do
          code <<-EOT
            cd /u/wordpress/#{app}/wordpress/wp-content/themes && unzip -u #{filename}.zip
          EOT
          user "wp_#{app}"
        end

      end

    end

    bash "setup chroot" do
      code <<-EOC
      mkdir -p /u/wordpress/#{app}/etc
      mkdir -p /u/wordpress/#{app}/tmp
      chmod a+w /u/wordpress/#{app}/tmp
      ln /etc/hosts /u/wordpress/#{app}/etc/hosts
      ln /etc/localtime /u/wordpress/#{app}/etc/localtime
      cp /etc/resolv.conf /u/wordpress/#{app}/etc/resolv.conf
      ln /etc/nsswitch.conf /u/wordpress/#{app}/etc/nsswitch.conf
      ln /etc/ld.so.cache /u/wordpress/#{app}/etc/ld.so.cache
      mkdir -p /u/wordpress/#{app}/usr/share
      cp -r /usr/share/zoneinfo /u/wordpress/#{app}/usr/share
      mkdir -p /u/wordpress/#{app}/lib/x86_64-linux-gnu
      cp -r /lib/x86_64-linux-gnu/libnss* /u/wordpress/#{app}/lib/x86_64-linux-gnu
      EOC
    end

  end

end