include_recipe "database"

gem_package "mysql"

if node[:active_applications]

  node[:active_applications].each do |app, app_info|
    if app_info['database_info']

      database_info = app_info['database_info']

      mysql_connection_info = {:host => "localhost", :username => "root", :password => node['mysql']['server_root_password']}

      mysql_database app do
        connection(mysql_connection_info)
      end

      mysql_database_user app do
        connection(mysql_connection_info)
        username database_info['username']
        password database_info['password']
        database_name app
        table "*"
        host "localhost"
        action :grant
      end

      if app_info['database_info']['client_addresses']

        app_info['database_info']['client_addresses'].each do |client_address|
          mysql_database_user app do
            connection(mysql_connection_info)
            username database_info['username']
            password database_info['password']
            database_name app
            table "*"
            host client_address
            action :grant
          end
        end

      end

    end
  end

end