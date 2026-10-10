terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
    # Add the core Azure Resource Manager provider here
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90.0"
    }
  }
}

provider "azuread" {}
provider "random" {}

# Initialize the Azure Resource Manager provider settings
provider "azurerm" {
  features {} # This features block is strictly required by HashiCorp for azurerm
}

data "azuread_client_config" "current" {}
