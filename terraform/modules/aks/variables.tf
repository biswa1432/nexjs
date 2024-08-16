#Common Variables
variable "rg_name" {
  type = string
  description = "Resource Group Name"
}

variable "node_resource_group" {
  type = string
  description = "Node Resource Group Name"
}

variable "location" {
  type = string
  default = "eastus"
  description = "Location where the resources will be deployed"
}

variable "acr_name" {
  type        = string
  description = "Name of the Azure Container Registry"
}

variable "workspace_name" {
  type = string
  description = "Name of the Log Analytics workspace that will be used to monitor this AKS instance"
}

variable "aks_name" {
  type = string
  description = "Name of this AKS instance"
}

variable "dns_prefix" {
  type = string
  description = "Prefix of this DNS instance"
}


variable "appgw_name" {
  type = string

}
variable "appgw_subnet_id" {
  type = string
}
variable "subnet_id" {
  type = string
}


variable "vm_user_name" {
    description = "User name for the VM"
    default     = "azureuser"
}

variable "public_ssh_key_path" {
    description = "Public key path for SSH."
    default     = ".ssh/id_rsa.pub"
}


variable "windows_username" {
  type = string
  default = "azureuser"
}

variable "windows_password" {
  type = string
  default = "Password!12345"
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

variable "windows_os_disk_size_gb" {
  type    = number
  default = 128

}

variable "additional_aks_tags" {
  default     = {}
  description = "Additional aks tags"
  type        = map(string)
}

variable "additional_tags" {
  default     = {}
  description = "Additional tags"
  type        = map(string)
}

variable "linux_pool" {
  description = "Linux Pool Name"
  type        = string
}

variable "windows_pool" {
  description = "Windows Pool Name"
  type        = string
}