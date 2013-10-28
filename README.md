Readme
======

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

The Chef recipes in this repository are meant to set up servers with a bare
**Ubuntu 12.04(.1) LTS (Precise Pangolin)** installation and that you have a user
with sudo access and a SSH Server installed.

## Getting started

### Server prerequisites

Your server has:

* Ubuntu 12.04(.1) LTS is installed.

### Installation

Clone the repository onto your own workstation. I am using ```firmhouse_chef_repo``` as
destination folder as an example.

```sh
git clone git://github.com/firmhouse/locomotive-chef-repo.git firmhouse_chef_repo
```

And initialize submodules which will fetch:

```sh
git submodule init
git submodule update
```

Run bundler to install chef and knife solo:

```sh
bundle
```

### Setting up the server

First, bootstrap your server with a Chef client by using the following command
with the username and password your VPS/server vendor provided:

This command will log in and prepare your server to run the Chef cookbooks.

```sh
bundle exec knife solo prepare <your user>@<your host/ip>
```

This command will also create a **json** file with your hostname under the `nodes/`
directory. This is the file that is used to specify specific settings per
server.

First, replace the entire contents of `nodes/your_host.json` with the contents of
`nodes/sample_host.json`

Then, replace the same configuration values in the json file with your own values.
You specifically need to modify:

* In the `authorization` section, replace `<your user>` with the user you prepared your server.
* In the `mysql` section replace the three `<random password>` with your desired MySQL passwords.
* In the `ssh_deploy_keys` section, copy the contents of your `~/.ssh/id_rsa.pub` file so your workstation is enabled to deploy with Capistrano.
* In the `active_applications` section, customize the sample `myapp` values with your own Rails application values.
* In the `active_applications\config` subsection, add your [Figaro](https://github.com/laserlemon/figaro) application configuration. All entries will be written out to `shared/config/application.yml`.
* In the `rbenv` section, enter the correct Ruby version that your app should use.

When your host configuration file is set up you run:

```sh
bundle exec knife solo cook <your user>@<your host/ip>
```

After this command runs successfully, you should be able to browse to the
domain name of your server and see a 503 Nginx error message. When the
command does not run succesfully, see if there are any errors in your host
configuration file, or file an issue on GitHub.

You see the Nginx error message because the above commands set up a bare deployment skeleton for your
application(s) and it is now time to deploy it using Capistrano. Read about this in the next section.

### Deploying your applications

The scripts in **Setting up your server** set up a bare deployment structure on your
server that you can use with Capistrano. The deployment structure for your
apps look like:

```
/u/apps/your_app
  current/
  releases/
  shared/
    config/
      application.yml
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
load 'deploy/assets'
load 'config/deploy'
```

Finally, you can run one of the folllowing commands to deploy your application:

```sh
cap deploy
```

And you are deployed!

## If you need help

The following steps will let you **set up or test your own Rails infrastructure
in 5 - 10 minutes**. If something doesn't work or you need more instructions:

**Please!** [Open an issue](https://github.com/firmhouse/locomotive-chef-repo/issues) or email [michiel@firmhouse.com](mailto:michiel@firmhouse.com).

## Resources and original authors

* Most of the cookbooks that are used in this repository are installed from the [Opscode Community Cookbooks](http://community.opscode.com).
* The `rails` and `bluepill` configuration is based off the cookbooks by [jsierles](https://github.com/jsierles) at https://github.com/jsierles/chef_cookbooks
