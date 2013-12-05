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
* Database creation
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

Run bundle to install chef and knife-solo:

```sh
bundle install
```

### Setting up the server

Prepare the server with `knife solo`. This installs Chef.

```sh
bundle exec knife solo prepare <your user>@<your host/ip>
```

This will create `nodes/<your host/ip>.json`. Copy the contents from `nodes/sample_host.json` into
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
- Add `intercity` gem to your gemfile.
- Generate the `unicorn` binstub so that bluepill can start your application.

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

Ensure that you are having a `.ruby-version` in your application, if you have not you
can set it using rbenv like this:

```ruby
rbenv local <YOUR-RUBY-VERSION>
```

Add the `intercity` gem to your `Gemfile`:

```ruby
# other gems..

gem 'intercity'
```

Run, bundle to install your gems

```ruby
bundle
```

Generate the `unicorn` binstub so we can start unicorn:

```ruby
bundle binstubs unicorn
```

This will create a `bin/unicorn` binstub that you need to check in into your repository:

Then generate the capistrano deployment files by using this command:


```sh
bundle exec capify .
```

Uncomment the

```ruby
load 'deploy/assets'
```

line in the generated `Capfile` so it looks like this:

```ruby
load 'deploy'
load 'deploy/assets'
load 'config/deploy'
```

(You can view it here in our sample repo: [Capfile](https://github.com/intercity/intercity_sample_app/blob/master/Capfile))

Open `config/deploy.rb` and set the `application` and `repository` settings. (Check it here in the sample repo [deploy.rb](https://github.com/intercity/intercity_sample_app/blob/master/config/deploy.rb) )
Run

```sh
bundle exec cap deploy:check
```

to see if everything is set up. And then

```sh
bundle exec cap deploy
```

to deploy your application!

## Getting help

The following steps will let you **set up or test your own Rails infrastructure
in 5 - 10 minutes**. If something doesn't work or you need more instructions:

**Please!** [Open an issue](https://github.com/firmhouse/locomotive-chef-repo/issues) or email [michiel@firmhouse.com](mailto:michiel@firmhouse.com).

## Resources and original authors

* Most of the cookbooks that are used in this repository are installed from the [Opscode Community Cookbooks](http://community.opscode.com).
* The `rails` and `bluepill` configuration is based off the cookbooks by [jsierles](https://github.com/jsierles) at https://github.com/jsierles/chef_cookbooks
