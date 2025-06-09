resource "azurerm_resource_group" "my-resource-group" {
  name     = var.azurerm_resource_group_name
  location = var.location
  tags     = var.common_tags
}

resource "azurerm_public_ip" "my-vm-public-ip" {
  name                = var.azurerm_public_ip_name
  location            = var.location
  resource_group_name = var.azurerm_resource_group_name
  allocation_method   = var.azurerm_public_ip_allocation_method
  sku                 = var.azurerm_public_ip_sku
  tags                = var.common_tags
  depends_on          = [azurerm_resource_group.my-resource-group]
}

resource "azurerm_network_security_group" "my-nw-security-group" {
  name                = var.azurerm_network_security_group_name
  location            = var.location
  resource_group_name = var.azurerm_resource_group_name
  tags                = var.common_tags
  depends_on          = [azurerm_resource_group.my-resource-group]
  dynamic "security_rule" {
    for_each = var.azurerm_network_security_group_security_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_ranges    = security_rule.value.destination_port_ranges
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

module "az_virtual_network" {
  source              = "iankesh/virtual-network/azure"
  name                = var.azurerm_virtual_network_name
  resource_group_name = var.azurerm_resource_group_name
  address_space       = var.azurerm_virtual_network_address_space
  depends_on          = [azurerm_resource_group.my-resource-group]
}

module "az_subnet" {
  source              = "iankesh/subnet/azure"
  name                = var.azurerm_subnet_name
  resource_group_name = var.azurerm_resource_group_name
  vnet_name           = var.azurerm_virtual_network_name
  address_prefix      = var.azurerm_subnet_address_prefix
  depends_on          = [azurerm_resource_group.my-resource-group, module.az_virtual_network]
}

module "az_network_interface" {
  source                = "iankesh/network-interface/azure"
  name                  = "ankesh-network-interface"
  resource_group_name   = var.azurerm_resource_group_name
  vnet_name             = var.azurerm_virtual_network_name
  subnet_name           = var.azurerm_subnet_name
  private_ip_allocation = "Dynamic"
  public_ip_id          = azurerm_public_ip.my-vm-public-ip.id
  public_ip_name        = azurerm_public_ip.my-vm-public-ip.name
  depends_on            = [azurerm_resource_group.my-resource-group, module.az_subnet]
}

resource "azurerm_network_interface_security_group_association" "azurevm-sg" {
  network_interface_id      = module.az_network_interface.az_network_interface_id
  network_security_group_id = azurerm_network_security_group.my-nw-security-group.id
}

resource "azurerm_linux_virtual_machine" "my-vm" {
  name                            = var.azurerm_linux_virtual_machine_name
  resource_group_name             = var.azurerm_resource_group_name
  location                        = var.location
  size                            = var.azurerm_linux_virtual_machine_size
  admin_username                  = var.azurerm_linux_virtual_machine_admin_username
  admin_password                  = var.azurerm_linux_virtual_machine_admin_password
  disable_password_authentication = false
  admin_ssh_key {
    username   = var.azurerm_linux_virtual_machine_admin_username
    public_key = var.azurerm_linux_virtual_machine_ssh_public_key
  }
  network_interface_ids = [
    module.az_network_interface.az_network_interface_id
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  tags = var.common_tags
}