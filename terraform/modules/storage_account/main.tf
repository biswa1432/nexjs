locals {
  rg_name = var.rg_name
  storage_account_name = var.storage_account_name
  location = var.location
}

#Create a Storage Account to store SQL Server audit logs
resource "azurerm_storage_account" "storage_account" {
  name                     = local.storage_account_name
  resource_group_name      = local.rg_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
  allow_blob_public_access = true
}

#Create a container to store the solr files
resource "azurerm_storage_container" "container" {
  name                  = "solrfiles"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "container"
}