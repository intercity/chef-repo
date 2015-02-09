case node["platform_family"]
when 'debian'
  default["ruby"]["download_url"] = "http://binaries.intercityup.com/ruby/ubuntu"
end

