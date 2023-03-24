# AWS
variable "region" {
  type        = string
  description = "AWS Region"
}
variable "security_group" {}

variable "ssh_pub_key" {
  type        = string
  description = "Name of the Key pair in AWS"
}

variable "ssh_local_priv_key" {
  type        = string
  description = "Location of private key to authenticate ; must be read with file()"
}

variable "default_subnet" {}

variable "instance_type" {
  type        = string
  description = "AWS Instance type : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#instance_type"
  default     = "t3.micro"
}
variable "rhel_ami_id" {
  type        = string
  description = "Image with SDC package available under /var/tmp"
}

variable "sdc_rpm" {
  type        = string
  description = "Location of the SDC rpm to be installed"
}


# PowerFlex
variable "pflex_default_pool" {
  type        = string
  description = "Default PowerFlex Pool ID to work on"
}

variable "pflex_protection_domain" {
  type        = string
  description = "Default PowerFlex Protection Domain to work on"
}

variable "pflex_mdms" {
  type        = string
  description = "Internal IP adresses to access the PowerFlex (CSV)"
}