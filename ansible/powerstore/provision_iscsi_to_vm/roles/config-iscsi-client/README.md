config-iscsi-client
=========

This role installs and configures iSCSI initiator on the Linux hosts.

Requirements
------------

For RedHat/Centos
* iscsi-initiator-utils

For Ubuntu
* open-iscsi

Role Variables
------------

| Variable | Required | Default | Comments |
| -------- | -------- | ------- | -------- |
| iscsi_target | Yes | None | Set PowerStore Global Storage Discovery IP |

Examples
------------
Install pre-requisites, start iSCSI service, and configure iSCSI target

```yaml
- hosts: all
  roles:
    - role: config-iscsi-client
```
