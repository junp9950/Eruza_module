
resource "azurerm_network_interface" "jw_was_nif" {
    name = "jw_was_nif"
    location = azurerm_resource_group.jwrg.location
    resource_group_name = azurerm_resource_group.jwrg.name

    ip_configuration {
      name = "was_vm_pub"
      subnet_id = azurerm_subnet.was_subnet.id
      private_ip_address_allocation = "Dynamic"
    }
  
}
resource "azurerm_public_ip" "jw_pub_was_ip" {
  name                = "jw_pub_was_ip"
  resource_group_name = azurerm_resource_group.jwrg.name
  location            = azurerm_resource_group.jwrg.location
  allocation_method   = var.was-pubip-allo
  sku                 = var.was-pubip-sku
}

resource "azurerm_virtual_machine" "jw_was" {
  name                  = "${var.name}_was"
  location              = azurerm_resource_group.jwrg.location
  resource_group_name   = azurerm_resource_group.jwrg.name
  network_interface_ids = [azurerm_network_interface.jw_was_nif.id]
  vm_size               = var.was-vm-size
  zones                 = [1]

  storage_os_disk {
    name              = "${var.name}_was_disk"
    caching           = var.wasvm-disk-cach
    create_option     = var.wasvm-disk-opt
    managed_disk_type = var.wasvm-disk-type
  }


  storage_image_reference {
    publisher = var.wasvm-img-pub
    offer     = var.wasvm-img-off
    sku       = var.wasvm-img-sku
    version   = var.wasvm-img-ver
  }
  os_profile {
    computer_name  = var.wasvm-os-comname
    admin_username = var.wasvm-os-username
    admin_password = var.wasvm-os-userpw
  }

  os_profile_linux_config {
    disable_password_authentication = var.wasvm-dis-pw-auth
  }
}