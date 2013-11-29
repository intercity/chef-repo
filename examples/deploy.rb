require "bundler/capistrano"
require "intercity/capistrano"

set :application, "intercity_sample_app_production"
set :repository,  "git@github.com:intercity/intercity_sample_app.git"

role :web, "beta.apphakker.nl"                          # Your HTTP server, Apache/etc
role :app, "beta.apphakker.nl"                          # This may be the same as your `Web` server
role :db,  "beta.apphakker.nl", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"