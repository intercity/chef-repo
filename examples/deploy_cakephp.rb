# Use this script in combination with: https://github.com/leehambley/railsless-deploy

set :application, 'example'
set :repository,  'git@github.com:user/example.git'
set :deploy_via, :remote_cache
set :scm, :git
set :scm_verbose, true
set :user, 'deploy'
set :use_sudo, false

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

# When using multitage make sure you have created files for these stages with a valid :deploy_to path

set :stages, %w(staging production)
set :default_stage, 'staging'

require 'capistrano/ext/multistage'
require 'pathname'

set :branch, ENV['BRANCH'] || 'master'

role :web, 'example.com'                          # Your HTTP server, Apache/etc
role :app, 'example.com'                          # This may be the same as your `Web` server

namespace :deploy do

  task :restart, :roles => :app do
    # do nothing
  end

  task :start, :roles => :app do
    # do nothing
  end

  task :stop, :roles => :app do
    # do nothing
  end

  desc "Overwrite :create_symlink to create relative paths for the chrooted environment"
  task :create_symlink, :except => { :no_release => true } do
    deploy_to_pathname = Pathname.new(deploy_to)

    on_rollback do
      if previous_release
        previous_release_pathname = Pathname.new(previous_release)
        relative_previous_release = previous_release_pathname.relative_path_from(deploy_to_pathname)

        run "#{try_sudo} rm -f #{current_path}; #{try_sudo} ln -s #{relative_previous_release} #{current_path}; true"
      else
        logger.important "no previous release to rollback to, rollback of symlink skipped"
      end
    end

    latest_release_pathname = Pathname.new(latest_release)
    relative_latest_release = latest_release_pathname.relative_path_from(deploy_to_pathname)
 
    run "#{try_sudo} rm -f #{current_path} && ln -s #{relative_latest_release} #{current_path}"
  end

  desc "Set symlinks to system files, and rebuild assets"
  task :finalize_update, :except => { :no_release => true } do
    run "cd #{latest_release}/app && ln -s ../../../../shared/config/database.php config/database.php"
    run "cd #{latest_release}/app && ln -s ../../../../shared/config/bootstrap.php config/bootstrap.php"

    # Use this if you want capistrano to run cake console tasks
    # run "chmod +x #{latest_release}/cake/console/cake"
  end
end

namespace :rollback do
  desc "Overwrite :revision to create relative paths for the chrooted environment"
  task :revision, :except => { :no_release => true } do
    deploy_to_pathname = Pathname.new(deploy_to)

    if previous_release
      previous_release_pathname = Pathname.new(previous_release)
      relative_previous_release = previous_release_pathname.relative_path_from(deploy_to_pathname)

      run "#{try_sudo} rm #{current_path}; #{try_sudo} ln -s #{relative_previous_release} #{current_path}"
    else
      abort "could not rollback the code because there is no prior release"
    end
  end
end

namespace :cakephp do
  desc "Custom tasks for deploying CakePHP"
  task :finalize do
    # This is an example of how you can create relative symlinks to a shared folder
    run "rm -rf #{latest_release}/app/webroot/img/uploads"
    run "cd #{deploy_to} && ln -s ../../../../../shared/system/uploads #{latest_release}/app/webroot/img/uploads"

    # Use this if you want to run cake commands from cron
    # run "chmod +x #{latest_release}/app/vendors/cakeshell"

    # Executes regeneration of compressing assets
    # run "#{latest_release}/cake/console/cake -app #{latest_release}/app asset_compress build_ini"
  end
end

after 'deploy:finalize_update', 'cakephp:finalize'
after 'cakephp:finalize', 'deploy:cleanup'