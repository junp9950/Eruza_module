# Mysql server 생성
resource "azurerm_mysql_server" "jw_dbserver" {
  name                         = "${var.name}-db"
  resource_group_name          = azurerm_resource_group.jwrg.name
  location                     = azurerm_resource_group.jwrg.location
  version                      = var.db-ver
  administrator_login          = var.db-admin
  administrator_login_password = var.db-admin-pw
  sku_name                     = var.db-sku-name
  ssl_enforcement_enabled      = var.ssl-enforce
  storage_mb                   = var.ssl-mb
}

# Mysql Database 생성
resource "azurerm_mysql_database" "jw_db" {
  name                = "petclinic"
  resource_group_name = azurerm_resource_group.jwrg.name
  server_name         = azurerm_mysql_server.jw_dbserver.name
  charset             = var.db-charset
  collation           = var.db-colla

  depends_on = [
    azurerm_mysql_server.jw_dbserver
  ]
}

# SQL Server Firewall rule 생성
resource "azurerm_mysql_firewall_rule" "jw_db_firewall" {
  name                = "${var.name}_db_fire"
  resource_group_name = azurerm_resource_group.jwrg.name
  server_name         = azurerm_mysql_server.jw_dbserver.name
  start_ip_address    = var.db-fw-startip
  end_ip_address      = var.db-fw-endip

  depends_on = [
    azurerm_mysql_database.jw_db
  ]
}

##### Dns_zone 생성 #####
resource "azurerm_private_dns_zone" "jw_dns" {
  name                = "${var.name}mysql.com"
  resource_group_name = azurerm_resource_group.jwrg.name
}

##### Dns_zone 가상 네트워크 설정 #####
resource "azurerm_private_dns_zone_virtual_network_link" "jw_dns_vnet" {
  name                  = "${var.name}_dns_vnet"
  resource_group_name   = azurerm_resource_group.jwrg.name
  private_dns_zone_name = azurerm_private_dns_zone.jw_dns.name
  virtual_network_id    = azurerm_virtual_network.vpc.id
}

##### Mysql Configuration #####
resource "azurerm_mysql_configuration" "jw_db_conf" {
  resource_group_name = azurerm_resource_group.jwrg.name
  server_name         = azurerm_mysql_server.jw_dbserver.name

  # mysql 서버 시간 맞추기
  name  = "time_zone"
  value = "+09:00"

  depends_on = [
    azurerm_mysql_database.jw_db
  ]
}

# DB & DB_sub endpoint 생성
resource "azurerm_private_endpoint" "jw_end" {
  name                = "${var.name}_end"
  location            = azurerm_resource_group.jwrg.location
  resource_group_name = azurerm_resource_group.jwrg.name
  subnet_id           = azurerm_subnet.db_subnet.id

  private_service_connection {
    name                           = "${var.name}_private_sc"
    private_connection_resource_id = azurerm_mysql_server.jw_dbserver.id
    is_manual_connection           = var.db-pri-ser-isconnec
    subresource_names              = ["mysqlServer"]
    request_message                   = "OK"
  }

  private_dns_zone_group {
    name                 = "private_dns_zone"
    private_dns_zone_ids = [azurerm_private_dns_zone.jw_dns.id]
  }

  depends_on = [
    azurerm_mysql_firewall_rule.jw_db_firewall
  ]
}