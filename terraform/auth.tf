terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.78.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.6.0"
    }


  }

}

provider "azurerm" {
  features {}
}