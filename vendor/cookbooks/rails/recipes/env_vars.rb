applications_root = node[:rails][:applications_root]

if node[:active_applications]
  node[:active_applications].each do |app, app_info|

    deploy_user = app_info['deploy_user'] || "deploy"
    env_vars = app_info["env_vars"] || {}
    template "#{applications_root}/#{app}/shared/.rbenv-vars" do
      source "app_env_vars.erb"
      mode 0600
      owner deploy_user
      group deploy_user
      variables(env_vars: env_vars)
    end
  end
end
