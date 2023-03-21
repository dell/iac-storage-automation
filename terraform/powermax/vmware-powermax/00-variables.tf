terraform {
  backend "s3" {
    bucket = "terraform-powermax"
    key = "terraform.tfstate"

    endpoint = "http://bucketipaddress:9000"

    access_key="iKt9MFbR1G0jnDDX"
    secret_key="D8randomaoh"

    region = "hop"
    skip_credentials_validation = true
    skip_metadata_api_check = true
    skip_region_validation = true
    force_path_style = true
  }
}

provider "vsphere" {
  user           = "administrator@vsphere.local"
  password       = "Don'tevertell"
  vsphere_server = "myvcenter.crk.lab.emc.com"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}

provider "powermax" {
  username      = "myuser"
  password      = "nunyabusiness"
  endpoint      = "https://unisherforpowermaxip:8443"
  serial_number = "000120200287"
  insecure      = true
}

variable "hosts" {
  description = "List of ESXi hosts connected to PowerMax"
  default = {
    esxi = ["dell52.crk.lab.emc.com", "dell55.crk.lab.emc.com", ]
    pmax = ["DELL52", "DELL55"]
  }

}

data "vsphere_datacenter" "datacenter" {
  name = "TME"
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = "Beta Cluster"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "main_esxi_host" {
  name          = var.hosts.esxi[0]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

output "all_cluster" {
  value = data.vsphere_compute_cluster.compute_cluster
}

output "hosts" {
  value = var.hosts
}
