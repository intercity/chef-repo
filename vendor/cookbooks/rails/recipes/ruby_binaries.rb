applications_root = node[:rails][:applications_root]
available_binaries = node[:rbenv][:available_binaries]
if node[:active_applications]
  node[:active_applications].each do |app, app_info|
    if app_info[:ruby_version]
      if available_binaries.include? app_info[:ruby_version]
        version, rbenv_versions_path = app_info[:ruby_version], "/opt/rbenv/versions"

        ruby_binary version do
          path rbenv_versions_path
          not_if { File.directory? "#{rbenv_versions_path}/#{version}" }
        end

        ruby_build_ruby version do
          prefix_path "#{rbenv_versions_path}/#{version}"
          subscribes :install, "ruby_binary[#{version}]", :immediately
          not_if do
            File.directory?("#{rbenv_versions_path}/#{version}") ||
              node[:ruby][version][:installed]
          end
        end
      end
    end
  end
end
