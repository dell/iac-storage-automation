
## vmware-powermax (beta)
Create a VMware datastore backed by a PowerMax LUN.

The terraform config in this folder will create a Masking View for an ESXi CLuster on the PowerMax array, the config then scans one of the ESXi hosts for new devices, and creates a datastore matching the WWN of the device created in the masking view.  The datastore is then visible to the VMware Cluster.

Note: This config assumes net new resources on the PowerMax array, if the host or port group already exists you will need to import the resoures, using terraform import commands.
