action :supervise do
  template "/etc/supervisor/conf.d/#{new_resource.name}.conf" do
    source "supervised-program.conf.erb"
    cookbook "supervisord"
    owner "root"
    group "root"
    mode "0644"
    variables :program => new_resource
    notifies :reload, resources("service[supervisor]")
  end

  s = service "supervisord_program_#{new_resource.name}" do
    start_command "supervisorctl start #{new_resource.name}"
    stop_command "supervisorctl stop #{new_resource.name}"
    restart_command "supervisorctl restart #{new_resource.name}"
    # status_command "supervisorctl status #{new_resource.name}"
  end
  new_resource.service(s)
end

[:start, :stop, :restart].each do |a|
  action a do
    new_resource.service.run_action(a)
  end
end
