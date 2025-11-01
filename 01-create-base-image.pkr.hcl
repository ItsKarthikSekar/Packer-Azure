packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = ">= 2.0.0"
    }
  }
}

locals {
  temp_resource_group_name = "rg-packer-temp"
  image_version = "1.0.0"
}

source "azure-arm" "base" {
  use_azure_cli_auth = true

  location  = "eastus2"
  vm_size   = "Standard_B2ms"
  os_type   = "Linux"

  image_publisher = "Canonical"
  image_offer     = "ubuntu-24_04-lts"
  image_sku       = "ubuntu-pro"

  shared_image_gallery_destination {
    resource_group      = "rg-packer-lab"
    gallery_name        = "packerGallery"
    image_name          = "ubuntu-base"
    image_version       = local.image_version
    replication_regions = ["eastus2"]
  }

  temp_resource_group_name = local.temp_resource_group_name
}

build {
  sources = ["source.azure-arm.base"]

  provisioner "shell" {
    script = "scripts/create-base.sh"
  }
}