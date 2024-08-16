#Common Variables

#Abbreviated Azure regions
variable "locations" {
  type = map(any)
  default = {
    "eastus"    = "use"
    "westus"    = "usw"
    "westus2"   = "usw2"
    "centralus" = "usc"
  }
}


variable "rg_name" {
  type = string
}


variable "location" {
  type        = string
  description = "Location where the resources will be deployed"
}


#Service Principal Variables
variable "sp_name" {
  type = string
}
variable "ap_name" {
  type = string
}

#Storage Account Variables
variable "storage_account_name" {
  type = string
}

#ACR Variables

variable "acr_name" {
  type = string
}

variable "sku" {
  type    = string
  default = "Premium"
}

variable "admin" {
  type    = string
  default = "true"
}

variable "additional_acr_tags" {
  default     = {}
  description = "Additional ACR tags"
  type        = map(string)
}
variable "additional_tags" {
  default     = {}
  description = "Additional ACR tags"
  type        = map(string)
}

#Virtual Networks variables
variable "aks_vnet_name" {
  type = string
}

variable "aks_subnet_name" {
  type = string
}

variable "aks_vnet_addr_space" {
  type = string
}

variable "aks_subnet_addr_space" {
  type = string
}

variable "appgw_subnet_name" {
  type = string
}

variable "appgw_subnet_addr_space" {
  type = string
}

#SQL Server password

variable "sql_server_name" {
  type = string
}
variable "elastic_pool_name" {
  type = string
}

variable "sql_admin_login" {
  type      = string
  sensitive = true
}


variable "kv_name" {
  type = string
}

#AKS Variables
variable "aks_name" {
  type = string

}

variable "node_resource_group" {
  type = string
}

variable "dns_prefix" {
  type = string

}

variable "workspace_name" {
  type = string

}


variable "linux_node_count" {
  type    = number
  default = 2

}

variable "linux_os_disk_size_gb" {
  type    = number
  default = 128

}
variable "linux_vm_size" {
  type    = string
  default = "Standard_D2_v2"
}

variable "windows_node_count" {
  type    = number
  default = 1

}
variable "windows_vm_size" {
  type    = string
  default = "Standard_D4_v3"
}

variable "windows_node_count2" {
  type    = number
  default = 1

}

variable "windows_vm_size2" {
  type    = string
  default = "Standard_D4_v3"
}


variable "windows_os_disk_size_gb" {
  type    = number
  default = 128

}

variable "additional_aks_tags" {
  default     = {}
  description = "Additional aks tags"
  type        = map(string)
}

variable "windows_username" {
  type = string
}

variable "vm_user_name" {
  type    = string
  default = "azureuser"
}

variable "appgw_name" {
  type = string

}

variable "linux_pool" {
  type = string
}

variable "windows_pool" {
  type = string
}