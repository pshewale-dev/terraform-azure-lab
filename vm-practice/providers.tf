terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
    backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttflabstate2026"
    container_name       = "tfstate"
    key                  = "test/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
