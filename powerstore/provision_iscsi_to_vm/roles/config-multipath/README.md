config-multipath
=========

This role installs the pre-requisites and configure the multipath.conf on the hosts.

Requirements
------------

The pre-requisite packages are in the prereq.yml file.

For RedHat/Centos
* device-mapper-multipath

For Ubuntu
* multipath-tools
* multipath-tools-boot

Role Variables
--------------

None

Dependencies
------------

A sample multipath.conf template is provided under { role_path }/files/multpath.conf. Users should review and modify the configuration based on their requirements.

Please ensure that the template { role_path }/files/multipath.conf has all your configuration. The playbook will replace the target system's multipath.conf with the template.

Example Playbook
----------------
```
- hosts: all
  roles: 
    - role: cofigure-multipath
```

    
