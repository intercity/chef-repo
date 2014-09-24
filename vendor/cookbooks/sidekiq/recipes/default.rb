template "/etc/init/sidekiq.conf" do
  mode 0644
  source "config.erb"
  variables application_root: node[:rails][:applications_root],
            deploy_user: 'deploy'
end

apps = node[:sidekiq][:apps] || {}
template "/etc/sidekiq.conf" do
  mode 0644
  source "enabled.erb"
  variables apps: apps,
            application_root: node[:rails][:applications_root]
end

include_recipe "sidekiq::manager"
