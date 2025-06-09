output "network_interface_id" {
  description = "ID of the Azure Network Interface"
  value       = module.az_network_interface.az_network_interface_id
}

output "network_interface_name" {
  description = "Name of the Azure Network Interface"
  value       = module.az_network_interface.az_network_interface_name
}

output "public_ip_id" {
  description = "ID of the Azure Public IP"
  value       = azurerm_public_ip.my-vm-public-ip.id
}