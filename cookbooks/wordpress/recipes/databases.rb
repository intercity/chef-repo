include_recipe "database"

if node[:wordpress]

  node[:wordpress].each do |app, app_info|
    if app_info['database_info']

      database_info = app_info['database_info']

      mysql_connection_info = {:host => "localhost", :username => "root", :password => node['mysql']['server_root_password']}

      mysql_database database_info['database'] do
        connection(mysql_connection_info)
        encoding 'UTF8'
      end

      mysql_database_user database_info['username'] do
        connection(mysql_connection_info)
        username database_info['username']
        password database_info['password']
        database_name database_info['database']
        table "*"
        host "localhost"
        action :grant
      end

      if app_info['snapshot']
        snapshot = app_info['snapshot']
        snapshot_database = snapshot['database']
        snapshot_name = snapshot['name']

        bash "dump #{snapshot_name} for #{app}" do
          cwd "/u/wordpress/#{app}"
          code <<-EOH
            mysqldump -h localhost -u #{snapshot_database['username']} --password=#{snapshot_database['password']} #{snapshot_database['database']} > dump.sql
          EOH
        end

        bash "import snapshot dump" do
          code <<-EOH
            cat /u/wordpress/#{app}/dump.sql | mysql -h localhost -u #{database_info['username']} --password=#{database_info['password']} #{database_info['database']}
          EOH
        end

        mysql_database "import snapshot dump #{app}" do
          connection({:host => "localhost", :username => database_info['username'], :password => database_info['password']})
          database_name database_info['database']
          sql "update wp_options set option_value=replace(option_value, '#{snapshot['url']}', '#{app_info['url']}') where option_name IN ('siteurl', 'home'); update wp_users set user_email='#{app_info['admin_email']}',user_pass=md5('#{app_info['admin_password']}') where user_login = 'admin';"
          action :query
        end
      end

    end

  end

end