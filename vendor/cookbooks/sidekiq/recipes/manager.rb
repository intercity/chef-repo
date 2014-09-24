template "/etc/init/sidekiq-manager.conf" do
  mode 0644
  source "manager.erb"
end

# # TODO: If is not running
# execute "start sidekiq manager" do
#   command "sudo start sidekiq-manager"
# end