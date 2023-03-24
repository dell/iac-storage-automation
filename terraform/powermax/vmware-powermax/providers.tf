terraform {
  required_providers {
    powermax = {
      version = "1.0.0-beta"
      source  = "dell/powermax"
    }
    vsphere = {
      source = "hashicorp/vsphere"
    }
  }
}

# remove if you use local state file
terraform {
  backend "s3" {
    bucket = "terraform-paul"
    key = "terraform.tfstate"

    endpoint = "http://:9000"

    access_key=""
    secret_key=""

    region = "hop"
    skip_credentials_validation = true
    skip_metadata_api_check = true
    skip_region_validation = true
    force_path_style = true
  }
}

provider "vsphere" {
  user           = "administrator@vsphere.local"
  password       = ""
  vsphere_server = ""

  # if you have a self-signed cert
  allow_unverified_ssl = true
}

provider "powermax" {
  username      = "smc"
  password      = ""
  endpoint      = ""
  serial_number = "000000000000"
  insecure      = true
}