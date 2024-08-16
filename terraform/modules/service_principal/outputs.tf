output "client_id" {
  value = azuread_service_principal.aks_sp.application_id
}

output "object_id" {
  value = azuread_service_principal.aks_sp.object_id
}
output "client_secret" {
  value = azuread_service_principal_password.aks_sp.value
}
