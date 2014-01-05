package "supervisor"            # FIXME: work with custom debian package

service "supervisor" do
  reload_command "supervisorctl update"
end
