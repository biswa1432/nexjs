locals {
  sp_name             = var.sp_name
  ap_name             = var.ap_name
  acr_id              = var.acr_id
}

data "azuread_client_config" "current" {}

#Manages an application registration within Azure Active Directory.
resource "azuread_application" "aks_sp" {
  display_name = local.sp_name
  owners       = [data.azuread_client_config.current.object_id]
}


#Manages a service principal associated with an application within Azure Active Directory.
resource "azuread_service_principal" "aks_sp" {

  application_id               = azuread_application.aks_sp.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]

  depends_on = [
    azuread_application.aks_sp
  ]
}

#Manages a password credential associated with a service principal within Azure Active Directory
resource "azuread_service_principal_password" "aks_sp" {
  service_principal_id = azuread_service_principal.aks_sp.id

  lifecycle {
    ignore_changes = [
      value,
      end_date
    ]
  }

  depends_on = [
    azuread_service_principal.aks_sp
  ]
}

#Manages a password credential associated with an application within Azure Active Directory. 
resource "azuread_application_password" "aks_sp" {
  display_name          = local.ap_name
  application_object_id = azuread_application.aks_sp.id

  lifecycle {
    ignore_changes = [
      value,
      end_date
    ]
  }

  depends_on = [
    azuread_application.aks_sp
  ]
}