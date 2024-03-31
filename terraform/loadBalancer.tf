resource "azurerm_lb" "password_app_lb" {
  name                = "password_app_lb"
  resource_group_name = azurerm_resource_group.password_app_rg.name
  location            = azurerm_resource_group.password_app_rg.location
  sku                 = "Standard"
  
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.password_app_public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "password_app_bepool" {
  name                = "password_app_bepool"
  resource_group_name = azurerm_resource_group.password_app_rg.name
  loadbalancer_id     = azurerm_lb.password_app_lb.id
}

resource "azurerm_lb_nat_pool" "password_app_lbnatpool" {
  resource_group_name            = azurerm_resource_group.password_app_rg.name
  name                           = "ssh"
  loadbalancer_id                = azurerm_lb.password_app_lb.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}   

resource "azurerm_lb_probe" "password_app_probe" {
 name                = "password_app_probe"
 loadbalancer_id     = azurerm_lb.password_app_lb.id
resource_group_name  = azurerm_resource_group.password_app_rg.name
 port                = 80
 protocol            = "Http"
 request_path        = "/"
}

resource "azurerm_lb_rule" "password_app_lb_rule" {
 name                           = "password_app_lb_rule"
 loadbalancer_id                = azurerm_lb.password_app_lb.id
resource_group_name             = azurerm_resource_group.password_app_rg.name
 protocol                       = "Tcp"
 frontend_port                  = 80
 backend_port                   = 80
 backend_address_pool_id        = azurerm_lb_backend_address_pool.password_app_bepool.id
 frontend_ip_configuration_name = "PublicIPAddress"
 probe_id                       = azurerm_lb_probe.password_app_probe.id
}