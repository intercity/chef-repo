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
* Passenger or Unicorn for running Ruby on Rails
* Multiple apps on one server
* Database creation and password generation
* Easy SSL configuration
* Deployment with Capistrano

## Supported Ubuntu versions

* Ubuntu 12.04 LTS
* Ubuntu 14.04 LTS

## Supported databases

* MySQL
* PostgreSQL

## Getting started

The following paragraphs will guide you to set up your own server to host Ruby on Rails applications.

### Installation

Clone the repository onto your own workstation.

```sh
$ git clone git://github.com/intercity/chef-repo.git chef_repo
```

Run bundle:

```sh
$ bundle install
```

### Prepare all the cookbooks

```
$ bundle exec librarian-chef install
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

- Ensure you have a rbenv .ruby-version in your application which specifies the Ruby version to use.
- Add Capistrano to your applicationa's Gemfile.

So, let's get started.

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

Add the Capistrano gem to your Gemfile:

```ruby
# your other gems..

gem 'capistrano', '~> 3.1'
gem 'capistrano-rails', '~> 1.1'
```

And run bundle to install it:

```ruby
bundle
```

Now generate the configuration files for Capistrano:

```sh
bundle exec cap install
```

This command will generate `Capfile`, a `config/deploy.rb` and two files in a `config/deploy/` folder.

Edit `Capfile` and change it's contents to:

```ruby
# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

require 'capistrano/rails'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
```

Then open `config/deploy.rb` and change it to look like the sample below. Make sure to change te settings for your deploy directory and your repository Git URL:

```ruby
# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'your_application_name'
set :repo_url, '>> your git repo_url <<'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/u/apps/your_application_name_production'

# Use agent forwarding for SSH so you can deploy with the SSH key on your workstation.
set :ssh_options, {
  forward_agent: true
}

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
set :default_env, { path: "/opt/rbenv/shims:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

end
```

Then change the configuration in `config/deploy/production.rb` to:

```ruby
server '>> your server address <<', user: 'deploy', roles: %w{web app db}
```

Run this command to check if everything is set up correctly on your server and in your Capistrano configuration:

```sh
bundle exec cap production deploy:check
```

Then run this command for your first deploy:

```sh
bundle exec cap production deploy
```

This will deploy your app and run your database migrations if any.

**Congratulations!** You've now deployed your application. Browse to your application in your webbrowser and everything should work!

## Try before you buy (tm)

Experience how easy it will become to install your production servers with these chef recipes. You can try out these recipes on your local machine using Vagrant.

First, install Vagrant from http://vagrantup.com. And install the following two vagrant plugins:

```
vagrant plugin install vagrant-librarian-chef
vagrant plugin install vagrant-omnibus
```

Then go into the `vagrant/` directory and run

```
vagrant up mysql
```

This will start a local Ubuntu virtual machine and install it so you can deploy
Ruby on Rails applications that use MySQL as the database. Check out the chef json attributes in `vagrant/Vagrantfile` to customize the test environment.

## When you run into problems:

These steps should let you **set up or test your own Rails infrastructure
in 5 - 10 minutes**. If something doesn't work or you need more instructions:

**Please!** [Open an issue](https://github.com/intercity/chef-repo/issues) or email [hello@intercityup.com](mailto:hello@intercityup.com).

## Resources and original authors

* Most of the cookbooks that are used in this repository are installed from the [Opscode Community Cookbooks](http://community.opscode.com).
* The `rails` and `bluepill` configuration is based off the cookbooks by [jsierles](https://github.com/jsierles) at https://github.com/jsierles/chef_cookbooks
