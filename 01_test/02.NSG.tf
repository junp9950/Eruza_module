# Port 80
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
    destination_port_ranges    = var.web_dport
    source_address_prefix      = var.web_sprefix
    destination_address_prefix = var.web_dprefix
  }
  depends_on = [
    azurerm_subnet.web_subnet
  ]


}
# Web security group과 web subnet 합침
resource "azurerm_subnet_network_security_group_association" "nsgass_web" {
  subnet_id                 = azurerm_subnet.web_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_web.id
  depends_on = [
    azurerm_network_security_group.nsg_web
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
    destination_port_ranges    = var.was_dport     #대상포트범위 (실제포트번호)
    source_address_prefix      = var.was_sprefix
    destination_address_prefix = var.was_dprefix
  }

  depends_on = [
    azurerm_subnet.was_subnet
  ]

}

  # Was security group과 was subnet 합침
 resource "azurerm_subnet_network_security_group_association" "nsgass_was" {
  subnet_id                 = azurerm_subnet.was_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_was.id
  depends_on = [
    azurerm_network_security_group.nsg_was
  ]
}


resource "azurerm_network_security_group" "nsg_db" {
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
    destination_port_range     = var.db_dport     #대상포트범위 (실제포트번호)
    source_address_prefix      = var.db_sprefix
    destination_address_prefix = var.db_dprefix
  }

  depends_on = [
    azurerm_subnet.db_subnet
  ]

}

# DB security group과 DB subnet 합침
resource "azurerm_subnet_network_security_group_association" "jwh_nsgass_db" {
  subnet_id                 = azurerm_subnet.db_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_db.id
  depends_on = [
    azurerm_network_security_group.nsg_db
  ]
}

resource "azurerm_network_security_group" "nsg_img" {
  name                = "${var.name}_nsg_img"
  location            = azurerm_resource_group.jwrg.location
  resource_group_name = azurerm_resource_group.jwrg.name

  security_rule {
    name                       = "${var.name}_img_srule"
    priority                   = var.img_priority  #우선순위
    direction                  = var.img_direction #방향(in,out)
    access                     = var.img_access    #작업(허용,거부)
    protocol                   = var.img_protocol  #프로토콜
    source_port_range          = var.img_sport     #원본포트범위
    destination_port_ranges    = var.img_dport     #대상포트범위 (실제포트번호)
    source_address_prefix      = var.img_sprefix
    destination_address_prefix = var.img_dprefix
  }


  depends_on = [
    azurerm_subnet.img_subnet
  ]

}

# Was_img security group과 Was_img subnet 합침
resource "azurerm_subnet_network_security_group_association" "nsgass_img" {
  subnet_id                 = azurerm_subnet.img_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_img.id
  depends_on = [
    azurerm_network_security_group.nsg_img
  ]
}

# Bastion 생성
# Bastion 공용IP 연결
resource "azurerm_public_ip" "bastion_pub" {
  name                = "${var.name}_bastion_pub"
  location            = azurerm_resource_group.jwrg.location
  resource_group_name = azurerm_resource_group.jwrg.name
  allocation_method   = var.bas_allocation
  sku                 = var.bas_sku
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = "${var.name}_bastion_host"
  location            = azurerm_resource_group.jwrg.location
  resource_group_name = azurerm_resource_group.jwrg.name

  ip_configuration {
    name                 = "AzureBastionHost"
    subnet_id            = azurerm_subnet.AzureBastionSubnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pub.id
  }
}
# Web 가상머신 서브넷 인터페이스 생성
resource "azurerm_network_interface" "web_vm_nif" {
  name                = "${var.name}_web_vm_nif"
  location            = azurerm_resource_group.jwrg.location
  resource_group_name = azurerm_resource_group.jwrg.name

  ip_configuration {
    name                          = "${var.name}_web_vm_pub"
    subnet_id                     = azurerm_subnet.web_subnet.id
    private_ip_address_allocation = var.web_ipcfg
  }
  
  depends_on = [
    azurerm_subnet_network_security_group_association.nsgass_web
  ]
}