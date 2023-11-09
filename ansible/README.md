# Ansible Automation Examples for Dell EMC Storage Platforms
This repository contains Ansible automation code samples for storage platforms provided by TME, SA, and other Dell EMC internal teams.  The examples highlight the capabilities of the modules and their ability to be integrated into more complex playbooks, workflows, and applications.

Inside each of the platform directories the examples will be categorized by the major use case implemented.  This can include such categories as host provisioning, local/remote replication, portal integration, and end-to-end process integration.

**[PowerMax](powermax)**  
* Playbooks and roles for host and cluster provisioning  
* Playbooks for local and remote replication (SnapVX, SRDF)  
* Miscellaneous ad hoc playbooks  

**[Isilon/PowerScale](powerscale)**  
* Playbook for gathering array facts
* Playbooks for creating SMB shares and NFS exports
* Playbook with integration with AD users/groups for dynamic home directory share creation/removal
* Simple snapshot playbook

**[PowerStore](powerstore)**  
* Playbooks host block volume provisioning  
* Playbooks to create snapshot rules and protection policies
* Playbooks to create, extend, and remove filesystems and NFS exports
* Playbook for gathering array facts
* Playbooks demonstrate how to create protection policies, snapshot rules, iscsi volumes and provision to VMs

**[PowerFlex](powerflex)**  
* Testing playbooks(create, update, delete, idempotency) based on the functionality within each module 
* Playbook integrated with VMware guest and Ansible built-in modules to deploy multiple VMs, install SDC, and provision a volume to each

**[Unity](unity)**  
* Testing playbooks(create, update, delete, idempotency) based on the functionality within each module 

**[VPLEX](vplex)**  
* Basic playbooks to gather VPLEX summary and volume detail info
* Playbooks and roles to provision local virtual volumes from PowerMax or PowerStore backend arrays

**[ECS](ecs)**
* Playbooks to create resources using the buil-tin Ansible URI module directly to the ECS REST API
* Playbooks to create and delete buckets using the built-in Ansible aws_s3 module  

**[OME](ome)**
* OpenManage Enterprise (OME) is the management platform for Dell PowerEdge server infrastructure. Playbooks show different OME workflows like inventory management, template based deployment and compliance and remediation. 

## Documentation
Each example contains a readme file with instructions on prerequisites, installation, and usage.  Be sure to also review supported resource versions and follow installation instructions for the underlying modules used in the examples per their documentation.

## Support
The examples are provided as is with no warranties.  Some basic knowledge of the Red Hat Ansible Automation Platform and additional technology integration is expected.  Please enter an [issue](https://github.com/dell/ansible-storage-automation/issues) if you would like to report a defect.

For underlying Ansible modules setup, configuration issues, questions or feedback, join the [Dell EMC Automation community](https://www.dell.com/community/Automation/bd-p/Automation).  
For any Dell EMC storage issues, please contact Dell support at: https://www.dell.com/support.

## License
The code in this project repository is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

This software contains the intellectual property of Dell Inc. or is licensed to Dell Inc. from third parties. Use of this software and the intellectual property contained therein is expressly limited to the terms and conditions of the License Agreement under which it is provided by or on behalf of Dell Inc. or its subsidiaries.

Copyright © 2020 Dell Inc. or its subsidiaries.  All Rights Reserved.

