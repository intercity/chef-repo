if node[:active_applications]
  node[:active_applications].each do |app, app_info|
    if app_info['database_info']
      database_info = app_info['database_info']
      
      database_name     = database_info['database']
      database_username = database_info['username']
      database_password = database_info['password']


      if database_info['adapter'] =~ /mysql/
        mysql_service_name = "default"
        host = node["mysql"]["bind_address"] 
        root_password = node["mysql"]["server_root_password"]

        mysql_connection_info = {
          host: host, 
          username: "root", 
          password: root_password,
          socket: "/var/run/mysql-#{mysql_service_name}/mysqld.sock"
        }
        
        mysql_service mysql_service_name do
          initial_root_password root_password
          action [:create, :start]
        end

        mysql_database database_name do
          connection mysql_connection_info
          action :create
        end

        mysql_database_user database_username do
          connection mysql_connection_info
          password database_password
          database_name database_name
          host "localhost"
          table "*"
          action [:create, :grant]
        end
      elsif database_info['adapter'] == 'postgresql'
        execute "create-database-user" do
          psql = "psql -U postgres -c \"create user \\\"#{database_username}\\\" with password '#{database_password}'\""
          user 'postgres'
          command psql
          returns [0,1]
        end
 
        execute "create-database" do
          user 'postgres'
          command "createdb -U postgres -O #{database_username} #{database_name}"
          returns [0,1]
        end
      end
    end
  end

end
