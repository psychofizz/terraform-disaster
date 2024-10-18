## TODO: Port this over to Postgres, rather not deal with mssql. 

resource "azurerm_mssql_server" "sql-server" {
  name                         = "sqlserver-${var.project}-${var.environment}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.region
  administrator_login          = "sqladmin"
  administrator_login_password = var.password
  tags                         = var.tags
  version                      = "12.0"
}

resource "azurerm_mssql_database" "ms-sql-db" {
  name      = "accounting-db"
  server_id = azurerm_mssql_server.sql-server.id
  sku_name  = "S0"
  tags      = var.tags
}

resource "azurerm_private_endpoint" "sql_private_endpoint" {
  name                = "sql-private-endpoint-${var.project}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.region
  subnet_id           = azurerm_subnet.subnet-db.id
  private_service_connection {
    name                           = "sql-private-endpoint-connection-${var.project}-${var.environment}"
    private_connection_resource_id = azurerm_mssql_server.sql-server.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"] ## The name is assigned by the azure documentation
  }
}


resource "azurerm_private_dns_zone" "private-dns_zone" {
  name                = "private.dbserver.database.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}


resource "azurerm_private_dns_a_record" "private-dns-a-record" {
  name                = "sqlserver-record-${var.project}-${var.environment}"
  zone_name           = azurerm_private_dns_zone.private-dns_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.sql_private_endpoint.private_service_connection[0].private_ip_address]

}

resource "azurerm_private_dns_zone_virtual_network_link" "vn-link" {
  name                  = "virtual-network-link-${var.project}-${var.environment}"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private-dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_mssql_firewall_rule" "allow-my-ip-addr" {
  name             = "allow-my-ip-addr"
  server_id        = azurerm_mssql_server.sql-server.id
  start_ip_address = "190.242.24.56"
  end_ip_address   = "190.242.24.56"
}
