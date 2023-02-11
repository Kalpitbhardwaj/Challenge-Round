#Web Load-Balancer
resource "azurerm_public_ip" "weblbpubip" {
  name                = "weblbpubip"
  location            = azurerm_resource_group.webrg.location
  resource_group_name = azurerm_resource_group.webrg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "weblb" {
  name                = "weblb"
  location            = azurerm_resource_group.webrg.location
  resource_group_name = azurerm_resource_group.webrg.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "webfePubip"
    public_ip_address_id = azurerm_public_ip.weblbpubip.id
  }
}

resource "azurerm_lb_backend_address_pool" "weblbbep" {
  loadbalancer_id = azurerm_lb.weblb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_rule" "weblbrule" {
  loadbalancer_id                = azurerm_lb.weblb.id
  name                           = "rule1"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "webfePubip"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.weblbbep.id]
}

resource "azurerm_lb_probe" "weblbprobe" {
  loadbalancer_id = azurerm_lb.weblb.id
  name            = "hhtp-running-probe"
  port            = 80
}

#Application Load Balancer
resource "azurerm_lb" "applb" {
  name                = "applb"
  location            = azurerm_resource_group.apprg.location
  resource_group_name = azurerm_resource_group.apprg.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                          = "PrivateIP"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address            = "10.0.1.248"
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_lb_backend_address_pool" "applbbep" {
  loadbalancer_id = azurerm_lb.applb.id
  name            = "BackEndAddressPool"
}
resource "azurerm_lb_backend_address_pool_address" "pooladd1" {
  name                    = "pooladd1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.applbbep.id
  virtual_network_id      = azurerm_virtual_network.vnet1.id
  ip_address              = azurerm_network_interface.vm1nic.private_ip_address
}
resource "azurerm_lb_backend_address_pool_address" "pooladd2" {
  name                    = "pooladd2"
  backend_address_pool_id = azurerm_lb_backend_address_pool.applbbep.id
  virtual_network_id      = azurerm_virtual_network.vnet1.id
  ip_address              = azurerm_network_interface.vm2nic.private_ip_address
}
resource "azurerm_lb_rule" "applbrule" {
  loadbalancer_id                = azurerm_lb.applb.id
  name                           = "rule1"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "appfePubip"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.applbbep.id]
}

resource "azurerm_lb_probe" "applbprobe" {
  loadbalancer_id = azurerm_lb.applb.id
  name            = "hhtp-running-probe"
  port            = 80
}

#Output values
output "weblbip" {
  value = azurerm_public_ip.weblbpubip.ip_address
}
output "applbip" {
  value = azurerm_lb.applb.private_ip_address
}
