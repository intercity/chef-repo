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
* Configure ENV variables

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

### Setting up the server

Use the following command to install Chef on your server and prepare it to be installed by these cookbooks:

```sh
bundle exec knife solo prepare <your user>@<your host/ip>
```

This will create a file

```
nodes/<your host/ip>.json`
```

Now copy the the contents from the `nodes/sample_host.json` from this repository into this new file. Replace the sample values between `< >` with the values for your server and applications.

When this is done. Run the following command to start the full installation of your server:

```sh
bundle exec knife solo cook <your user>@<your host/ip>
```

### Deploying your application

You can deploy your applications with Capistrano.

Create a file named `.ruby-version` in your Rails project with the Ruby version you want your application ro un on:

```
echo "2.1.2" > .ruby-version
```

Add the Capistrano gem to your Gemfile:

```ruby
# your other gems..

gem 'capistrano', '~> 3.2.1'
gem 'capistrano-rails', '~> 1.1'
```

And run bundle to install it:

```ruby
bundle
```

Now generate configuration files for Capistrano:

```sh
bundle exec cap install
```

This command will generate the following files in your application:

```
Capfile
config/deploy.rb
config/deploy/production.rb
config/deploy/staging.rb
```

Edit the file `Capfile` and change it's contents to:

```ruby
# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

require 'capistrano/rails'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
```

Then edit `config/deploy.rb` and change it to the sample below.
Replace `>> your git repo_url <<` with the SSH clone URL of your repository:

```ruby
# config valid only for Capistrano 3.2.1
lock '3.2.1'

set :application, '>> your_application_name <<'
set :repo_url, '>> your git repo_url <<'

# Default branch is :master
# Uncomment the following line to have Capistrano ask which branch to deploy.
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Replace the sample value with the name of your application here:
set :deploy_to, '/u/apps/>> your_application_name <<_production'

# Use agent forwarding for SSH so you can deploy with the SSH key on your workstation.
set :ssh_options, {
  forward_agent: true
}

# Default value for :pty is false
set :pty, true

set :linked_files, %w{config/database.yml .rbenv-vars}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :default_env, { path: "/opt/rbenv/shims:$PATH" }

set :keep_releases, 5

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

Change the configuration in `config/deploy/production.rb` to the following sample.
Change `>> your server address <<` to the domain name or ip address of your server:

```ruby
server '>> your server address <<', user: 'deploy', roles: %w{web app db}
```

To verify that everything is set up correctly run:

```sh
bundle exec cap production deploy:check
```

Finally to deploy, run:

```sh
bundle exec cap production deploy
```

This will deploy your app and run your database migrations.

**Congratulations!** You've now deployed your application. Browse to your application in your webbrowser and everything should work!

## Try a server setup with Vagrant

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
