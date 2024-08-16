#Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

module "storage_account" {
  source               = "./modules/storage_account"
  storage_account_name = var.storage_account_name
  location             = var.location
  rg_name              = local.rg_name
}

#Create the acr
module "acr" {

  source   = "./modules/acr"
  acr_name = var.acr_name
  rg_name  = local.rg_name
  location = var.location
  sku      = var.sku
  admin    = var.admin

}

#Create the Service Principal to be used with AKS
module "service_principal" {

  source  = "./modules/service_principal"
  sp_name = var.sp_name
  ap_name = var.ap_name
  acr_id  = local.acr_id

  #Will only be created after the ACR creation
  depends_on = [
    module.acr
  ]
}

#Create the VNETs
module "virtual_networks" {

  source                  = "./modules/virtual_networks"
  rg_name                 = local.rg_name
  location                = var.location
  aks_vnet_name           = var.aks_vnet_name
  aks_vnet_addr_space     = var.aks_vnet_addr_space
  aks_subnet_name         = var.aks_subnet_name
  aks_subnet_addr_space   = var.aks_subnet_addr_space
  appgw_subnet_name       = var.appgw_subnet_name
  appgw_subnet_addr_space = var.appgw_subnet_addr_space
}


#Create the SQL Server and SQL Pool
module "sql_server" {

  #General Variables
  source                = "./modules/sql_server"
  sql_server_name       = var.sql_server_name
  elastic_pool_name     = var.elastic_pool_name
  location              = var.location
  rg_name               = local.rg_name
  sql_admin_login       = var.sql_admin_login
  primary_blob_endpoint = local.primary_blob_endpoint
  primary_access_key    = local.primary_access_key
  aks_subnet_id         = local.aks_subnet_id

}


#Key Vault creation
module "key_vault" {

  #General Variables
  source   = "./modules/key_vault"
  kv_name  = var.kv_name
  location = var.location
  rg_name  = var.rg_name

  #Accounts Variables
  tenant_id                            = local.tenant_id
  aks_sp_object_id                     = local.aks_sp_object_id

  depends_on = [
    module.service_principal,
  ]

}

#Create the AKS Cluster
module "aks" {

  #General Variables
  source              = "./modules/aks"
  workspace_name      = var.workspace_name
  aks_name            = var.aks_name
  node_resource_group = var.node_resource_group
  dns_prefix          = var.dns_prefix
  location            = var.location
  rg_name             = local.rg_name
  subnet_id           = local.aks_subnet_id
  appgw_name          = var.appgw_name
  acr_name            = var.acr_name
  appgw_subnet_id     = module.virtual_networks.appgw_subnet_id

  #Linux Node Pool variables
  linux_pool            = var.linux_pool
  linux_node_count      = var.linux_node_count
  linux_vm_size         = var.linux_vm_size
  linux_os_disk_size_gb = var.linux_os_disk_size_gb

  #Windows Node Pool variables
  windows_pool            = var.windows_pool
  windows_node_count      = var.windows_node_count
  windows_vm_size         = var.windows_vm_size
  windows_os_disk_size_gb = var.windows_os_disk_size_gb


  #Windows Profile variables
  windows_username = var.windows_username

  depends_on = [
    module.acr,
    module.virtual_networks,
    module.service_principal,
    module.key_vault
  ]

}

module "Install_Secrets_Providers" {
  #General Variables
  source                               = "./modules/secret_provider"
  aks_name                             = var.aks_name
  rg_name                              = local.rg_name
  node_resource_group                  = var.node_resource_group
  kv_name                              = var.kv_name
  depends_on = [
    module.key_vault,
    module.aks
  ]
}