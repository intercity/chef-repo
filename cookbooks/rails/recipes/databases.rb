include_recipe "database"

node[:active_applications].each do |app, app_info|
  if app_info['database_info']

    database_info = app_info['database_info']

    template "/u/apps/#{app}/shared/config/database.yml" do
      owner "deploy"
      group "deploy"
      mode 0600
      source "app_database.yml.erb"
      variables :database_info => app_info['database_info']
    end

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

  end
end