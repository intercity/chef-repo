applications_root = node[:rails][:applications_root]
available_binaries = node[:rbenv][:available_binaries]
kernel_architecture = node[:kernel][:machine]
if node[:active_applications]
  node[:active_applications].each do |app, app_info|
    if app_info[:ruby_version]
      if available_binaries.include? app_info[:ruby_version]
        ruby_version = app_info[:ruby_version]
        ruby_binary = "ruby-#{ruby_version}.tar.bz2"
        execute "Install ruby #{app_info[:ruby_version]} binaries" do
          ruby = app_info[:ruby_version]
          user node[:rbenv][:user]
          group node[:rbenv][:group]
          cwd "#{node[:rbenv][:root_path]}/versions"
          command <<-EOM
              wget #{node[:rbenv][:binaries_url]}/#{node["platform_version"]}/#{kernel_architecture}/#{ruby_binary};
              tar jxf #{ruby_binary}
              rm #{ruby_binary}
            EOM
          not_if {  File.directory?(File.join('opt', 'rbenv', 'versions', ruby_version)) }
        end
      end
    end
  end
end
