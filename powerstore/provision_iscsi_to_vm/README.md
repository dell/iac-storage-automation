ansible-automation-examples
=========

Sample Ansible automation code samples for PowerStore provided by TME, SA, and other internal teams.

Playbooks
---------
The following playbooks can be run individually or combined into a larger playbook to handle more complex workflow.

### create_snapshotrules.yml

This playbook demonstrates how to call the `dellemc_powerstore_snapshotrule` module to create new PowerStore snapshot rules based on time interval or specific date and time. Please refer to [PowerStore Ansible Module Documentation](https://github.com/dell/ansible-powerstore/tree/master/dellemc_ansible/docs) for more details.

### create_protectionpolicies.yml

This playbook demonstrates how to call the `dellemc_powerstore_protectionpolicy` module to create new PowerStore protection policies that consist of snapshot rules. Please refer to [PowerStore Ansible Module Documentation](https://github.com/dell/ansible-powerstore/tree/master/dellemc_ansible/docs) for more details.

### new_vm_ps.yml

This playbook demonstrates how to call the `vmware_guest` module to create new VMware vms using template on PowerStore X appliance. Please refer to [vmware_guest Ansible documentation](https://docs.ansible.com/ansible/latest/modules/vmware_guest_module.html) for more details.

### config_os.yml

This playbook calls the following roles to customize the Linux OS environment.
* linux-system-role
* config-iscsi-client

### add_host_to_ps.yml

This playbook demonstrates how to call the `dellemc_powerstore_host` module to create a host object on PowerStore.Please refer to [PowerStore Ansible Module Documentation](https://github.com/dell/ansible-powerstore/tree/master/dellemc_ansible/docs) for more details.

### create_volumes.yml

This playbook demonstrates how to call `dellemc_powerstore_volume` module to create new volumes on PowerStore and map them to the hosts. Please refer to [PowerStore Ansible Module Documentation](https://github.com/dell/ansible-powerstore/tree/master/dellemc_ansible/docs) for more details.

### config_volumes_on_hosts.yml

This playbook demonstrates how to query PowerStore volume details with `dellemc_powerstore_volume` module, extract the volume's WWN information, and to locate the multipath device on the hosts using the extracted WWN information. File system is then created on the volume. Please refer to [PowerStore Ansible Module Documentation](https://github.com/dell/ansible-powerstore/tree/master/dellemc_ansible/docs) for more details.

### create_snapshots.yml

This playbook demonstrates how to call `dellemc_powerstore_snapshot` module to create volume snapshots on PowerStore. Please refer to [PowerStore Ansible Module Documentation](https://github.com/dell/ansible-powerstore/tree/master/dellemc_ansible/docs) for more details.

Requirements
------------

* Python 3.6 +
* Ansible 2.9 +
* Python modules
  * PyPowerStore
  * Pyvmomi (https://github.com/vmware/pyvmomi)
  * PyYAML
  * urllib3
  * chardet
  * requests
  * Jinja2

Role Variables
--------------

### Variable files
------------------
### host_inventory

| Variable | Default | Comment |
| -------- | ------- | ------- |
| `hostname` | `none` | List of hosts managed by Ansible. One line per host. |
| `mgmt_network_name` | `none` | The VM network name for the management network |
| `mgmt_netmask` | `none` | Netmask for the VM network |
| `mgmt_gateway` | `none` | Default gateway |
| `storage_network_name` | `none` | The VM storage network name for iSCSI |
| `storage netmask` | `none` | Netmask for the VM iSCSI network |
| `dns` | `none` | List of dns ips |
| `domain` | `none` | DNS domain |
| `dns_suffix` | `none` | DNS search suffix |


### ps_vars.yml

| Variable | Default | Comment |
| -------- | ------- | ------- |
| `array_ip` | `none` | IP address of the PowerStore Manager |
| `user` | admin | Administration user on PowerStore Manager |
| `password` | `none` | Admin user password |
| `verifycert` | False | Verify certificate |
| `protection_policies` | `none` | List of PowerStore protection policies |
| `protpolicy_name` | `none` | Name of the protection policy |
| `description` | `none` | Description of the protection policy |
| `snapshotrules` | `none` | List of PowerStore snapshot rules to include in the protection policy |
| `snapshot_rules` | `none` | List of PowerStore snapshot rules |
| `rulename` | `none` | Name of the snapshot rule |
| `snapint` | `none` | Snapshot interval |
| `days_of_weeks` | `none` | Days of week when snapshots should be taken |
| `time_of_day` | `none` | Time when snapshots should be taken |
| `retention` | `none` | Snapshot retention period |
| ` delete_snaps` | `none` | Whether old snapshots should be deleted |

### vcenter_vars.yml

| Variable | Default | Comment |
| -------- | ------- | ------- |
| `vcenter_hostname` | `none` | Name or IP of the vCenter |
| `vcenter_user` | `none` | Admin user on vCenter. e.g. administrator@vsphere.local |
| `vcenter_pass` | `none` | Admin user password |
| `dc` | `none` | Datacenter where the VMs will be created |
| `cluster_name` | `none` | Cluster name under the Datacenter |
| `datastore_name` | `none` | Datastore name |
| `vswitch` | `none` | Virtual switch name |
| `vmtemplate` | `none` | Name of the template to use for cloning |

### Host vars
-------------
### test-vm01.yml

| Variable | Default | Comment |
| -------- | ------- | ------- |
| `storage_protocol` | `none` | `fc` or `iscsi ` |
| `storage_ip` | `none` | iSCSI initiator IP address of the host |
| `iscsi_target` | `none` | PowerStore Global Storage Discovery IP. Can be found under Powerstore Manager->Settings->Networking-> Network IPs -> Storage -> Storage IPs |
| `os_type` | `none` | Used to configure host on PowerStore. See PowerStore documenation for supported OS types. |
| `disk_vendor` | `none` | Vendor name (`PowerStore`) that shows up on Linux SCSI device |
| `snapshot_name` | `none` | Name of the PowerStore volume snapshot |
| `snapshot_retention` | `none` | Number of snapshots to retent |
| `snapshot_retention_unit` | `none` | `days`, `hours` |
| `volumes`| `none` | A list of volumes to be created; In a cluster application environment, define the volumes only on one of the hosts. If the same volumes are defined in multiple host var files, it will encounter errors because PowerStore would try to create volumes that have already been created. |
| `volname` | `none` | Name of the volume on PowerStore |
| `vgname` | `none` | Name of the volume group on PowerStore |
| `volsize` | `none` | Size of the volume |
| `volcapunit` | `none` | Size unit, e.g. `MB`, `GB`, `TB` | 
| `voldesc` | `none` | Optional description of the volume |
| `volperfpol` | `none` | The performance policy of the volume |
| `protpolicy` | `none` | The protection policy name to add to the volume |
| `mount_path` | `none` | The file system path name |
| `fstype` | `none` | The file system type, e.g. xfs, ext4 |
| `mount_opts` | `none` | Additional mount options to the file system, e.g. noatime, _netdev |
| `map_volumes` | `none` | A list of volumes to map to the host |
| `volname` | `none` | Name of the volume to be mapped to the host |
| `storage_protocol` | `none` | Volume can be mapped via either `fc` or `iscsi`, provided that the host objects have been probably created beforehand |
| `network_interfaces` | `none` | A list of additional network interfaces to configure on the host. This typically is used on a bare metal host to configure a static ip iSCSI interface |
| `conn_name` | `none` | The name of the NetworkManager connection |
| `ifname` | `name` | The network interface name found on the host. e.g. `em1`, `eth1` |
| `type` | `none` | The interface type. e.g. `ethernet` |
| `ip4` | `none` | The static ip and netmask to assign to the interface. e.g. `10.10.10.10/16` |
| `state` | `none` | `present` to create the interface on the host; `absent` to remove the interface on the host. |

Dependencies
------------

| Playbook | Dependencies |
| -------- | ------------ |
| `create_snapshotrules.yml` | `ps_vars.yml`, `dellemc_powerstore_snapshotrule` |
| `create_protectionpolicies.yml` | `ps_vars.yml`, `dellemc_powerstore_protectionpolicy` |
| `create_vm_ps.yml` | `vcenter_vars.yml`, `vmware_guest`, host var files |
| `config_os.yml` | `linux-system-role` role, `config-iscsi-client` role, host var files |
| `add_host_to_ps.yml` | `ps_vars.yml`, `dellemc_powerstore_host`, host var files |
| `create_volumes.yml` | `ps_vars.yml`, `dellemc_powerstore_volume`, host var files |
| `config_volumes_on_hosts.yml` | `ps_vars.yml`, `dellemc_powerstore_volume`, host var files |
| `create_snapshots.yml` | `ps_vars.yml`, `dellemc_powerstore_snapshot`, host var files |

Example Playbook
----------------

### Create snapshot rules and protection policies on PowerStore

```
- import_playbook: create_snapshotrules.yml
  tags: create_snapshot_rules

- import_playbook: create_protectionpolicies.yml
  tags: create_protection_policies
```

### Create new vms on PowerStore, configure the vms with iSCSI volumes on PowerStore, configure multipath and create file systems on PowerStore volumes.

```
- import_playbook: new_vm_ps.yml
  tags: create_vms

- import_playbook: config_os.yml
  tags: config_vms

- import_playbook: add_host_to_ps.yml
  tags: add_hosts

- import_playbook: create_volumes.yml
  tags: create_map_volumes

- import_playbook: config_volumes_on_hosts.yml
  tags: config_volumes_hosts
 ```
 
 ### Create volume snapshots on PowerStore volumes
 
 ```
 - import_playbook: create_snapshots.yml
   tags: create_snapshots
  ```

