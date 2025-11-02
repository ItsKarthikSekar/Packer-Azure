location = "eastus2"
vm_size  = "Standard_B2ms"
os_type  = "Linux"

image_publisher = "Canonical"
image_offer     = "ubuntu-24_04-lts"
image_sku       = "ubuntu-pro"

resource_group_name      = "rg-packer-lab"
gallery_name             = "packerGallery"
image_name               = "ubuntu-base"
image_version            = "1.0.0"
temp_resource_group_name = "rg-packer-temp"

ssh_username = "packer"
replication_regions = ["eastus2"]
