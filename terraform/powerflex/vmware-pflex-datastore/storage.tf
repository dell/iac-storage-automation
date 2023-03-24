data "powerflex_storage_pool" "get_pflex_sp"{
 storage_pool_names = [var.tf201_pflex_sp]
 protection_domain_name=var.tf201_pflex_pd
}

data "powerflex_sdc" "get_pflex_sdc_with_vmw_mapping" {
  name=var.tf201_pflex_sdc_vmw
}


resource "powerflex_volume" "pflex_volume" {
  name                   = "vm-datastore"
  size                   = 8
  storage_pool_name      = var.tf201_pflex_sp
  protection_domain_name = var.tf201_pflex_pd
  access_mode            = "ReadWrite"
  sdc_list = [
    {
      sdc_name    = var.tf201_pflex_sdc_vmw
      access_mode = "ReadWrite"
    }
  ]
}

output "volume_export"{
  value=powerflex_volume.pflex_volume
}

output "sys_id"{
  ##value=data.powerflex_sdc.get_pflex_sdc_with_vmw_mapping.sdcs[0].system_id
  value=["eui.${data.powerflex_sdc.get_pflex_sdc_with_vmw_mapping.sdcs[0].system_id}${resource.powerflex_volume.pflex_volume.id}"]
}
