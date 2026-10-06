resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-rg"
  location = var.location
  tags     = var.tags
}

module "network" {
  source         = "../modules/network"
  prefix         = var.prefix
  location       = var.location
  rg_name        = azurerm_resource_group.main.name
  address_space  = var.address_space
  subnet_prefix  = var.subnet_prefix
  allowed_cidr   = var.allowed_management_cidr
  tags           = var.tags
}

resource "azurerm_storage_account" "data" {
  name                     = "${var.prefix}nfdata${substr(md5(var.prefix), 0, 6)}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

resource "azurerm_storage_container" "evidence" {
  name                  = "evidence"
  storage_account_name  = azurerm_storage_account.data.name
  container_access_type = "private"
}

resource "azurerm_log_analytics_workspace" "ops" {
  name                = "${var.prefix}-law"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}
