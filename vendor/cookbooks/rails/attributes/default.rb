default["rails"]["applications_root"] = "/u/apps"
default["rbenv"]["binaries_url"] = "https://intercityup.com/binaries/ruby/ubuntu"
default["rbenv"]["available_binaries"] = %w(1.9.3-p547 2.0.0-p481 2.1.1 2.1.2 2.1.3)

case node["platform_family"]
when "debian"
  if node["platform"] == "ubuntu" && node["platform_version"] == "14.04"
    default["nginx"]["pid"] = "/run/nginx.pid"
  end
end
