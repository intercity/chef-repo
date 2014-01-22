Intercity Chef Recipes
======================

This Chef repository aims at being the easiest way set up and configure your own Rails server
to host one or more Ruby on Rails applications using best
practices from our community.

The configuration is heavily inspired by blog posts and chef recipes
from [37signals](http://37signals.com) and the
[Opscode Community Cookbooks](http://community.opscode.com).

## Features

Takes care of automatic installation and configuration of the following software
on a single server or multiple servers:

* nginx webserver
* Unicorn for running Ruby on Rails
* Zero-downtime deploys
* Multiple apps on one server
* Database creation and password generation
* Easy SSL configuration
* Deployment with Capistrano

## Getting started

The following paragraphs will guide you to set up your own server to host Ruby on Rails applications. **Note:** There's also a great guide on the website for [using these recipes with Digital Ocean](http://www.intercityup.com/guides/rails-chef-digitalocean).

### Server prerequisites

Your server has:

* A version of Ubuntu 12.04 LTS. The latest version is Ubuntu 12.04.3 LTS.

### Installation

Clone the repository onto your own workstation.

```sh
git clone git://github.com/intercity/chef-repo.git chef_repo
```

Run bundle:

```sh
bundle install
```

### Setting up the server

Prepare the server with `knife solo`. This installs Chef on the server.

```sh
bundle exec knife solo prepare <your user>@<your host/ip>
```

This will create `nodes/<your server>.json`. Copy the contents from `nodes/sample_host.json` into
your host json file.

In the file, replace the samples between `< >` with the values for your server and applications.

Then, install everything to run Rails apps on your server with the next command. You might need to enter your password a couple of times.

```sh
bundle exec knife solo cook <your user>@<your host/ip>
```

### Deploying your applications

Applications are deployed using capistrano. You can find a sample application to be deployed using these recipes here: [https://github.com/intercity/intercity_sample_app](https://github.com/intercity/intercity_sample_app).

In short you need to do the following:

- Ensure you have a rbenv .ruby-version in your application, specifying the version to use.
- Add Capistrano and Unicorn to your Gemfile.
- Generate the `unicorn` binstub so your server can start your application.

So let's get started.

The two commands in the previous section prepare your apps to be deployed with
Capistrano.

The folder structure for each app on your server looks like:

```
/u/apps/your_app
  current/
  releases/
  shared/
    config/
      database.yml
      unicorn.rb
    pids/
    log/
    sockets/
```

Ensure that you have a `.ruby-version` in your application. If you do not have it you
can set it using rbenv like this:

```ruby
rbenv local <YOUR-RUBY-VERSION>
```

Add the Unicorn and Capistrano gems to your Gemfile:

```ruby
# your other gems..

gem 'unicorn'
gem 'capistrano', '~> 2.15.5'
```

Run, bundle to install the new gems.

```ruby
bundle
```

Generate the `unicorn` binstub so you can start Unicorn on your server and commit it.

```ruby
bundle binstub unicorn
git commit -am 'Added Unicorn'
git push
```

Then generate configuration files for Capistrano.

```sh
bundle exec capify .
```

This command will generate `Capfile` and `config/deploy.rb`

Open `Capfile` and change it to:

```ruby
load 'deploy'
load 'deploy/assets'
load 'config/deploy'
```

Open `config/deploy.rb` and change it to look like the sample below, and change te settings for your application, repository and server:

```ruby
require 'bundler/capistrano'

default_run_options[:pty] = true
set :default_environment, {
  "PATH" => "/opt/rbenv/shims:/opt/rbenv/bin:$PATH"
}
set :ssh_options, { :forward_agent => true }

set :application, "intercity_sample_app"
set :repository, "git@github.com:intercity/intercity_sample_app.git"
set :user, "deploy"
set :use_sudo, false

server "<your server>", :web, :app, :db, :primary => true

after "deploy:finalize_update", "symlink:all"

namespace :symlink do
  task :db do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  task :all do
    symlink.db
  end
end

namespace :deploy do

  task :start do
    run "#{current_path}/bin/unicorn -Dc #{shared_path}/config/unicorn.rb -E #{rails_env} #{current_path}/config.ru"
  end

  task :restart do
    run "kill -USR2 $(cat #{shared_path}/pids/unicorn.pid)"
  end

end

after "deploy:restart", "deploy:cleanup"
```

Run this command to check if everything is set up correctly on your server and in your Capistrano configuration:

```sh
bundle exec cap deploy:check
```

Then run this command for your first deploy:

```sh
bundle exec cap deploy:cold
```

This will deploy your app, run your database migrations and start Unicorn. For subsequent deploys, use:

```sh
bundle exec cap deploy
```

or

```sh
bundle exec cap deploy:migrations
```

if you made changes to your database schema.

## Getting help

The following steps will let you **set up or test your own Rails infrastructure
in 5 - 10 minutes**. If something doesn't work or you need more instructions:

**Please!** [Open an issue](https://github.com/firmhouse/locomotive-chef-repo/issues) or email [michiel@firmhouse.com](mailto:michiel@firmhouse.com).

## Resources and original authors

* Most of the cookbooks that are used in this repository are installed from the [Opscode Community Cookbooks](http://community.opscode.com).
* The `rails` and `bluepill` configuration is based off the cookbooks by [jsierles](https://github.com/jsierles) at https://github.com/jsierles/chef_cookbooks
