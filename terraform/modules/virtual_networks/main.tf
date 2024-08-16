locals {

  location  = var.location
  rg_name   = var.rg_name

  #AKS network variables
  aks_vnet_name            = var.aks_vnet_name
  aks_vnet_addr_space      = var.aks_vnet_addr_space
  aks_subnet_name          = var.aks_subnet_name
  aks_subnet_addr_space    = var.aks_subnet_addr_space

}

#Create the Main AKS Vnet
resource "azurerm_virtual_network" "AKS_vnet" {
  name                = local.aks_vnet_name
  address_space       = ["${local.aks_vnet_addr_space}"]
  location            = local.location
  resource_group_name = local.rg_name
  lifecycle {
    create_before_destroy = true
  }

}

#Create the subnet within the Main VNET
resource "azurerm_subnet" "aks_subnet" {
  name                 = local.aks_subnet_name
  resource_group_name  = local.rg_name
  virtual_network_name = local.aks_vnet_name
  address_prefixes     = ["${local.aks_subnet_addr_space}"]
  service_endpoints    = ["Microsoft.Sql"]

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    azurerm_virtual_network.AKS_vnet
  ]
}

#Create the subnet within the Main VNET
resource "azurerm_subnet" "appgw_subnet" {
  name                 = var.appgw_subnet_name
  resource_group_name  = local.rg_name
  virtual_network_name = local.aks_vnet_name
  address_prefixes     = ["${var.appgw_subnet_addr_space}"]

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    azurerm_virtual_network.AKS_vnet
  ]
}
