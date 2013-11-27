Capistrano 3 Setup Help
=======================

Capistrano 3 is still in early versions as of this writing.
Here is some help to get started.

## Bundle Requirements

You will need to include the following libs in your Gemfile

```ruby

	group :development do
	  #....

	  gem 'capistrano', '~> 3.0.1'
	  # The official capistrano-rbenv gem isn't currently working for capistrano 3
	  # gem 'capistrano-rbenv', '~>1.0.3'
	  # use this rbenv for capistrano >3 only
	  gem 'capistrano-rbenv', github: 'capistrano/rbenv'
	  gem 'capistrano-rails', '~> 1.1.0'

	end

```
## cap install

run 
```sh
cap install
```
to the create the default Capistrano deploy files :
Capfile
config/deploy.rb
config/deploy/production.rb
config/deploy/staging.rb


## Capfile Requirements

At the root of your rails projects you will find a Capfile
uncomment the following lines:

```ruby

 require 'capistrano/rbenv'
 require 'capistrano/bundler'
 require 'capistrano/rails/assets'
 require 'capistrano/rails/migrations'

````

## finally
See our example in this directory for how to edit.
