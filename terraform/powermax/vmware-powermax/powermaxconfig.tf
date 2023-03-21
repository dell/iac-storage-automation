# Terraform config for creating PowerMax volume and presenting to VMware Host Dell52 as a Datastore

resource "powermax_storage_group" "terraform_sg" {
  name          = "terraform_sg"
  srpid         = "SRP_1"
  service_level = "Diamond"
}

resource "powermax_host" "DELL52" {
  name       = "DELL52"
  initiators = [
              "100000109b56a004",
              "100000109b56a007"]
  host_flags = {}
}

resource "powermax_port_group" "terraform_pg" {
  name     = "terraform_pg"
  protocol = "SCSI_FC"
  ports = [
    {
      director_id = "OR-1C"
      port_id     = "0"
    },
    {
      director_id = "OR-2C"
      port_id     = "0"
    },
    {
      director_id = "OR-2C"
      port_id     = "1"
    },
    {
      director_id = "OR-2C"
      port_id     = "1"
    }
  ]
}

resource "powermax_volume" "volume_1" {
  name               = "terraform_datastore"
  size               = 20
  cap_unit           = "GB"
  sg_name            = "terraform_sg"
  enable_mobility_id = false
}

resource "powermax_masking_view" "terraform_mv" {
  name           ="terraform_mv"
  storage_group_id = powermax_storage_group.terraform_sg.id
  port_group_id = powermax_port_group.terraform_pg.id
  host_id = powermax_host.DELL52.id
}


data "vsphere_vmfs_disks" "available" {
  depends_on = [powermax_volume.volume_1]
  host_system_id = data.vsphere_host.main_esxi_host.id
  rescan         = true
  filter         = "naa"
}

resource "vsphere_vmfs_datastore" "datastore" {
  depends_on = [data.vsphere_vmfs_disks.available]
  name           = "terraform-datastore"
  host_system_id = data.vsphere_host.main_esxi_host.id

  disks = ["naa.${lower(powermax_volume.volume_1.wwn)}"]
}
