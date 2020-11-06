The playbooks in these examples are setup to be run independently of any production environment. 

The playbook can be run in any order, however the examples are setup to flow as an example creating a two node cluster then adding a 
new third node presenting storage from the PowerMax or VMAX array.

There are multiple ways you can achieve these tasks this way is just one approach.  

Other approaches would be to implement some naming standards for your application, below is a simple variable declaration set that 
will prepend ansible to the start of the name and append a shorthand component type to the end of the name.

  vars:
    app_name: "{{ app_name }}"
    mv_name: "{{ 'Ansible_'+ app_name +'_MV' }}"
    portgroup_name: "{{ 'Ansible_'+ app_name +'_PG' }}"
    host_name: "{{ host_name }}"
    sg_name: "{{ 'Ansible_'+ app_name +'_SG' }}"
