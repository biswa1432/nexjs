variable "sql_server_name" {
  type = string
}
variable "location" {
  type = string
}

variable "elastic_pool_name" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "sql_admin_login" {
  type = string
  sensitive   = true
}

variable "sql_admin_password" {
  type = string
  default = "taw!mbu-RBP8cvx6vga"
  sensitive   = true
}

variable "primary_blob_endpoint" {
  type = string
  sensitive   = true
}

variable "primary_access_key" {
  type = string
  sensitive   = true
}

variable "aks_subnet_id" {
  type = string
}

variable "additional_sql_tags" {
  default     = {}
  description = "Additional sql tags"
  type        = map(string)
}

variable "additional_tags" {
  default     = {}
  description = "Additional tags"
  type        = map(string)
}

