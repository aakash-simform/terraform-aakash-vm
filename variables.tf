variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default = {
    environment = "Terraform Demo"
    owner       = "Aakash"
  }
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "Central India"
}

variable "azurerm_resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "agent"
}

variable "azurerm_public_ip_name" {
  description = "Name of the Azure Public IP"
  type        = string
  default     = "my-vm-public-ip"
}

variable "azurerm_public_ip_allocation_method" {
  description = "Allocation method for the Public IP"
  type        = string
  default     = "Static"
}

variable "azurerm_public_ip_sku" {
  description = "SKU for the Public IP"
  type        = string
  default     = "Standard"
}

variable "azurerm_network_security_group_name" {
  description = "Name of the Azure Network Security Group"
  type        = string
  default     = "my-nw-security-group"
}

variable "azurerm_network_security_group_security_rules" {
  description = "Security rules for the Network Security Group"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_ranges    = list(string)
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = [
    {
      name                       = "Allow-SSH"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_ranges    = ["22"]
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}

variable "azurerm_virtual_network_name" {
  description = "Name of the Azure Virtual Network"
  type        = string
  default     = "my-vm-network"
}

variable "azurerm_virtual_network_address_space" {
  description = "Address space for the Virtual Network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azurerm_subnet_name" {
  description = "Name of the Azure Subnet"
  type        = string
  default     = "my-vn-subnet"
}

variable "azurerm_subnet_address_prefix" {
  description = "Address prefixes for the Subnet"
  type        = string
  default     = "10.0.0.1/16"
}

variable "azurerm_network_interface_name" {
  description = "Name of the Azure Network Interface"
  type        = string
  default     = "my-vm-nic"
}

variable "azurerm_linux_virtual_machine_name" {
  description = "Name of the Azure Linux Virtual Machine"
  type        = string
  default     = "my-vm"
}

variable "azurerm_linux_virtual_machine_size" {
  description = "Size of the Azure Linux Virtual Machine"
  type        = string
  default     = "Standard_B1s"
}

variable "azurerm_linux_virtual_machine_admin_username" {
  description = "Admin username for the Azure Linux Virtual Machine"
  type        = string
  default     = "azureuser"
}

variable "azurerm_linux_virtual_machine_admin_password" {
  description = "Admin password for the Azure Linux Virtual Machine"
  type        = string
  default     = "P@ssw0rd1234!"
}

variable "azurerm_linux_virtual_machine_ssh_public_key" {
  description = "SSH public key for the Azure Linux Virtual Machine"
  type        = string
  default     = "ssh-rsa xxx"
}
