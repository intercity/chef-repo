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
  end
end
