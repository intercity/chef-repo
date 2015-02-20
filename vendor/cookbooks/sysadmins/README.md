sysadmins Cookbook
==================

Creates sysadmin accounts: accounts that can access the server over SSH.

Attributes
----------

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
    <td>Hash</td>
    <td>key: username</td>
    <td><tt>empty, won't create sysadmins</tt></td>
  </tr>
</table>

Usage
-----

Add sysadmins to your node configuration:

```@json
{
"sysadmins": {
  "bofh": {
    "password": "$1$d...HgH0",
    "ssh_keys": [
      "ssh-rsa AAA123...xyz== foo",
      "ssh-rsa AAA456...uvw== bar"
    ]
  }
}
```

* Create a hashed password with `openssl passwd -1 'plaintextpassword'`.
  This password is needed for running `sudo`.
* SSH-keys should be the **public** key. You can leave them out, in
  which case you have to log in with the password.
