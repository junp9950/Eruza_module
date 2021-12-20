resource "azurerm_linux_virtual_machine" "jw_web" {
  name                  = "jwshin-web"
  location              = azurerm_resource_group.jwrg.location
  resource_group_name   = azurerm_resource_group.jwrg.name
  network_interface_ids = [azurerm_network_interface.web_vm_nif.id]
  zone                 = 1
  size                  = var.web-vm-size #VM 크기
  admin_username = var.webvm-username
  computer_name = var.webvm-comname
  admin_password = "tlswldnd123@"
  disable_password_authentication = false

 /* admin_ssh_key {
    username   = var.webvm-sshkey-user
    public_key = file("../../.ssh/id_rsa.pub")
  }
*/
  os_disk {
    caching              = var.webvm-disk-cach
    storage_account_type = var.webvm-disk-type
    name                 = "${var.name}_web_vm_disk"
  }

  source_image_reference {
    publisher = var.webvm-img-pub
    offer     = var.webvm-img-off
    sku       = var.webvm-img-sku
    version   = var.webvm-img-ver
  }
}