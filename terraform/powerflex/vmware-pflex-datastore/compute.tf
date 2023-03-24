data "vsphere_datacenter" "datacenter" {
  name = "DataCenter"
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = "CLS01"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "main_esxi_host" {
  #name          = var.hosts.esxi[0]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "time_sleep" "wait_10_seconds" {
  depends_on = [powerflex_volume.pflex_volume]
  create_duration = "10s"
}

data "vsphere_vmfs_disks" "available" {
  depends_on     = [time_sleep.wait_10_seconds]
  host_system_id = data.vsphere_host.main_esxi_host.id
  rescan         = true
  filter         = "eui"
}

# The disk id is built of PowerFlex System ID + Volume ID
 resource "vsphere_vmfs_datastore" "pflex-datastore" {
  depends_on     = [data.vsphere_vmfs_disks.available]
  name           = "pflex-datastore"
  host_system_id = data.vsphere_host.main_esxi_host.id
  disks          = ["eui.${data.powerflex_sdc.get_pflex_sdc_with_vmw_mapping.sdcs[0].system_id}${resource.powerflex_volume.pflex_volume.id}"]
  
} 

