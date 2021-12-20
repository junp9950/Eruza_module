# ILB
resource "azurerm_lb" "ilb" {
  name                = "${var.name}_ilb"
  location            = azurerm_resource_group.jwrg.location
  resource_group_name = azurerm_resource_group.jwrg.name
  sku                 = var.ilb_sku
  
  frontend_ip_configuration {
    name                          = var.ilb_front_ip
    subnet_id                     = azurerm_subnet.was_subnet.id
    private_ip_address_allocation = var.ilb_pip_allo
  }
}

# ilb back
resource "azurerm_lb_backend_address_pool" "ilb_back" {
  loadbalancer_id = azurerm_lb.ilb.id
  name            = "${var.name}_ilb_back"
}

# # ilb와 was 연결
# resource "azurerm_network_interface_backend_address_pool_association" "ilb_back_nif_ass" {
#   network_interface_id    = azurerm_network_interface.was_vm_nif.id
#   ip_configuration_name   = "was_vm_pub"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.ilb_back.id

#   depends_on = [
#     azurerm_virtual_machine.was_vm
#   ]
# }

# ilb probe
resource "azurerm_lb_probe" "ilb_probe" {
  resource_group_name = azurerm_resource_group.jwrg.name
  loadbalancer_id     = azurerm_lb.ilb.id
  name                = "${var.name}_ilb_probe"
  port                = var.ilb_probe_port
}

# ilb inbound
resource "azurerm_lb_rule" "ilb_rule" {
  name                           = "jwh_ilb_rule"
  resource_group_name            = azurerm_resource_group.jwrg.name
  loadbalancer_id                = azurerm_lb.ilb.id
  probe_id                       = azurerm_lb_probe.ilb_probe.id
  disable_outbound_snat          = true
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ilb_back.id]
  frontend_port                  = var.ilb_rule_front_port
  backend_port                   = var.ilb_rule_back_port
  frontend_ip_configuration_name = var.ilb_front_ip
  protocol                       = var.ilb_rule_proto
}
