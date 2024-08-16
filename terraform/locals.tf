#Data source to access the configuration of the AzureRM provider
data "azurerm_client_config" "current" {}

locals {
  #Common Variables
  tenant_id       = data.azurerm_client_config.current.tenant_id
  subscription_id = data.azurerm_client_config.current.subscription_id

  #Resource Group Variables
  rg_name = azurerm_resource_group.rg.name
  rg_id   = azurerm_resource_group.rg.id

  #ACR Variables
  acr_id   = module.acr.acr_id
  acr_name = module.acr.acr_name

  #SQL Server Variables
  sql_server_pool_name = module.sql_server.sql_server_pool_name
  sql_server_name      = module.sql_server.sql_server_name

  #Key Vault Variables
  aks_sp_object_id = module.service_principal.object_id

  #VNet Variables
  aks_subnet_id = module.virtual_networks.aks_subnet_id

  #Storage Account Variables
  primary_blob_endpoint = module.storage_account.primary_blob_endpoint
  primary_access_key    = module.storage_account.primary_access_key

}
