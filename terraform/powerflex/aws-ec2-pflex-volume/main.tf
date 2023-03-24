resource "aws_instance" "rhel-w-powerflex-storage" {
  ami                         = var.rhel_ami_id
  instance_type               = var.instance_type
  key_name                    = var.ssh_pub_key
  associate_public_ip_address = true
  subnet_id                   = var.default_subnet
  vpc_security_group_ids = [var.security_group]
  root_block_device {
    volume_size = 20
  }
  # Install SDC to connect to PowerFlex
  user_data = <<-EOF
    #!/bin/bash
    export MDM_IP=${var.pflex_mdms}
    rpm -ivh ${var.sdc_rpm}
  EOF
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.ssh_local_priv_key)
    host        = aws_instance.rhel-w-powerflex-storage.public_ip
  }
  provisioner "remote-exec" {
    # Wait for the sdc to start before creating a volume
    inline = [
      "until [[ $(systemctl is-active scini) == 'active' ]]; do sleep 1; done",
      "echo 'Instance is fully initialized and in a running state.'"
    ]
  }
}

# get the SDC Id once the VM has been correctly deployed & SDC service started
data "powerflex_sdc" "all" {
  depends_on = [aws_instance.rhel-w-powerflex-storage]
}

# find my SDC ID
locals {
  matching_sdc = [for sdc in data.powerflex_sdc.all.sdcs : sdc if sdc.sdc_ip == aws_instance.rhel-w-powerflex-storage.private_ip]
}

resource "powerflex_volume" "rhel-scinia-1" {
  name                   = "rhel-scinia-1"
  size                   = 16
  storage_pool_name      = var.pflex_default_pool
  protection_domain_name = var.pflex_protection_domain
  access_mode            = "ReadWrite"
  sdc_list = [
    {
      sdc_id      = local.matching_sdc[0].id
      access_mode = "ReadWrite"
    }
  ]
}

output "display-all" {
  value = [
    data.powerflex_sdc.all,
    # local.matching_sdc,
    # local.matching_sdc[0].id
    # resource.aws_instance.rhel-w-powerflex-storage,
    # resource.powerflex_volume.rhel-scinia-1
  ]
}
