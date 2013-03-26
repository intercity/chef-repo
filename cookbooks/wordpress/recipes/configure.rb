require 'shellwords'
include_recipe "wordpress::databases"

if node[:wordpress]

  node[:wordpress].each do |app, app_info|
    if app_info['preconfigure'] == true
      weblog_title = app_info['weblog_title']
      admin_password = app_info['admin_password']
      admin_email = app_info['admin_email']
      url = app_info['url']
      database = app_info['database_info']['database']

      command = "curl \"#{url}/wp-admin/install.php?step=2\" -d \"weblog_title=#{weblog_title}&user_login=admin&admin_password=#{admin_password}&admin_password2=#{admin_password}&admin_email=#{admin_email}\""
      log "Running bootstrap #{command}"

      bash "configure_wordpress_#{app}" do
        user "wp_#{app}"
        cwd "/u/wordpress/#{app}/wordpress"
        code <<-EOH
        #{command};
        touch CONFIGURED
        EOH
        not_if { File.exist?('CONFIGURED')}
      end

      if app_info['plugins']

        app_info['plugins'].each do |plugin, url|

          basename = File.basename(url)

          remote_file "/u/wordpress/#{app}/wordpress/wp-content/plugins/#{basename}" do
            owner "wp_#{app}"
            group "wp_#{app}"
            source url
          end

          bash "extract-plugin-#{app}-#{plugin}" do
            code <<-EOC
              cd /u/wordpress/#{app}/wordpress/wp-content/plugins && unzip -o #{basename}
            EOC
            user "wp_#{app}"
          end

        end
      end

      if app_info['default_theme']
        mysql_connection_info = {:host => "localhost", :username => app, :password => app}
        default_theme = app_info['default_theme']

        log "Setting default theme"
        mysql_database database do
          connection mysql_connection_info
          sql "update wp_options set option_value=#{default_theme} where option_name in ('stylesheet','template');"
          action :query
          not_if { File.exist?('')}
        end
      end
    end
  end

end