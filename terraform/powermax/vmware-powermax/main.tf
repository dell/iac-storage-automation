# SDC names and VMware names are different so 
variable "hosts" {
  description = "List of ESXi hosts connected to PowerMax"
  default     = {
    esxi      = ["dell52.crk.lab.dell.com", "dell55.crk.lab.dell.com", ]
    pmax      = ["DELL52", "DELL55"]
  }
}

data "vsphere_datacenter" "datacenter" {
  name = "TME"
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = "Cluster"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "main_esxi_host" {
  name          = var.hosts.esxi[0]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# 1.0.0-beta implements `resource` only. Future version will replace that section with `data`
resource "powermax_storage_group" "tmevcenter_sg" {
  name          = "tmevcenter_sg"
  srpid         = "SRP_1"
  service_level = "Diamond"
}

resource "powermax_host_group" "CLUSTER" {
}

resource "powermax_volume" "volume_1" {
  name               = "vcenter_ds_by_terraform_volume_1"
  size               = 20
  cap_unit           = "GB"
  sg_name            = "tmevcenter_sg"
  enable_mobility_id = false
}

data "vsphere_vmfs_disks" "available" {
  host_system_id = data.vsphere_host.main_esxi_host.id
  rescan         = true
  filter         = "naa"
}

resource "vsphere_vmfs_datastore" "datastore" {
  name           = "terraform-test"
  host_system_id = data.vsphere_host.main_esxi_host.id
  # Use explicit LUN WWN
  disks = ["naa.${lower(powermax_volume.volume_1.wwn)}"]
}