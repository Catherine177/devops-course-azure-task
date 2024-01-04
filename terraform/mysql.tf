# Create MySQL server
resource "azurerm_mysql_server" "final_task_mysql_server" {
  name                = "final-task-mysql-server"
  location            = azurerm_resource_group.final_task_rg.location
  resource_group_name = azurerm_resource_group.final_task_rg.name

  administrator_login          = "mysqladmin"
  administrator_login_password = "<Should-be-kept-1n-secret>"

  sku_name   = "GP_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  ssl_enforcement_enabled      = true
}

# Create virtual network rule
resource "azurerm_mysql_virtual_network_rule" "final_task_vnet_rule" {
  name                = "mysql-vnet-rule"
  resource_group_name = azurerm_resource_group.final_task_rg.name
  server_name         = azurerm_mysql_server.final_task_mysql_server.name
  subnet_id           = azurerm_subnet.subnet_2_private.id
}