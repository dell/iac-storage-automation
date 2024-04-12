
variable "provider_type" {
  description = "The type of provider to be used. Default is local"
  default     = "local"
}

variable "access_zone_system" {
  description = "The access zone to be used. Default is System"
  default     = "System"
}


# variable for a filesystem name
variable "filesystem_name" {
  description = "The name of the filesystem to be created"
  default     = "terraform_test"
}
