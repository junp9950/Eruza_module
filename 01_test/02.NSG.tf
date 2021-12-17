resource "azurerm_network_security_group" "nsg_web" {
  name                = "${var.name}_nsg_web"
  location            = var.location
  resource_group_name = azurerm_resource_group.jwrg.name

  security_rule {
    name                       = "${var.name}_web_srule"
    priority                   = var.web_priority
    direction                  = var.web_direction
    access                     = var.web_access
    protocol                   = var.web_protocol
    source_port_range          = var.web_sport
    destination_port_range     = var.web_dport
    source_address_prefix      = var.web_sprefix
    destination_address_prefix = var.web_dprefix
  }
  depends_on = [
    azurerm_subnet.web_subnet
  ]


}

resource "azurerm_network_security_group" "nsg_was" {
  name                = "${var.name}_nsg_was"
  location            = var.location
  resource_group_name = azurerm_resource_group.jwrg.name

  security_rule {
    name                       = "${var.name}_was_srule"
    priority                   = var.was_priority  #우선순위
    direction                  = var.was_direction #방향(in,out)
    access                     = var.was_access    #작업(허용,거부)
    protocol                   = var.was_protocol  #프로토콜
    source_port_range          = var.was_sport     #원본포트범위d
    destination_port_range    = var.was_dport     #대상포트범위 (실제포트번호)
    source_address_prefix      = var.was_sprefix
    destination_address_prefix = var.was_dprefix
  }

  depends_on = [
    azurerm_subnet.was_subnet
  ]


#
}

resource "azurerm_network_security_group" "jw_nsg_db" {
  name                = "${var.name}_nsg_db"
  location            = var.location
  resource_group_name = azurerm_resource_group.jwrg.name

  security_rule {
    name                       = "${var.name}_db_srule"
    priority                   = var.db_priority  #우선순위
    direction                  = var.db_direction #방향(in,out)
    access                     = var.db_access    #작업(허용,거부)
    protocol                   = var.db_protocol  #프로토콜
    source_port_range          = var.db_sport     #원본포트범위
    destination_port_range    = var.db_dport     #대상포트범위 (실제포트번호)
    source_address_prefix      = var.db_sprefix
    destination_address_prefix = var.db_dprefix
  }

  depends_on = [
    azurerm_subnet.db_subnet
  ]

}

/*resource "azurerm_network_security_group" "jw_nsg_was_img" {
  name                = "nsg-was-img"
  location            = azurerm_resource_group.jw_rg.location
  resource_group_name = azurerm_resource_group.jw_rg.name

  security_rule {
    name                       = "${var.name}_db_srule"
    priority                   = var.db_priority  #우선순위
    direction                  = var.db_direction #방향(in,out)
    access                     = var.db_access    #작업(허용,거부)
    protocol                   = var.db_protocol  #프로토콜
    source_port_range          = var.db_sport     #원본포트범위
    destination_port_ranges    = var.db_dport     #대상포트범위 (실제포트번호)
    source_address_prefix      = var.db_sprefix
    destination_address_prefix = var.db_dprefix
  }


  depends_on = [
    azurerm_subnet.was_img_subnet
  ]

}
*/