Upgrading your server to newer versions of this repository
==========================================================

This guide provides steps to upgrade your server to newer versions of the cookbooks in this repository.

Upgrading from chef-repo 2.0.0 to 2.1.0
---------------------------------------

### Unicorn Stack: Clean up Bluepill

Running Unicorn from Bluepill was removed in this version. You will need to clean up older Bluepill processes and configuration files manually.

After updating your server with the most recent versions of these cookbooks by using the `knife cook` command follow the next steps:

On your server, quit all current Bluepill processes by running:

```
sudo /opt/chef/embedded/bin/bluepill quit
```

Then, remove the Bluepill configuration files from `/etc/bluepill`:

```
sudo rm /etc/bluepill/*
```