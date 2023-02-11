resource "azurerm_storage_account" "appvmextnstore1" {
  name                     = "appvmextnstore1"
  resource_group_name      = azurerm_resource_group.apprg.name
  location                 = azurerm_resource_group.apprg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "appvmcont" {
  name                  = "appvmcont"
  storage_account_name  = azurerm_storage_account.appvmextnstore1.name
  container_access_type = "blob"
}
resource "azurerm_storage_blob" "iisconfig" {
  name                   = "iis.ps1"
  storage_account_name   = azurerm_storage_account.appvmextnstore1.name
  storage_container_name = azurerm_storage_container.appvmcont.name
  type                   = "Block"
  source                 = "iis.ps1"
}
