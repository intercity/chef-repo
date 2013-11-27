#require 'config/recipes/bluepill.rb'

set :application, 'myApp'
set :repo_url, 'git@aliencom.beanstalkapp.com:/aliencom/captest.git'

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.0.0-p353'

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/u/apps/#{fetch(:application)}_#{fetch(:stage)}'

set :scm, :git

set :format, :pretty
# set :log_level, :debug
set :pty, true

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

set :bluepill_id, "#{fetch(:application)}_#{fetch(:stage)}"

namespace :deploy do

  
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      sudo "bluepill #{fetch(:bluepill_id)} restart"
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      # top.bluepill.restart
    end
  end

  after :restart, :clear_cache do
    # on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    # end
  end

  task :stop do
    on roles(:app) do
      sudo "bluepill #{fetch(:bluepill_id)} stop"
    end
  end
  task :start do
    on roles(:app) do
      sudo "bluepill load /etc/bluepill/#{fetch(:bluepill_id)}.pill"
    end
  end
  task :status do
    on roles(:app) do
      sudo "bluepill #{fetch(:bluepill_id)} status"
    end
  end

  after :finishing, 'deploy:cleanup'

end


