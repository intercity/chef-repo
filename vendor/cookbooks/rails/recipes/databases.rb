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

        mysql_database_user database_name do
          connection(mysql_connection_info)
          username database_info['username']
          password database_info['password']
          table "*"
          host "localhost"
          action :grant
        end
      elsif database_info['adapter'] =~ /postgres/
        execute "create-database-user" do
          code = <<-EOH
sudo su - postgres -c "psql -U postgres -c \\"select * from pg_user where usename='#{database_info['username']}'\\" | grep -c #{database_info['username']}"
EOH

          psql = <<-EOC
psql -U postgres -c "create user \\"#{database_info['username']}\\" with password '#{database_info['password']}'"
EOC
          user 'postgres'
          command psql
          not_if code
        end
        execute "create-database" do
          exists = <<-EOH
sudo su - postgres -c "psql -U postgres -c \\"select * from pg_database WHERE datname='#{database_name}'\\" | grep -c #{database_name}"
EOH
          command "sudo su - postgres -c 'createdb -U postgres -O #{database_info['username']} -E utf8 -T template0 #{database_name}'"
          not_if exists
        end
      end

    end
  end

end
