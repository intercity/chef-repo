# Contributing guide

Awesome that you want to contribute! We really love it if people help us out!

## How to contribute

In short, fork it and clone it like any other project on github. Checkout a new branch and
send us a PR.

## Adding cookbooks

We use the standard chef way to add new cookbooks to this repo using knife. More
info on this (http://docs.opscode.com/knife_cookbook_site.html)[http://docs.opscode.com/knife_cookbook_site.html]

The basic process is like this:

- Create and switch to a new branch.
- Install the cookbook using knife solo with the -b option.
- Test the cookbooks.
- Submit the PR.

Let's get started.

Make a new branch with a new descriptive name. For instance: add-docker-cookbooks.

```
git checkout -b add-docker-cookbooks
```

Then pull the docker cookbook in via 

```
knife cookbook site install COOKBOOK_NAME -b
```

The `-b` means that you want it in a currrent branch, and not in master which knife will do
by default otherwise.

## Testing cookbooks

Then it's time to test your cookbooks, so set up a vagrant machine. 
A sample machine is placed in the `./vagrant/` directory.

So `cd` into this directory and start the machine

```
cd vagrant
vagrant up
```

It will probably nag that it can't connect to the machine, but that's good cause we have a plain ubuntu install, and we don't have
chef or the vagrant guest additions installed. You should be able to ``vagrant ssh`` into it anyway, you can test that now if you want.

When it works, back out of the vagrant directory.

```
cd ..
```

Then it's time to prepare your vagrant machine for working with chef. So let's bootstrap chef using this command:

```
bundle exec knife solo prepare intercity@localhost -p 2222 -P intercity
```

When that's done you'll get a `nodes/localhost.json` file back. You can edit your runlist and add your data there in order to test it. 
Check the sample [nodes/sample_host.json](nodes/sample_host.json) if you need inspiration.

Then finally run 

``
bundle exec knife solo cook intercity@localhost -p 2222 -P intercity
``

To cook your server and install the chef recipes.