variable "location" { 
    type = string
    description = "Azure region"
    default = null
}

variable "vm_size" { 
    type = string
    description = "VM size"
    default = null
}

variable "os_type" { 
    type = string
    description = "OS type (Linux/Windows)"
    default = null 
}
variable "image_publisher" { 
    type = string
    description = "Marketplace publisher"
    default = null 
}
variable "image_offer" { 
    type = string
    description = "Marketplace offer"
    default = null
}
variable "image_sku" { 
    type = string
    description = "Marketplace SKU"
    default = null
}
variable "resource_group_name" { 
    type = string
    description = "SIG RG"
    default = null
}
variable "gallery_name" { 
    type = string
    description = "SIG name"
    default = null
}
variable "image_name" { 
    type = string
    description = "SIG image name"
    default = null
}
variable "image_version" { 
    type = string
    description = "SIG image version"
    default = null
}
variable "temp_resource_group_name" { 
    type = string
    description = "Temp RG"
    default = null 
}

# NEW (required for Linux + shell provisioner)
variable "ssh_username" {
  type        = string
  description = "Linux user Packer will SSH in as"
  default     = null
}

# OPTIONAL: override to replicate beyond the build region
variable "replication_regions" {
  type        = list(string)
  description = "SIG replication regions"
  default     = []
}
