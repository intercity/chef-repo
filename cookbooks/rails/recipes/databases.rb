include_recipe "database"

gem_package "mysql"

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

      if app_info['database_info']['client_addresses']

        app_info['database_info']['client_addresses'].each do |client_address|
          mysql_database_user database_name do
            connection(mysql_connection_info)
            username database_info['username']
            password database_info['password']
            table "*"
            host client_address
            action :grant
          end
        end

      end

    end
  end

end