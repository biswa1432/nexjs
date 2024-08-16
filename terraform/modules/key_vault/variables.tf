variable "location" {
  type = string
}

variable "kv_name" {
  type = string
}
variable "rg_name" {
  type = string
}


variable "tenant_id" {
  type = string
}

variable "aks_sp_object_id" {
  type = string
}


variable "additional_kv_tags" {
  default     = {}
  description = "Additional kv tags"
  type        = map(string)
}

variable "additional_tags" {
  default     = {}
  description = "Additional tags"
  type        = map(string)
}
