linux-system-role
=========

This role installs a list of syste packages, utilities, and configurations for Linux hosts. A Centos yaml file is provided as example for the different tasks that can be handled by this role. For other Linux OSes, users can create a corresponding OS yaml file under the { role_path }/tasks directory.

Requirements
------------

### ericsysmin.chrony role
The configuration of the time server is done by calling the ericsysmin.chrony role. Users can download the chrony role from Ansible Galaxy and install it in the < role_path >.


Role Variables
--------------

| Variable | Required | Default | Comments |
| -------- | -------- | ------- | --------- |
| `swap_file_path` | Yes | `none` | Set OS swap file location |
| ssh key | No | `none` | Replace the user's public key in add-ssh-public-keys.yml |

Dependencies
------------

### setup-centos.yml
Currently, the role only works on CentOS hosts. Additional OS type can be added by creating a setup-<OS>.yml file under the { role_path }/tasks directory.
    

Example Playbook
----------------

```yaml
- hosts: servers
    roles:
      - role: linux-system-role
```
