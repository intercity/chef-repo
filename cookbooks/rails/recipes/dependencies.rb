node[:active_applications].each do |app, app_info|
  app_info['packages'].each do |package|
    package package
  end
end