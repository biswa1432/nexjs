#Common Variables
location = "eastus"
rg_name  = "sgroup"

#Subnet Variables
aks_vnet_name           = "vnet-s"
aks_subnet_name         = "snet-s"
appgw_subnet_name       = "snet-appgw-s"
aks_vnet_addr_space     = "10.0.0.0/16"
aks_subnet_addr_space   = "10.0.16.0/20"
appgw_subnet_addr_space = "10.0.32.0/24"

#Storage Account Variables
storage_account_name = "sstragesiisi"

#ACR Variables
acr_name = "terraformacrsss"
sku      = "premium"
admin    = "true"

#SQL Server Variables
sql_admin_login   = "scsa"
sql_server_name   = "sql-terraform"
elastic_pool_name = "sql-pool-terraform"

#Service Principal Variables
sp_name = "sp-sc-terrafors"
ap_name = "ap-sc-terrafors"

#Key Vault Variables
kv_name   = "kv-terra-s"

#AKS variables
workspace_name          = "workspace-terraform"
aks_name                = "aks-terraform"
node_resource_group     = "sgroup-aks-backend"
linux_pool              = "linux"
windows_pool            = "window"
dns_prefix              = "dns-terraform"
appgw_name              = "snet-appgw-s"
windows_username        = "azureuser"
linux_node_count        = 1
linux_os_disk_size_gb   = 128
linux_vm_size           = "Standard_DS2_v2"
windows_node_count      = 2
windows_os_disk_size_gb = 128
windows_vm_size         = "Standard_DS3_v2"
additional_aks_tags     = {}