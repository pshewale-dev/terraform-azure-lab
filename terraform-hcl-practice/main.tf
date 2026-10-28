terraform {
  required_version = ">=1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "24a95b5e-d585-442d-a975-b5083f563cbc"
}

resource "azurerm_resource_group" "lab" {
  name     = "rg-tf-lab-prashant-dev"
  location = "centralindia"

  tags = {
    environment = "dev"
    managed_by  = "terraform"
    purpose     = "learning-lab"
  }
}
