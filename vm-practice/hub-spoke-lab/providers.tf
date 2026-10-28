terraform {
  required_version = ">= 1.5.0"

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
    key                  = "hub-spoke-lab/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}