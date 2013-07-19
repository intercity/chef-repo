Setting up a Rails server
=========================

This Chef repository aims at being the easiest way set up and configure your own Rails server
to host one or more Ruby on Rails applications using best
practices from the community. **These recipes do not require a Chef server**

The configuration is heavily inspired by blog posts and chef recipes
from [37signals](http://37signals.com) and the
[Opscode Community Cookbooks](http://community.opscode.com). It takes
care of automatic installation and configuration of the following software
on a single server or multiple servers:

* Nginx as webserver
* Unicorn as the Rails application server (with rolling restarts)
* App deployment with Capistrano
* (optional) Haproxy for routing / load balancing to multiple app servers.

The Chef recipes in this repository are meant to set up servers with a bare
**Ubuntu 12.04 LTS (Precise Pangolin)** installation and that you have a user
with sudo access and a SSH Server installed.

## Getting started

### Server prerequisites

Your server has:

* Ubuntu 12.04 is installed.
* A user called **locomotive** with *sudo* rights.

If you did not create the locomotive user during the Ubuntu installation process (for
instance if your VPS vendor generates a password for you). Log in to your server as **root**
and do the following:

```
adduser locomotive
adduser locomotive admin
```

### Installation

Clone the repository onto your own workstation. I am using ```firmhouse_chef_repo``` as
destination folder as an example.

```sh
git clone git://github.com/firmhouse/locomotive-chef-repo.git firmhouse_chef_repo
```

Install capistrano

```sh
gem install capistrano
```

And initialize submodules:

```sh
git submodule init
git submodule update
```

### Setting up the server

In the local checkout of this repository, copy `config/servers.rb.sample` to
`config/servers.rb` and define your applications and deploy keys in this file.

```sh
cp config/servers.rb.sample config/servers.rb
```

and modify.

Bootstrap your configured server with a standard Chef installation. SSH into
your server and run this command:

```sh
curl -L https://www.opscode.com/chef/install.sh | sudo bash
```

Upload the Chef cookbooks and configuration to your server:

```sh
cap chef:update
```

Now it's time to actually install and configure your server:

```
cap chef:apply
```

After this command runs successfully, you should be able to browse to the
domain name of your server and see a 503 Nginx error message. This is because
running the above commands have set up a bare deployment skeleton for your
application(s) and it is now time to deploy it using Capistrano. Read about
this in the next section.

### Deploying your applications

The scripts in **Getting started** set up a bare deployment structure on your
server that you can use with Capistrano. The deployment structure for your
apps look like:

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

First, *capify* your application by running the following command in your application:

```sh
capify .
```

Then, copy the ```examples/deploy.rb``` file from this repository into
```config/deploy.rb``` in your Capified Rails project and modify it
so the servers lines point to the server you just set up.

You will want to uncomment the line about assets in the file `Capfile` in your
application. This makes sure compilation of the asset pipeline works. Your
Capfile should look like this:

```ruby
load 'deploy'
# Uncomment if you are using Rails' asset pipeline
load 'deploy/assets'
load 'config/deploy' # remove this line to skip loading any of the default tasks
```

Finally, you can run one of the folllowing commands to deploy your application:

```sh
cap deploy
or
cap deploy:migrations
```

And you are deployed! Optionally migrations will run if you used the second command.

## If you need help

The following steps will let you **set up or test your own Rails infrastructure
in 5 - 10 minutes**. If something doesn't work or you need more instructions:

**Please!** [Open an issue](https://github.com/firmhouse/locomotive-chef-repo/issues) or email [michiel@firmhouse.com](mailto:michiel@firmhouse.com).

## Resources and original authors

* Most of the cookbooks that are used in this repository are installed from the [Opscode Community Cookbooks](http://community.opscode.com).
* The `rails` and `bluepill` configuration is based off the cookbooks by [jsierles](https://github.com/jsierles) at https://github.com/jsierles/chef_cookbooks