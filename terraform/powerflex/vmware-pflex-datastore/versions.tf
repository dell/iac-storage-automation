terraform {
  required_providers {
    powerflex = {
      version = "1.0.0"
      source  = "dell/powerflex"
    }
    vsphere = {
      source = "hashicorp/vsphere"
    }
  }
}

provider "powerflex" {
  username = "admin"
  password = ""
  endpoint = "https://192.168.0.11"
  insecure = true
}

provider "vsphere" {
  user     = "administrator@vsphere.local"
  password = ""
  #  vsphere_server = "vcsa.demo.local"
  vsphere_server = "192.168.1.3"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}
