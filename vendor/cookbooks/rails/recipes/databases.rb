include_recipe "database"

if node[:active_applications]
  node[:active_applications].each do |app, app_info|
    if app_info['database_info']
      database_info = app_info['database_info']
      database_name = app_info['database_info']['database']


      if database_info['adapter'] =~ /mysql/
        chef_gem 'mysql'

        mysql_connection_info = {:host => "localhost", :username => "root", :password => node['mysql']['server_root_password']}

        mysql_database database_name do
          connection(mysql_connection_info)
        end

        mysql_database_user database_info['username'] do
          connection(mysql_connection_info)
          username database_info['username']
          password database_info['password']
          database database_info['database']
          table "*"
          host "localhost"
          action :grant
        end
      elsif database_info['adapter'] =~ /postgres/
        include_recipe "database::postgresql"

        postgresql_connection_info = {:host => "localhost", :username => "postgres", :password => node['postgresql']['password']['postgres']}

        postgresql_database database_name do
          connection(postgresql_connection_info)
          owner database_info['username']
          action :create
        end

        postgresql_database_user database_info['username'] do
          connection(postgresql_connection_info)
          database_name database_name
          password database_info['password']
          privileges [:all]
          action [:create, :grant]
        end
      end

    end
  end

end
