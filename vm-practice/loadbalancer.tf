# 1. Public frontend IP
resource "azurerm_public_ip" "lb_public_ip" {
  name                = "pip-lb-practice-lab"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  allocation_method = "Static"
  sku               = "Standard"

  tags = local.common_tags
}

# 2. Azure Load Balancer
resource "azurerm_lb" "web_lb" {
  name                = "lb-practice-lab"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "public-frontend"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }

  tags = local.common_tags
}

# 3. Backend pool
resource "azurerm_lb_backend_address_pool" "web_pool" {
  name            = "backend-pool"
  loadbalancer_id = azurerm_lb.web_lb.id
}

# 4. HTTP health probe
resource "azurerm_lb_probe" "http_probe" {
  name            = "http-health-probe"
  loadbalancer_id = azurerm_lb.web_lb.id
  protocol        = "Tcp"
  port            = 80
}

# 5. HTTP load-balancing rule
resource "azurerm_lb_rule" "http_rule" {
  name                           = "http-rule"
  loadbalancer_id                = azurerm_lb.web_lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "public-frontend"
  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.web_pool.id
  ]
  probe_id = azurerm_lb_probe.http_probe.id
}

# 6. Attach both VM NICs to the backend pool
resource "azurerm_network_interface_backend_address_pool_association" "web_backend" {
  count = 2

  network_interface_id    = azurerm_network_interface.nic[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.web_pool.id
}
