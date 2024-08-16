locals {
  sql_server_name       = var.sql_server_name
  elastic_pool_name     = var.elastic_pool_name
  sql_admin_login       = var.sql_admin_login
  sql_admin_password    = var.sql_admin_password
  location              = var.location
  rg_name               = var.rg_name
  primary_blob_endpoint = var.primary_blob_endpoint
  primary_access_key    = var.primary_access_key
  aks_subnet_id         = var.aks_subnet_id

}
resource "azurerm_mssql_server" "sql_server" {

  name                         = local.sql_server_name
  location                     = local.location
  resource_group_name          = local.rg_name
  version                      = "12.0"
  administrator_login          = local.sql_admin_login
  administrator_login_password = local.sql_admin_password
  minimum_tls_version          = "1.2"

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      administrator_login_password
    ]
  }

  tags = merge(
    var.additional_sql_tags,
    var.additional_tags,
    {
      location    = local.location
    },
  )
}

#Creates the extended auditing Policy
resource "azurerm_mssql_server_extended_auditing_policy" "auditing_policy" {
  server_id                               = azurerm_mssql_server.sql_server.id
  storage_endpoint                        = local.primary_blob_endpoint
  storage_account_access_key              = local.primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 6
}


#Created the Elastic Pool
resource "azurerm_mssql_elasticpool" "sql_pool" {
  name                = local.elastic_pool_name
  location            = local.location
  resource_group_name = local.rg_name
  server_name         = azurerm_mssql_server.sql_server.name
  license_type        = "LicenseIncluded"
  max_size_gb         = 756

  sku {
    name     = "GP_Gen5"
    tier     = "GeneralPurpose"
    family   = "Gen5"
    capacity = 12
  }

  per_database_settings {
    min_capacity = 0.25
    max_capacity = 4
  }
}

# Create SQL Server firewall rule for Azure resouces access
resource "azurerm_sql_firewall_rule" "azure_service_firewall" {
  name                = "AllowAllWindowsIP"
  resource_group_name = local.rg_name
  server_name         = azurerm_mssql_server.sql_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

#Create a SQL Server Firewall rule for AKS to access the SQL server
resource "azurerm_sql_virtual_network_rule" "aks_firewall" {
  name                = "aks_allow_access"
  resource_group_name = local.rg_name
  server_name         = azurerm_mssql_server.sql_server.name
  subnet_id           = local.aks_subnet_id
}
