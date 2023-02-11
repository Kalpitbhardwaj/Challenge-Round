
resource "azurerm_resource_group" "web-rg" {
  name     = var.web_rg
  location = var.location
}

resource "azurerm_resource_group" "network_rg" {
  name     = var.network_rg
  location = var.location
}

resource "azurerm_resource_group" "app-rg" {
  name     = var.app_rg
  location = var.location
}

resource "azurerm_resource_group" "db-rg" {
  name     = var.db_rg
  location = var.location
}
