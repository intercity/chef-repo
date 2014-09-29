sysadmins Cookbook
==================

Creates sysadmin accounts: accounts that can access the server over SSH.

Attributes
----------
TODO: List your cookbook attributes here.

e.g.
#### sysadmins::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['sysadmins']</tt></td>
    <td>Array</td>
    <td>A list of user objects</td>
    <td><tt>empty, won't create sysadmins</tt></td>
  </tr>
</table>

Usage
-----

Add sysadmins to your node configuration:

```@json
{
  "username": "bofh",
  "password": "$1$d...HgH0",
  "ssh_keys": [
    "ssh-rsa AAA123...xyz== foo",
    "ssh-rsa AAA456...uvw== bar"
  ]
}
```
