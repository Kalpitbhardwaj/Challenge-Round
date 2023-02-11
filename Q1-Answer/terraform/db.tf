resource "azurerm_mssql_server" "sqldbserver" {
  name                         = "sqldbserver011"
  resource_group_name          = azurerm_resource_group.dbrg.name
  location                     = azurerm_resource_group.dbrg.location
  version                      = "12.0"
  administrator_login          = "dbadmin"
  administrator_login_password = "Password@1"
}
resource "azurerm_mssql_firewall_rule" "dbfwrule1" {
  name             = "dbfwrule1"
  server_id        = azurerm_mssql_server.sqldbserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
resource "azurerm_mssql_database" "sqldb" {
  name           = "msdb0101"
  server_id      = azurerm_mssql_server.sqldbserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 1
  read_scale     = false
  sku_name       = "Basic"
  zone_redundant = false
  }