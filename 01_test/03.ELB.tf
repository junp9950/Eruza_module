# ELB 설정
# public ip
# Front ip 설정
# backend , association
# probe 80, health
# inbound rule 80
# outbound rule
# Web nif

# ELB Public ip
resource "azurerm_public_ip" "elb_pub" {
  name                = "${var.name}_elb_pub"
  location            = azurerm_resource_group.jwrg.location
  resource_group_name = azurerm_resource_group.jwrg.name
  allocation_method   = var.elb_pub_allo
  sku                 = var.elb_pub_sku
  availability_zone   = 1

}

#ELB Front ip
resource "azurerm_lb" "elb" {
  name                = "${var.name}_elb"
  location            = azurerm_resource_group.jwrg.location
  resource_group_name = azurerm_resource_group.jwrg.name
  sku                 = var.elb_sku

  frontend_ip_configuration {
    name                 = var.front_ipcfg
    public_ip_address_id = azurerm_public_ip.elb_pub.id
  }
}

# ELB backend
resource "azurerm_lb_backend_address_pool" "elb_back" {
  loadbalancer_id = azurerm_lb.elb.id
  name            = "${var.name}_elb_back"
  depends_on = [
    azurerm_lb.elb
  ]
}

# ELB backend association
resource "azurerm_network_interface_backend_address_pool_association" "elb_back_nif_ass" {
  network_interface_id = azurerm_network_interface.web_vm_nif.id
  ip_configuration_name = "${var.name}_web_vm_pub"
  backend_address_pool_id = azurerm_lb_backend_address_pool.elb_back.id

  depends_on = [
    azurerm_lb_backend_address_pool.elb_back
  ]

}

#ELB probe
resource "azurerm_lb_probe" "elb_probe" {
  resource_group_name = azurerm_resource_group.jwrg.name
  loadbalancer_id = azurerm_lb.elb.id
  name = "${var.name}_elb_probe"
  protocol = var.elb_protocol
  request_path = var.elb_path
  port = var.elb_port
  
  depends_on = [
    azurerm_network_interface_backend_address_pool_association.elb_back_nif_ass
  ]
}

# ELB inbound rule
resource "azurerm_lb_rule" "elb_rule" {
  name                           = "${var.name}_elb_rule"
  resource_group_name            = azurerm_resource_group.jwrg.name
  loadbalancer_id                = azurerm_lb.elb.id
  probe_id                       = azurerm_lb_probe.elb_probe.id
  disable_outbound_snat          = true
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.elb_back.id]
  frontend_port                  = var.e_front_port
  backend_port                   = var.e_back_port
  frontend_ip_configuration_name = var.front_ipcfg
  protocol                       = var.elb_rule_proto

  depends_on = [
    azurerm_lb_probe.elb_probe
  ]
}

# ELB outbound rule
resource "azurerm_lb_outbound_rule" "elb_out" {
  resource_group_name      = azurerm_resource_group.jwrg.name
  loadbalancer_id          = azurerm_lb.elb.id
  name                     = "${var.name}_lb_out"
  protocol                 = var.elb_out_proto
  backend_address_pool_id  = azurerm_lb_backend_address_pool.elb_back.id
  allocated_outbound_ports = var.allo_out_ports

  frontend_ip_configuration {
    name = var.front_ipcfg
  }

  depends_on = [
    azurerm_lb_rule.elb_rule
  ]
}
