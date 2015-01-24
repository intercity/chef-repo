module Rails
  module Helpers
    ##
    # Create a default set of custom config
    # Assure we always send certain hash keys to the template
    def nginx_custom_configuration(app_info)
      empty_conf = {
        "before_server" => "",
        "server_main" => "",
        "server_app" => "",
        "server_ssl"  => "",
        "server_ssl_app" => "",
        "upstream" => "",
        "after_server" => "",
      }

      empty_conf.merge(app_info["nginx_custom"] || {})
    end

    # Returns a server path to certificate file
    #
    #   applications_root = '/u/apps/'
    #   name = 'my_app'
    #   ssl_certificate(applications_root, name, app_info) # => /u/apps/my_app/shared/config/my_app.crt'
    #
    #   or,
    #
    #   applications_root = '/u/apps/'
    #   name = 'my_app'
    #   app_info['ssl_info']['certificate'] = 'my_cert.crt'
    #   ssl_certificate(applications_root, name, app_info) # => /u/apps/my_app/shared/config/my_cert.crt'
    #
    #
    def ssl_certificate(applications_root, name, app_info)
      raise "Invalid application config given, no `ssl_info` present" unless ssl_info?(app_info)

      Pathname.new(applications_root).join(name, "shared", "config",
                                           app_info["ssl_info"]["certificate"] || "#{name}.crt")
    end

    # See #ssl_certificate
    #
    def ssl_certificate_key(applications_root, name, app_info)
      raise "Invalid application config given, no `ssl_info` present" unless ssl_info?(app_info)

      Pathname.new(applications_root).join(name, "shared", "config",
                                           app_info["ssl_info"]["certificate_key"] || "#{name}.key")
    end

    # Check if the app config has ssl_info section
    #
    def ssl_info?(app_info)
      app_info.key?("ssl_info")
    end

    # Checks if the app config has ssl enabled
    #
    def ssl_enabled?(app_info)
      ssl_info?(app_info) && app_info["ssl_info"]["enabled"]
    end
  end
end
