packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = ">= 2.0.0"
    }
  }
}

variable "base_sig_image_id" {
  type = string
  default = ""  
}

locals {
  version = "1.1.${formatdate("YYMM", timestamp())}"
}

source "azure-arm" "new-build" {
  use_azure_cli_auth = true

  location  = "eastus2"
  vm_size   = "Standard_B2ms"
  os_type   = "Linux"

  # Import the base image from the shared image gallery
  shared_image_gallery {
    id = var.base_sig_image_id
  }

  # Publish the new application image
  shared_image_gallery_destination {
    resource_group      = "rg-packer-lab"
    gallery_name        = "packerGallery"
    image_name          = "ubuntu-base"
    image_version       = local.version
    replication_regions = ["eastus2"]
  }

  temp_resource_group_name = "rg-packer-temp"
}

build {
  sources = ["source.azure-arm.new-build"]

  provisioner "shell" {
    script = "scripts/update-base.sh"
  }
}