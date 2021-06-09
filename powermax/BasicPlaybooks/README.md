# Prerequisites for running Ansible Playbooks

ansible-galaxy collection install dellemc.powermax
pip3 install PyU4V
Unisphere for PowerMax 9.2
Ansible version 2.9 or higher

# Executing and Running Sample Playbooks

The playbooks in this directory are intended to be run in order, each will 
follow on from the previous and reset the environment to a tested state.

Variable Files are pre-configured however will need to be adapted to match 
your environment.  Please replace the values in vars/connection.yml, 
vars/credentials.yml and vars/host_storage_details.yml with your own 
variables.

#Notes on Permissions for Ansible Users on Unipshere for PowerMax: 
A valid Unsiphere user for the instance of Unisphere for Powermax used with 
ansible modules is required.

A privileged account is needed with admin or storage admin roles for 
any playbook that will create storage devices, mappings or SRDF 
configurations on all arrays in the configuration.  

If you are using the gather facts module monitor or 
performance monitor privileges on account will suffice.  

If using snapshot module to create snapshots only then local replication 
privileges on storage groups can be used. 

If using snapshot module to mount or restore a snapshot local replication and 
device management.

Variables are contained in the vars folder under Basic Playbooks direcory.

