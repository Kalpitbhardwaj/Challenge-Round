
resource "azurerm_resource_group" "web-rg" {
    name = var.webtier_rg
    location = var.location
}

resource "azurerm_resource_group" "network-rg" {
    name = var.network_rg
    location = var.location
  }

resource "azurerm_resource_group" "app-rg" {
    name = var.apptier_rg
    location = var.location  
}

resource "azurerm_resource_group" "db-rg" {
    name = var.dbtier_rg
    location = var.location 
}
