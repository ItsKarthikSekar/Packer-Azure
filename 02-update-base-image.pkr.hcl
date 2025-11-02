variable "base_sig_image_id" {
  type = string
  default = ""  
}

source "azure-arm" "update" {
  use_azure_cli_auth = true

  location  = var.location
  vm_size   = var.vm_size
  os_type   = var.os_type

  # Import the base image from the shared image gallery
  shared_image_gallery {
    id = var.base_sig_image_id
  }

  # Publish the new application image
  shared_image_gallery_destination {
    resource_group      = var.resource_group_name
    gallery_name        = var.gallery_name
    image_name          = var.image_name
    image_version       = var.image_version
    replication_regions = [var.location]
  }

  temp_resource_group_name = var.temp_resource_group_name
}

build {
  sources = ["source.azure-arm.update"]

  provisioner "shell" {
    script = "scripts/update-base.sh"
  }
}