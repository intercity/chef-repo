user "deploy" do
  comment "Deploy User"
  home "/home/deploy"
  shell "/bin/bash"

  supports(:manage_home => true )
end

group "deploy" do
  members ['deploy']
end

if node[:deploy_users]
  node[:deploy_users].each do |deploy_user|
    user deploy_user do
      comment "Deploy User #{deploy_user}"
      home "/home/#{deploy_user}"
      shell "/bin/bash"

      supports(:manage_home => true )
    end

    group deploy_user do
      members [deploy_user]
    end

  end
end

package "libffi-dev"

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"
include_recipe "rbenv::rbenv_vars"

include_recipe "rails::dependencies"
include_recipe "rails::ruby_binaries"
