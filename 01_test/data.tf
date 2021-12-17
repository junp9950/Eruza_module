variable "name" {
  type    = string
  default = "jw"
}
variable "location" {
  type    = string
  default = "koreacentral"
}
variable "vnetcidr" {
  type    = string
  default = "172.16.0.0/16"
}
##============Subnet=========================
variable "websubnetcidr" {
  type    = string
  default = "172.16.1.0/24"
}

variable "wassubnetcidr" {
  type    = string
  default = "172.16.2.0/24"
}

variable "dbsubnetcidr" {
  type    = string
  default = "172.16.3.0/24"
}

variable "bassubnetcidr" {
  type    = string
  default = "172.16.4.0/24"
}
variable "imgsubnetcidr" {
  type    = string
  default = "172.16.5.0/24"
}
#=========web_nsg_rule============================
variable "web_priority" {
  type    = string
  default = "101"
}

variable "web_direction" {
  type    = string
  default = "Inbound"
}

variable "web_access" {
  type    = string
  default = "Allow"
}

variable "web_protocol" {
  type    = string
  default = "Tcp"
}

variable "web_sport" {
  type    = string
  default = "*"
}

variable "web_dport" {
  type    = list(string)
  default = ["80" , "22"]
}

variable "web_sprefix" {
  type    = string
  default = "*"
}

variable "web_dprefix" {
  type    = string
  default = "*"
}
#===========was_nsg_rule===========================
variable "was_priority" {
  type    = string
  default = "102"
}

variable "was_direction" {
  type    = string
  default = "Inbound"
}

variable "was_access" {
  type    = string
  default = "Allow"
}

variable "was_protocol" {
  type    = string
  default = "Tcp"
}

variable "was_sport" {
  type    = string
  default = "*"
}

variable "was_dport" {
  type    = list(string)
  default = ["8080" , "22"]
}

variable "was_sprefix" {
  type    = string
  default = "*"
}

variable "was_dprefix" {
  type    = string
  default = "*"
}
#===========db_nsg_rule=======================

variable "db_priority" {
  type    = string
  default = "100"
}

variable "db_direction" {
  type    = string
  default = "Inbound"
}

variable "db_access" {
  type    = string
  default = "Allow"
}

variable "db_protocol" {
  type    = string
  default = "Tcp"
}

variable "db_sport" {
  type    = string
  default = "*"
}

variable "db_dport" {
  type    = string
  default = "3306"
}

variable "db_sprefix" {
  type    = string
  default = "*"
}

variable "db_dprefix" {
  type    = string
  default = "*"
}
#####################IMG_nsg_rule#######################
variable "img_priority" {
  type    = string
  default = "103"
}

variable "img_direction" {
  type    = string
  default = "Inbound"
}

variable "img_access" {
  type    = string
  default = "Allow"
}

variable "img_protocol" {
  type    = string
  default = "Tcp"
}

variable "img_sport" {
  type    = string
  default = "*"
}

variable "img_dport" {
  type    = list(string)
  default = ["80" , "8080" , "22"]
}

variable "img_sprefix" {
  type    = string
  default = "*"
}

variable "img_dprefix" {
  type    = string
  default = "*"
}
