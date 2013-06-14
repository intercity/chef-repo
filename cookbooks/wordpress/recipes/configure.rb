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

    end
  end

end