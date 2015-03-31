# Contributing guide

Awesome that you want to contribute! We really love it if people help us out!

## How to contribute

In short, fork it and clone it like any other project on github. Checkout a new branch and
send us a PR.

## Adding cookbooks

We use the standard chef way to add new cookbooks to this repo using knife. More
info on this [http://docs.opscode.com/knife_cookbook_site.html](http://docs.opscode.com/knife_cookbook_site.html)

The basic process is like this:

- Create and switch to a new branch.
- Make your changes.
- Test the cookbooks with the included `vagrant/` directory.
- Submit the PR.

Let's get started.

Make a new branch with a new descriptive name. For instance: add-docker-cookbooks.

```
git checkout -b add-docker-cookbooks
```

Then add the docker cookbook in the `Cheffile`:

```
site "http://community.opscode.com/api/v1"

# Community cookbooks
cookbook "mysql"
cookbook "apt"
...

cookbook "docker"
```

## Testing cookbooks

Then it's time to test your new cookbook or changes. You can do this with the supplied `vagrant/` directory.

So `cd` into this directory and start the machine

```
cd vagrant
vagrant up
```

## Add your change to the CHANGELOG

If your change is noteable, or might break other people's installations, please add an entry to the changelog.
The maintainers will make the final decission of the entry goes in the changelog or not, and to what version.
When you add something to the changelog, it might go in one of 4 categories: Added, Deprecated, Removed or Fixed.
