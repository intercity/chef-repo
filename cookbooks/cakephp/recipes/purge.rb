include_recipe "nginx"
include_recipe "php"

if node[:purge_cakephp]

  node[:purge_cakephp].each do |app|

    nginx_site "#{app}.conf" do
      enable false
    end

    file "/etc/php5/fpm/pool.d/#{app}.conf" do
      action :delete
      notifies :restart, resources(:service => "php5-fpm")
    end

  end

end