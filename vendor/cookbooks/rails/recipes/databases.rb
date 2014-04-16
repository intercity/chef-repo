include_recipe "database"

package "libmysqlclient-dev"

gem_package "mysql" do
  gem_binary "/opt/chef/embedded/bin/gem"
end

if node[:active_applications]

  node[:active_applications].each do |app, app_info|
    if app_info['database_info']

      database_info = app_info['database_info']
      database_name = app_info['database_info']['database']

      mysql_connection_info = {:host => "localhost", :username => "root", :password => node['mysql']['server_root_password']}

      mysql_database database_name do
        connection(mysql_connection_info)
      end

      mysql_database_user database_name do
        connection(mysql_connection_info)
        username database_info['username']
        password database_info['password']
        table "*"
        host "localhost"
        action :grant
      end

    end
  end

end