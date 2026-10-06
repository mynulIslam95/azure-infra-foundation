variable "prefix" { type = string }
variable "location" { type = string }
variable "rg_name" { type = string }
variable "address_space" { type = list(string) }
variable "subnet_prefix" { type = string }
variable "allowed_cidr" { type = string }
variable "tags" { type = map(string) }

resource "azurerm_virtual_network" "this" {
  name                = "${var.prefix}-vnet"
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "app" {
  name                 = "${var.prefix}-snet-app"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_prefix]
}

resource "azurerm_network_security_group" "app" {
  name                = "${var.prefix}-nsg-app"
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags

  security_rule {
    name                       = "allow-office-https"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = var.allowed_cidr
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "deny-ssh-internet"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}

output "vnet_id" { value = azurerm_virtual_network.this.id }
output "subnet_id" { value = azurerm_subnet.app.id }
output "nsg_id" { value = azurerm_network_security_group.app.id }
