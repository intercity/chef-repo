Easy Rails server configuration with Locomotive
===============================================

This Chef repository lets you easily set up and configure Rails server
to host single or multiple Ruby on Rails applications using best
practices from the community.

The configuration is heavily inspired by blog posts and chef recipes
from [37Signals](http://37signals.com) and other community resources.

It takes care of automatic installation and configuration of
the following software on a single server or multiple servers:

* Nginx as webserver
* Unicorn as the Rails application server (with rolling restarts)
* App deployment with Capistrano

The only requirement is that you have a bare *Ubuntu 12.04 LTS (Precise Pangolin)*
installation with a user that has sudo access. 

You can get such a server on any respactable Virtual Private Server vendor 
and on Amazon Web Services.

Getting started
===============

First, clone this repository to your workstation.

Then, you define information about which Rails applications to run on
the server by creating a ```config/servers.rb``` file based on the provided
example in ```config/servers.rb.sample``.

After booting or installing an Ubuntu 12.04 LTS server, run the following
command to bootstrap a Ruby 1.9.3 and Chef installation:

```sh
cap chef:bootstrap
```

Next, you upload and prepare all required configuration to your server(s) using:

```sh
cap chef:update
```

Awesome. Almost done. Now it's time to actually apply
the configuration and install all software by running:

```
cap chef:apply
```

After this command runs successfully, you should be able to browse to the
domain name or ip-address of your server and see a 50x Nginx error message.

This is because the above capistrano tasks have set up a bare deployment
skeleton for our application(s) and it is now time to deploy it using
Capistrano.

Deploying your application
==========================

The scripts in Getting started set up a bare deployment structure on your
server that you can use with Capistrano.

First, copy the ```examples/deploy.rb``` file to ```config/deploy.rb``` in your
Rails project

Then, use your own server domain or ip-adress for the server definitions in the
```deploy.rb``` file.

Finally, run:

```cap deploy```

And you are deployed!