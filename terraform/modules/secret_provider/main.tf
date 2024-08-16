#Install Secrets Provider
resource "null_resource" "AZ_Install_Secrets_Providers" {

  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "az aks enable-addons --addons azure-keyvault-secrets-provider --name ${var.aks_name} --resource-group ${var.rg_name}"

  }
  
}

#Configure Policy
resource "null_resource" "Configure_Policy_Secrets_Providers" {

  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    interpreter = ["PowerShell"]
    command = <<-EOT
              $1st = (az vmss list -g ${var.node_resource_group} --query [0].[name] -o tsv)
              $2nd = (az vmss list -g ${var.node_resource_group} --query [1].[name] -o tsv)
              az vmss identity assign -g ${var.node_resource_group} -n $1st
              az vmss identity assign -g ${var.node_resource_group} -n $2nd
              $spn_id_1st = (az vmss identity show --name $1st --resource-group ${var.node_resource_group} --query principalId)
              $spn_id_2nd = (az vmss identity show --name $2nd --resource-group ${var.node_resource_group} --query principalId)
              az keyvault set-policy -n ${var.kv_name} --secret-permissions get list set delete recover backup restore --object-id $spn_id_1st
              az keyvault set-policy -n ${var.kv_name} --certificate-permissions get list update create import delete recover backup restore --object-id $spn_id_1st
              az keyvault set-policy -n ${var.kv_name} --key-permissions get list update create import delete recover backup restore --object-id $spn_id_1st
              az keyvault set-policy -n ${var.kv_name} --secret-permissions get list set delete recover backup restore --object-id $spn_id_2nd
              az keyvault set-policy -n ${var.kv_name} --certificate-permissions get list update create import delete recover backup restore --object-id $spn_id_2nd
              az keyvault set-policy -n ${var.kv_name} --key-permissions get list update create import delete recover backup restore --object-id $spn_id_2nd
    EOT
  }

  depends_on = [
    null_resource.AZ_Install_Secrets_Providers
  ]

}