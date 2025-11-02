
locals {
  sig_replication = length(var.replication_regions) > 0 ? var.replication_regions : [var.location]
}

source "azure-arm" "base" {
  use_azure_cli_auth = true

  location  = var.location
  vm_size   = var.vm_size
  os_type   = var.os_type

  image_publisher = var.image_publisher
  image_offer     = var.image_offer
  image_sku       = var.image_sku

  # Required for Linux provisioning via shell
  communicator = "ssh"
  ssh_username = var.ssh_username

  shared_image_gallery_destination {
    resource_group      = var.resource_group_name
    gallery_name        = var.gallery_name
    image_name          = var.image_name
    image_version       = var.image_version
    replication_regions = local.sig_replication
  }

  temp_resource_group_name = var.temp_resource_group_name
}

build {
  sources = ["source.azure-arm.base"]

  provisioner "shell" {
    script = "scripts/create-base.sh"
  }
}
