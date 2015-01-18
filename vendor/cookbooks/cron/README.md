Cron Cookbook
==================

Schedules tasks for apps. It simply adds entries to the root crontab
with commands that will be ran within the context of the app.

Attributes
----------

#### cron::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['cron']></td>
    <td>Hash</td>
    <td>key: identifier</td>
    <td><tt>empty, won't schedule tasks.</tt></td>
  </tr>
</table>

Usage
-----

Add cron to your node configuration:

```@json
{
"cron": {
  "sitemap": {
    "minute": 0,
    "hour": 5,
    "command": "rake -s sitemap:refresh"
  }
}
```
This runs the command `..... bundle exec rake -s sitemap:refresh` every
day at 5:00.

See the full list of available attributes at [the cron resource
documentation](http://docs.chef.io/resource_cron.html).

All attributes will be passed literarally from the node configuration
into the cron resource. With a few exceptions:

* Command will be prefixed with code so it runs within the app current dir.
* User defaults to the deploy\_user for the app ("deploy"). Be carefull when overriding.
