terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.88.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "268a434d-f7e6-4966-bb27-d29e20a1b360"
}

resource "azurerm_resource_group" "jwrg" { #리소스그룹 만들기
  name     = "${var.name}_rg"                    #리소스스룹 이름
  location = var.location                #지역(한국중부)
}
#VPC
resource "azurerm_virtual_network" "vpc" {
  name                = "${var.name}_vpc"
  resource_group_name = azurerm_resource_group.jwrg.name
  location            = var.location
  address_space       = [var.vnetcidr]
}

#Subnet
resource "azurerm_subnet" "web_subnet" {
  name                 = "${var.name}_web_sub"
  resource_group_name  = azurerm_resource_group.jwrg.name
  virtual_network_name = azurerm_virtual_network.vpc.name
  address_prefixes       = [var.websubnetcidr]
}

resource "azurerm_subnet" "was_subnet" {
  name                 = "${var.name}_was_sunbet"
  resource_group_name  = azurerm_resource_group.jwrg.name
  virtual_network_name = azurerm_virtual_network.vpc.name
  address_prefixes       = [var.wassubnetcidr]
}

resource "azurerm_subnet" "db_subnet" {
  name                 = "${var.name}_db_subnet"
  resource_group_name  = azurerm_resource_group.jwrg.name
  virtual_network_name = azurerm_virtual_network.vpc.name
  address_prefixes      = [var.dbsubnetcidr]
}

resource "azurerm_subnet" "AzureBastionSubnet" { #애저베스천 사용을 위해선 무조건 AzureBastionSubnet 사용
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.jwrg.name
  virtual_network_name = azurerm_virtual_network.vpc.name
  address_prefixes     = [var.bassubnetcidr] #IP주소d
}

resource "azurerm_subnet" "img_subnet" {
  name                 = "${var.name}_img_subnet"
  resource_group_name  = azurerm_resource_group.jwrg.name
  virtual_network_name = azurerm_virtual_network.vpc.name
  address_prefixes      = [var.imgsubnetcidr]
}
