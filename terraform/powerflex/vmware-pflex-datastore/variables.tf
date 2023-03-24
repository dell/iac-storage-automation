variable "tf201_pflex_pd" {
  type        = string
  description = "PowerFlex protection domain"
  default = "pd1"
}
variable "tf201_pflex_sp" {
  type        = string
  description = "PowerFlex storage pool to work on"
  default = "sp1"
}

variable "tf201_pflex_sdc_vmw" {
  type        = string
  description = "PowerFlex SDC with ESXi mapping"
  default = "ESXi01"
}

