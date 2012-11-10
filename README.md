Setting up a Rails server
=========================

This Chef repository lets you easily set up and configure your own Rails server
to host single or multiple Ruby on Rails applications using best
practices from the community. 

The configuration is heavily inspired by blog posts and chef recipes
from [37signals](http://37signals.com) and other community resources. It takes 
care of automatic installation and configuration of the following software 
on a single server or multiple servers:

* Nginx as webserver
* Unicorn as the Rails application server (with rolling restarts)
* App deployment with Capistrano

The Chef recipes in this repository are meant to set up servers with a bare
**Ubuntu 12.04 LTS (Precise Pangolin)** installation and that you have a user
with sudo access and a SSH Server installed.

### Installation

Clone the repository onto your own workstation. I am using ```infrastructure``` as
destination folder as an example.

```sh
git clone git://github.com/firmhouse/locomotive-chef-repo.git infrastructure
```

Install capistrano

```sh
gem install capistrano
```

### Getting started (Capistrano)

In the local checkout of this repository, copy `config/servers.rb.sample` to 
`config/servers.rb` and define your applications and deploy keys in this file.

Bootstrap your configured server(s)

```sh
cap chef:bootstrap
```

Upload the Chef cookbooks and node configurations:

```sh
cap chef:update
```

Almost done. It's time to actually install and configure your server:

```
cap chef:apply
```

After this command runs successfully, you should be able to browse to the
domain name of your server and see a 50x Nginx error message. This is because 
running the above commands have set up a bare deployment skeleton for your
application(s) and it is now time to deploy it using Capistrano. Read about 
this in the next section.

### Testing locally with Vagrant

Add the Ubuntu 12.04 basebox to your Vagrant:

```sh
vagrant box add presice64 http://files.vagrantup.com/precise64.box
```

Go into the `vagrant/` folder in your local checkout of this repository and
copy the `Vagrantfile.sample` file to `Vagrantfile` and set the chef solo
attributes.

Then run:

```sh
vagrant up
```

And the Vagrant server should boot and these recipes should run on your
Vagrant instance.

If you want to debug something in the cookbooks or modify the node attributes
you can run:

```sh
vagrant provision
```

This will only run the chef recipes instead of re-creating the whole VM.

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
    pids/
    log/
    sockets/
  config/
    unicorn.rb
```

First, copy the ```examples/deploy.rb``` file from this repository into 
```config/deploy.rb``` in your Capified Rails project and modify it
so the servers lines point to the server(s) you just set up.

Finally:

```sh
cap deploy
```

And you are deployed!