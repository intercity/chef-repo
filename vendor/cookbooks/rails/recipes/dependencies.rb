if node[:active_applications]

  node[:active_applications].each do |app, app_info|
    if app_info['packages']
      app_info['packages'].each do |package|
        package package
      end
    end
  end

end