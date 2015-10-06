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

    ##
    # Create a rendered set of access and deny rules for nginx conf.
    # Ensures we always have a string to render.
    def nginx_access(app_info)
      # Ensure we always have a hash, and dup to make it writable
      access = app_info.fetch("access", {}).dup
      access["allowed"] ||= []
      access["denied"]  ||= []
      access
    end
  end
end
