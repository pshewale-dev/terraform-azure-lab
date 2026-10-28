resource "azurerm_resource_group" "lab" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "hub" {
  source = "./modules/vnet"

  name                = "vnet-hub-lab"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24"]
  subnet_names        = ["snet-hub"]
  tags                = var.tags
}

module "spoke1" {
  source = "./modules/vnet"

  name                = "vnet-spoke1-lab"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  address_space       = ["10.1.0.0/16"]
  subnet_prefixes     = ["10.1.1.0/24"]
  subnet_names        = ["snet-spoke1"]
  tags                = var.tags
}

module "spoke2" {
  source = "./modules/vnet"

  name                = "vnet-spoke2-lab"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  address_space       = ["10.2.0.0/16"]
  subnet_prefixes     = ["10.2.1.0/24"]
  subnet_names        = ["snet-spoke2"]
  tags                = var.tags
}

module "hub_to_spoke1" {
  source = "./modules/peering"

  name                      = "hub-to-spoke1"
  resource_group_name       = azurerm_resource_group.lab.name
  virtual_network_name      = module.hub.vnet_name
  remote_virtual_network_id = module.spoke1.vnet_id
}

module "spoke1_to_hub" {
  source = "./modules/peering"

  name                      = "spoke1-to-hub"
  resource_group_name       = azurerm_resource_group.lab.name
  virtual_network_name      = module.spoke1.vnet_name
  remote_virtual_network_id = module.hub.vnet_id
}

module "hub_to_spoke2" {
  source = "./modules/peering"

  name                      = "hub-to-spoke2"
  resource_group_name       = azurerm_resource_group.lab.name
  virtual_network_name      = module.hub.vnet_name
  remote_virtual_network_id = module.spoke2.vnet_id
}

module "spoke2_to_hub" {
  source = "./modules/peering"

  name                      = "spoke2-to-hub"
  resource_group_name       = azurerm_resource_group.lab.name
  virtual_network_name      = module.spoke2.vnet_name
  remote_virtual_network_id = module.hub.vnet_id
}
module "hub_to_spoke3" {
  source = "./modules/peering"

  name                      = "hub-to-spoke3"
  resource_group_name       = azurerm_resource_group.lab.name
  virtual_network_name      = module.hub.vnet_name
  remote_virtual_network_id = module.spoke3.vnet_id
}

module "spoke3_to_hub" {
  source = "./modules/peering"

  name                      = "spoke3-to-hub"
  resource_group_name       = azurerm_resource_group.lab.name
  virtual_network_name      = module.spoke3.vnet_name
  remote_virtual_network_id = module.hub.vnet_id
}
module "spoke3" {
  source = "./modules/vnet"

  name                = "vnet-spoke3-lab"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  address_space       = ["10.3.0.0/16"]
  subnet_prefixes     = ["10.3.1.0/24"]
  subnet_names        = ["snet-spoke3"]
  tags                = var.tags
}