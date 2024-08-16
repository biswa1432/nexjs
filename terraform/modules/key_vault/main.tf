locals {
  kv_name                   = var.kv_name
  location                  = var.location
  rg_name                   = var.rg_name
  tenant_id                 = var.tenant_id
  aks_sp_object_id          = var.aks_sp_object_id

}


resource "azurerm_key_vault" "key_vault" {
  name                        = local.kv_name
  location                    = local.location
  resource_group_name         = local.rg_name
  enabled_for_disk_encryption = true
  tenant_id                   = local.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = local.tenant_id
    object_id = local.aks_sp_object_id

    key_permissions = [
      "get", "list", "update", "create", "import", "delete", "recover", "backup", "restore",
    ]

    secret_permissions = [
      "get", "list", "delete", "recover", "backup", "restore", "set",
    ]

    certificate_permissions = [
      "get", "list", "update", "create", "import", "delete", "recover", "backup", "restore", "deleteissuers", "getissuers", "listissuers", "managecontacts", "manageissuers", "setissuers",
    ]
  }

  tags = merge(
    var.additional_kv_tags,
    var.additional_tags,
    {
      location = var.location
    },
  )

  lifecycle {
    ignore_changes = [
      access_policy
    ]

  }
}
