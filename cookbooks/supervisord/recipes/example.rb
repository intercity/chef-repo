include_recipe "supervisord"

cat = supervisord_program "cat" do
  command "cat"
  action [:supervise, :start]
end

ruby_block "start cat" do
  block do
    cat.run_action(:start)
  end
end

# template "/srv/project/django/local_settings.py" do
#   notifies :restart, "supervisord_program[django-appserver]"
# end
