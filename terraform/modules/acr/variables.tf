#Common Variables
variable "acr_name" {
  type        = string
  description = "Name of the Azure Container Registry"
}
variable "rg_name" {
  type        = string
  description = "Resource Group Name"
}
variable "location" {
  type        = string
  default     = "eastus"
  description = "Location where the resources will be deployed"
}

variable "sku" {
  type    = string
  default = "Premium"
}

variable "admin" {
  type    = string
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
