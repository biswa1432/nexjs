
locals {
  acr_name            = var.acr_name
  rg_name             = var.rg_name
  location            = var.location
  sku                 = var.sku
  admin               = var.admin
  additional_acr_tags = var.additional_acr_tags
  additional_tags     = var.additional_tags
}

resource "azurerm_container_registry" "acr" {
  name                = local.acr_name
  resource_group_name = local.rg_name
  location            = local.location
  sku                 = local.sku
  admin_enabled       = local.admin

  tags = merge(
    local.additional_acr_tags,
    local.additional_tags,
    {
      location    = local.location
    },
  )
}
