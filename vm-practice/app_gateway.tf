/*
# Public IP for Application Gateway
resource "azurerm_public_ip" "app_gateway" {
  name                = "pip-appgw-practice-lab"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  allocation_method = "Static"
  sku               = "Standard"

  tags = local.common_tags
}

# Application Gateway
resource "azurerm_application_gateway" "web" {
  name                = "appgw-practice-lab"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
  }

  autoscale_configuration {
    min_capacity = 1
    max_capacity = 2
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = azurerm_subnet.appgw.id
  }

  frontend_ip_configuration {
    name                 = "public-frontend"
    public_ip_address_id = azurerm_public_ip.app_gateway.id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  backend_address_pool {
    name         = "web-backend-pool"
    ip_addresses = azurerm_network_interface.nic[*].private_ip_address
  }

  backend_http_settings {
    name                  = "http-backend-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }
  ssl_certificate {
    name     = "appgw-lab-cert"
    data     = filebase64("${path.module}/appgw-lab.pfx")
    password = var.appgw_cert_password
  }
  frontend_port {
    name = "https-port"
    port = 443
  }
  http_listener {
    name                           = "vm1-https-listener"
    frontend_ip_configuration_name = "public-frontend"
    frontend_port_name             = "https-port"
    protocol                       = "Https"
    host_name                      = "vm1.lab.example.com"
    ssl_certificate_name           = "appgw-lab-cert"
  }
  http_listener {
    name                           = "vm2-https-listener"
    frontend_ip_configuration_name = "public-frontend"
    frontend_port_name             = "https-port"
    protocol                       = "Https"
    host_name                      = "vm2.lab.example.com"
    ssl_certificate_name           = "appgw-lab-cert"
  }

  probe {
    name                                      = "nginx-health-probe"
    protocol                                  = "Http"
    path                                      = "/"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true

    match {
      status_code = ["200-399"]
    }
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "public-frontend"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }


  request_routing_rule {
    name               = "path-routing-rule"
    rule_type          = "PathBasedRouting"
    priority           = 100
    http_listener_name = "http-listener"
    url_path_map_name  = "path-map"
  }

  url_path_map {
    name                               = "path-map"
    default_backend_address_pool_name  = "web-backend-pool"
    default_backend_http_settings_name = "http-backend-settings"

    path_rule {
      name                       = "route-vm1"
      paths                      = ["/vm1/*"]
      backend_address_pool_name  = "web-vm1-pool"
      backend_http_settings_name = "http-backend-settings"
    }

    path_rule {
      name                       = "route-vm2"
      paths                      = ["/vm2/*"]
      backend_address_pool_name  = "web-vm2-pool"
      backend_http_settings_name = "http-backend-settings"
    }
  }
  # Host-based listener for VM1
  http_listener {
    name                           = "vm1-host-listener"
    frontend_ip_configuration_name = "public-frontend"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
    host_name                      = "vm1.lab.example.com"
  }
  http_listener {
    name                           = "https-path-listener"
    frontend_ip_configuration_name = "public-frontend"
    frontend_port_name             = "https-port"
    protocol                       = "Https"
    ssl_certificate_name           = "appgw-lab-cert"
  }

  # Host-based listener for VM2
  http_listener {
    name                           = "vm2-host-listener"
    frontend_ip_configuration_name = "public-frontend"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
    host_name                      = "vm2.lab.example.com"
  }

  # Route VM1 hostname to VM1
  request_routing_rule {
    name                       = "vm1-host-rule"
    rule_type                  = "Basic"
    priority                   = 110
    http_listener_name         = "vm1-host-listener"
    backend_address_pool_name  = "web-vm1-pool"
    backend_http_settings_name = "http-backend-settings"
  }

  # Route VM2 hostname to VM2
  request_routing_rule {
    name                       = "vm2-host-rule"
    rule_type                  = "Basic"
    priority                   = 120
    http_listener_name         = "vm2-host-listener"
    backend_address_pool_name  = "web-vm2-pool"
    backend_http_settings_name = "http-backend-settings"
  }
  request_routing_rule {
    name                       = "vm1-https-rule"
    rule_type                  = "Basic"
    priority                   = 130
    http_listener_name         = "vm1-https-listener"
    backend_address_pool_name  = "web-vm1-pool"
    backend_http_settings_name = "http-backend-settings"
  }

  request_routing_rule {
    name                       = "vm2-https-rule"
    rule_type                  = "Basic"
    priority                   = 140
    http_listener_name         = "vm2-https-listener"
    backend_address_pool_name  = "web-vm2-pool"
    backend_http_settings_name = "http-backend-settings"
  }
  request_routing_rule {
    name               = "https-path-routing-rule"
    rule_type          = "PathBasedRouting"
    priority           = 150
    http_listener_name = "https-path-listener"
    url_path_map_name  = "https-path-map"
  }
  url_path_map {
    name                               = "https-path-map"
    default_backend_address_pool_name  = "web-backend-pool"
    default_backend_http_settings_name = "http-backend-settings"

    path_rule {
      name                       = "https-route-vm1"
      paths                      = ["/vm1/*"]
      backend_address_pool_name  = "web-vm1-pool"
      backend_http_settings_name = "http-backend-settings"
    }

    path_rule {
      name                       = "https-route-vm2"
      paths                      = ["/vm2/*"]
      backend_address_pool_name  = "web-vm2-pool"
      backend_http_settings_name = "http-backend-settings"
    }
  }

  backend_address_pool {
    name         = "web-vm1-pool"
    ip_addresses = [azurerm_network_interface.nic[0].private_ip_address]
  }

  backend_address_pool {
    name         = "web-vm2-pool"
    ip_addresses = [azurerm_network_interface.nic[1].private_ip_address]
  }


  tags = local.common_tags
}
*/
