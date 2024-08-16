#Manages a Managed Kubernetes Cluster (also known as AKS / Azure Kubernetes Service)
locals {
  #Common Variables
  rg_name             = var.rg_name
  node_resource_group = var.node_resource_group
  location            = var.location
  acr_name            = var.acr_name
  linux_pool          = var.linux_pool
  windows_pool        = var.windows_pool

  #Linux Pool Configuration
  linux_vm_size         = var.linux_vm_size
  linux_os_disk_size_gb = var.linux_os_disk_size_gb
  vm_user_name          = var.vm_user_name
  linux_node_count      = var.linux_node_count

  #Windows Pool Configuration
  windows_password        = var.windows_password
  windows_username        = var.windows_username
  windows_node_count      = var.windows_node_count
  windows_vm_size         = var.windows_vm_size
  windows_os_disk_size_gb = var.windows_os_disk_size_gb

  #Subnet Variables
  subnet_id        = var.subnet_id

  #Resources names
  workspace_name = var.workspace_name
  aks_name       = var.aks_name
  dns_prefix     = var.dns_prefix

}

data "azurerm_container_registry" "acr" {
  name                = local.acr_name
  resource_group_name = local.rg_name
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "azurerm_log_analytics_workspace" "aks" {
  name                = local.workspace_name
  location            = local.location
  resource_group_name = local.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name
  location            = local.location
  resource_group_name = local.rg_name
  dns_prefix          = local.dns_prefix
  node_resource_group = local.node_resource_group
  kubernetes_version  = "1.26.0"

  default_node_pool {
    name            = local.linux_pool
    node_count      = local.linux_node_count
    vm_size         = local.linux_vm_size
    os_disk_size_gb = local.linux_os_disk_size_gb
    type            = "VirtualMachineScaleSets"
    vnet_subnet_id  = local.subnet_id
    max_pods        = 250

    tags = merge(
      var.additional_aks_tags,
      var.additional_tags,
      {
        location    = var.location
      },
    )
  }

  identity {
    type = "SystemAssigned"
  }

  linux_profile {
    admin_username = local.vm_user_name

    ssh_key {
      key_data = tls_private_key.ssh.public_key_openssh
    }
  }

  network_profile {
    network_plugin     = "azure"
    service_cidr       = "10.30.0.0/16"
    docker_bridge_cidr = "172.17.0.1/16"
    dns_service_ip     = "10.30.0.10"
    network_mode       = "transparent"
  }

  addon_profile {
    ingress_application_gateway {
      enabled      = true
      gateway_name = var.appgw_name
      subnet_id    = var.appgw_subnet_id
    }

    oms_agent {
      enabled                    = "true"
      log_analytics_workspace_id = azurerm_log_analytics_workspace.aks.id
    }
    http_application_routing {
      enabled = "false"
    }

  }
  
  windows_profile {
    admin_username = local.windows_username
    admin_password = local.windows_password
  }

  role_based_access_control {
    enabled = true
  }

  tags = merge(
    var.additional_aks_tags,
    var.additional_tags,
    {
      location    = var.location
    },
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      windows_profile[0].admin_password
    ]

  }

  depends_on = [
    azurerm_log_analytics_workspace.aks,
    tls_private_key.ssh
  ]
}

#Manages a (Windows) Node Pool within a Kubernetes Cluster
resource "azurerm_kubernetes_cluster_node_pool" "aks" {
  name                  = local.windows_pool
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = local.windows_vm_size
  node_count            = local.windows_node_count
  os_disk_size_gb       = local.windows_os_disk_size_gb
  os_type               = "Windows"
  vnet_subnet_id        = local.subnet_id
  enable_auto_scaling   = true
  max_count             = 20
  min_count             = 2
  max_pods              = 250


  tags = merge(
    var.additional_aks_tags,
    var.additional_tags,
    {
      location    = var.location
    },
  )
  lifecycle {
    ignore_changes = [
      node_count
    ]
  }
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}

resource "azurerm_role_assignment" "role_acrpull" {
  scope                            = data.azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity.0.object_id
  skip_service_principal_aad_check = true
}