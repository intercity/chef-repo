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

## Contributor Code of Conduct

As contributors and maintainers of this project, we pledge to respect all people who contribute through reporting issues, posting feature requests, updating documentation, submitting pull requests or patches, and other activities.

We are committed to making participation in this project a harassment-free experience for everyone, regardless of level of experience, gender, gender identity and expression, sexual orientation, disability, personal appearance, body size, race, age, or religion.

Examples of unacceptable behavior by participants include the use of sexual language or imagery, derogatory comments or personal attacks, trolling, public or private harassment, insults, or other unprofessional conduct.

Project maintainers have the right and responsibility to remove, edit, or reject comments, commits, code, wiki edits, issues, and other contributions that are not aligned to this Code of Conduct. Project maintainers who do not follow the Code of Conduct may be removed from the project team.

Instances of abusive, harassing, or otherwise unacceptable behavior may be reported by opening an issue or contacting one or more of the project maintainers.

This Code of Conduct is adapted from the [Contributor Covenant](http://contributor-covenant.org), version 1.0.0, available at [http://contributor-covenant.org/version/1/0/0/](http://contributor-covenant.org/version/1/0/0/)
