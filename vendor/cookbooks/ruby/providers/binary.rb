def whyrun_supported?
  true
end

use_inline_resources

#
# Name parameter: ruby version, for ex. "2.2.0"
# Path parameter: where new ruby should be installed
#
action :install do
  version = @new_resource.version
  path = @new_resource.path
  download_url = "#{node[:ruby][:download_url]}/#{node[:platform_version]}/#{node[:kernel][:machine]}/ruby-#{version}.tar.bz2"
  downloaded_ruby = "#{Chef::Config[:file_cache_path]}/#{::File.basename download_url}"

  Chef::Log.info "Installing ruby binary #{version} ..."
  Chef::Log.debug "version: #{version}"
  Chef::Log.debug "installation path: #{path}"
  Chef::Log.debug "download from: #{download_url}"
  Chef::Log.debug "save ruby to file: #{downloaded_ruby}"

  node.default[:ruby][version][:installed] = false

  begin
    remote_file downloaded_ruby do
      source download_url
      action :nothing
    end.run_action :create

    bash "extract ruby binary" do
      cwd path 
      code <<-EOH
        mkdir -p #{path}
        tar jxf #{downloaded_ruby} -C #{path}
        EOH
      only_if { ::File.exists? downloaded_ruby }
    end

    Chef::Log.debug "extracted to #{path}"
    node.default[:ruby][version][:installed] = true
  rescue Net::HTTPServerException => e
    Chef::Log.warn "Binary ruby download failed, error: #{e}"
  end
end
