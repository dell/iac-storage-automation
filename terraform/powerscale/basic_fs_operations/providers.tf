terraform {
  required_providers {
    powerscale = { 
      version = "1.1.0"
      source = "registry.terraform.io/dell/powerscale"
    }
  }
}

provider "powerscale" {
  username = ""
  password = ""
  endpoint = "https://192.168.1.20:8080"
  insecure = true
}
