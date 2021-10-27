dellemc_powermax_provision_cluster
=========

Role to Deploy Storage for a cluster from PowerMax Array.  This role is 
designed to be idempotent.  This role can take a variable number of hosts 
and will provision and creates a masking view with single storage group and 
desired number and size of volumes specified in variables. 

Requirements
------------

PowerMax Ansible 

Role Variables
--------------
Variables required for these ansible roles are explained below, including value
types expected with example inputs.. Required Variables are included in 
defaults/main.yml file with commented out example values.  Users can impose 
their own naming conventions and pass required variables by other means at run 
time if required.   

    unispherehost: ip address or DNS name - str
    universion:version of unisphere server, check version supported by Ansible 
               Collection and supporting Python package - int
    verifycert: False - bool
    user: username of unipshere for powermax user -- str 
    password: password for Unisphere user, can also be passed at runtime by 
    extra variables or in file protected by ansible vault -- str
    serial_no: 12 digit serial of PowerMax or VMAX Storage Array -- int
    sg_name: name of storage group to be created or acted on -- str
    portgroup_name: name of port group to be created or used for the 
                    provisioning task
    ports: list of ports on powermax to present storage to host, 
           each list item must specify sub-elements director_id and port_id
           e.g
                ports:
                  - director_id: "FA-1D"
                    port_id: "4"
                  - director_id: "FA-2D"
                    port_id: "4"
    mv_name: name of masking view to be created or manipulated with role -- str
    hostgroup_name: name of host group/cluster -- str
    hosts: list of host_name and their initiators that will be added to the 
           cluster. List can contain one or more hosts. 
    host_name: name of host where volumes will be make accessible using 
               role if host doesn't exist it will be created by the role -- str
    initiators: string or list of WWNs belonging to host used in provisioning,
                16 digit wwn without colon : e.g. 21fd0037f8c83fa4 - list 
                or str
                e.g.
                    initiators:
                      - 20000024e500004f
                      - 21fd0047f8c83fa4
    hosts:
            hostgroup_name: "GG-Cluster"
            hosts:
              - host_name: "GG-cluster-1"
                initiators:
                  - 21fd1037f8c83fa4
                  - 21fd0127f8c83fa7
              - host_name: "GG-cluster-2"
                initiators:
                  - 20000009e500004f
                  - 20000009e400004a

    service_level: Diamond, Platinum, Gold, Silver, Bronze, or None
    srp: "SRP_1"
    volume_list: list of one or more storage volumes and descriptors 
                 describing storage to be provisioned.  
                 e.g volume_list:
                        - vol_name: "GG-prvsn1"
                          size: 1
                          cap_unit: "GB"
                        - vol_name: "GG-prvsn2"
                          size: 1
                          cap_unit: "GB"
                        - vol_name: "GG-prvsn3"
                          size: 1
                          cap_unit: "GB"
Dependencies
------------
- PyU4V Python Package
- dellemc.powermax Ansible collection Minimum version 1.3.0

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - name: Storage provisioning
      hosts: localhost
      connection: local
      gather_facts: no

      vars:
        - vars/deprovision_variables.yml
        - vars/credentials.yml

      tasks:
        - name: Create MV using host
          include_role:
            name: dellemc_powermax_provision_cluster

License
-------

Apache 2.0

Author Information
------------------
@rawstorage

