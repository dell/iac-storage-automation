terraform {
  required_providers {
    powerflex = {
      version = "0.0.2" # Unreleased version, will be publicly available for >1.0.0
      source  = "dell/powerflex"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "powerflex" {
  username = "admin"
  password = ""
  endpoint = ""
  insecure = true
}
