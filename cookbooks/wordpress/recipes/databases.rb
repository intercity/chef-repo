include_recipe "database"

if node[:wordpress]

  node[:wordpress].each do |app, app_info|
    if app_info['database_info']

      database_info = app_info['database_info']

      mysql_connection_info = {:host => "localhost", :username => "root", :password => node['mysql']['server_root_password']}

      mysql_database app do
        connection(mysql_connection_info)
        encoding 'UTF8'
      end

      mysql_database_user app do
        connection(mysql_connection_info)
        username database_info['username']
        password database_info['password']
        database_name database_info['database']
        table "*"
        host "localhost"
        action :grant
      end

    end
  end

end