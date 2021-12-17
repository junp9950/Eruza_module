#VPC 만들기
resource "azurerm_virtual_network" "jw_vpc" {
  name                = "jw-vpc"
  location            = azurerm_resource_group.jw_rg.location
  resource_group_name = azurerm_resource_group.jw_rg.name
  address_space       = ["10.0.0.0/16"] #대역폭(cider)


}
