output "resource_group" {
  value = azurerm_resource_group.main.name
}

output "vnet_id" {
  value = module.network.vnet_id
}

output "subnet_id" {
  value = module.network.subnet_id
}

output "nsg_id" {
  value = module.network.nsg_id
}

output "storage_account" {
  value = azurerm_storage_account.data.name
}

output "log_analytics" {
  value = azurerm_log_analytics_workspace.ops.name
}
