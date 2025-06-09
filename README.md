# Azure Virtual Machine Terraform Module

A comprehensive Terraform module for deploying a complete Azure Linux Virtual Machine infrastructure with all necessary networking components.

## 🏗️ Architecture

This module creates a complete Azure VM infrastructure including:

- **Resource Group** - Container for all resources
- **Virtual Network** - Network isolation and communication
- **Subnet** - Network segmentation within the VNet
- **Public IP** - External connectivity
- **Network Security Group** - Firewall rules and security
- **Network Interface** - VM network connectivity
- **Linux Virtual Machine** - Ubuntu 22.04 LTS VM

## 📋 Features

- ✅ Complete VM infrastructure deployment
- ✅ Configurable VM sizes and specifications
- ✅ SSH key-based authentication
- ✅ Customizable network security rules
- ✅ Password authentication support
- ✅ Flexible network configuration
- ✅ Resource tagging support
- ✅ Modular and reusable design

## 🚀 Quick Start

### Basic Usage

```hcl
module "azure_vm" {
  source = "./module"
  
  # Basic Configuration
  location                    = "Central India"
  azurerm_resource_group_name = "my-vm-rg"
  
  # VM Configuration
  azurerm_linux_virtual_machine_name         = "my-linux-vm"
  azurerm_linux_virtual_machine_size         = "Standard_B1s"
  azurerm_linux_virtual_machine_admin_username = "adminuser"
  azurerm_linux_virtual_machine_admin_password = "YourSecurePassword123!"
  azurerm_linux_virtual_machine_ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2E..."
  
  # Network Configuration
  azurerm_virtual_network_name          = "my-vnet"
  azurerm_virtual_network_address_space = "10.0.0.0/16"
  azurerm_subnet_name                   = "my-subnet"
  azurerm_subnet_address_prefix         = "10.0.1.0/24"
  
  # Public IP Configuration
  azurerm_public_ip_name              = "my-vm-public-ip"
  azurerm_public_ip_allocation_method = "Static"
  azurerm_public_ip_sku               = "Standard"
}
```

### Advanced Usage with Custom Security Rules

```hcl
module "azure_vm" {
  source = "./module"
  
  location                    = "East US"
  azurerm_resource_group_name = "production-vm-rg"
  
  # Custom Security Rules
  azurerm_network_security_group_security_rules = [
    {
      name                       = "Allow-SSH"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_ranges    = ["22"]
      source_address_prefix      = "10.0.0.0/8"
      destination_address_prefix = "*"
    },
    {
      name                       = "Allow-HTTP"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_ranges    = ["80"]
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "Allow-HTTPS"
      priority                   = 1002
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_ranges    = ["443"]
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
  
  # Custom Tags
  common_tags = {
    environment = "Production"
    owner       = "DevOps Team"
    project     = "Web Application"
    cost_center = "Engineering"
  }
}
```

## 📚 Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 4.30.0 |

## 🔧 Providers

| Name | Version |
|------|---------|
| azurerm | >= 4.30.0 |

## 📋 Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| location | Azure region where resources will be created | `string` | `"Central India"` | no |
| azurerm_resource_group_name | Name of the Azure Resource Group | `string` | `"agent"` | no |
| azurerm_public_ip_name | Name of the Azure Public IP | `string` | `"my-vm-public-ip"` | no |
| azurerm_public_ip_allocation_method | Allocation method for the Public IP (Static/Dynamic) | `string` | `"Static"` | no |
| azurerm_public_ip_sku | SKU for the Public IP (Basic/Standard) | `string` | `"Standard"` | no |
| azurerm_network_security_group_name | Name of the Azure Network Security Group | `string` | `"my-nw-security-group"` | no |
| azurerm_network_security_group_security_rules | Security rules for the Network Security Group | `list(object)` | SSH rule | no |
| azurerm_virtual_network_name | Name of the Azure Virtual Network | `string` | `"my-vm-network"` | no |
| azurerm_virtual_network_address_space | Address space for the Virtual Network | `string` | `"10.0.0.0/16"` | no |
| azurerm_subnet_name | Name of the Azure Subnet | `string` | `"my-vn-subnet"` | no |
| azurerm_subnet_address_prefix | Address prefix for the Subnet | `string` | `"10.0.1.0/24"` | no |
| azurerm_network_interface_name | Name of the Azure Network Interface | `string` | `"my-vm-nic"` | no |
| azurerm_linux_virtual_machine_name | Name of the Azure Linux Virtual Machine | `string` | `"my-vm"` | no |
| azurerm_linux_virtual_machine_size | Size of the Azure Linux Virtual Machine | `string` | `"Standard_B1s"` | no |
| azurerm_linux_virtual_machine_admin_username | Admin username for the Linux VM | `string` | `"azureuser"` | no |
| azurerm_linux_virtual_machine_admin_password | Admin password for the Linux VM | `string` | `"P@ssw0rd1234!"` | no |
| azurerm_linux_virtual_machine_ssh_public_key | SSH public key for the Linux VM | `string` | Default key | no |
| common_tags | Common tags to be applied to all resources | `map(string)` | See variables.tf | no |

## 📤 Outputs

| Name | Description |
|------|-------------|
| network_interface_id | ID of the Azure Network Interface |
| network_interface_name | Name of the Azure Network Interface |
| public_ip_id | ID of the Azure Public IP |

## 🏗️ Resources Created

This module creates the following Azure resources:

- `azurerm_resource_group` - Resource group to contain all resources
- `azurerm_public_ip` - Public IP address for external connectivity
- `azurerm_network_security_group` - Network security group with firewall rules
- `azurerm_virtual_network` - Virtual network for network isolation (via module)
- `azurerm_subnet` - Subnet within the virtual network (via module)
- `azurerm_network_interface` - Network interface for the VM (via module)
- `azurerm_network_interface_security_group_association` - Associates NSG with NIC
- `azurerm_linux_virtual_machine` - Ubuntu 22.04 LTS virtual machine

## 🔗 Dependencies

This module uses external Terraform modules:

- `iankesh/virtual-network/azure` - For creating virtual networks
- `iankesh/subnet/azure` - For creating subnets
- `iankesh/network-interface/azure` - For creating network interfaces

## 📖 Examples

### Example 1: Development Environment

```hcl
module "dev_vm" {
  source = "./module"
  
  location                    = "Central India"
  azurerm_resource_group_name = "dev-vm-rg"
  
  azurerm_linux_virtual_machine_name = "dev-web-server"
  azurerm_linux_virtual_machine_size = "Standard_B2s"
  
  common_tags = {
    environment = "Development"
    owner       = "Development Team"
  }
}
```

### Example 2: Production Environment with Enhanced Security

```hcl
module "prod_vm" {
  source = "./module"
  
  location                    = "East US"
  azurerm_resource_group_name = "prod-vm-rg"
  
  azurerm_linux_virtual_machine_name = "prod-app-server"
  azurerm_linux_virtual_machine_size = "Standard_D2s_v3"
  
  # Restrict SSH access to specific IP range
  azurerm_network_security_group_security_rules = [
    {
      name                       = "Allow-SSH-Restricted"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_ranges    = ["22"]
      source_address_prefix      = "203.0.113.0/24"  # Your office IP range
      destination_address_prefix = "*"
    }
  ]
  
  common_tags = {
    environment = "Production"
    owner       = "Operations Team"
    backup      = "daily"
  }
}
```

## 🔐 Security Considerations

1. **SSH Keys**: Always use SSH keys for authentication in production
2. **Network Security Groups**: Configure appropriate firewall rules
3. **Password Policy**: Use strong passwords if password authentication is enabled
4. **Source IP Restrictions**: Limit SSH access to known IP ranges
5. **Regular Updates**: Keep the VM updated with latest security patches

## 🚦 VM Sizes

Common VM sizes you can use:

| Size | vCPUs | RAM | Use Case |
|------|-------|-----|----------|
| Standard_B1s | 1 | 1 GB | Development/Testing |
| Standard_B2s | 2 | 4 GB | Small applications |
| Standard_D2s_v3 | 2 | 8 GB | General purpose |
| Standard_D4s_v3 | 4 | 16 GB | Medium workloads |

## 🛠️ Troubleshooting

### Common Issues

1. **CIDR Notation Error**: Ensure subnet address prefix uses valid CIDR notation (e.g., `10.0.1.0/24`)
2. **Resource Name Conflicts**: Use unique resource names across your Azure subscription
3. **SSH Key Format**: Ensure SSH public key is in the correct format

### Validation Commands

```bash
# Validate Terraform configuration
terraform validate

# Plan deployment
terraform plan

# Apply changes
terraform apply
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📝 License

This module is licensed under the MIT License. See LICENSE file for details.

## 👥 Authors

- **Aakash Shah** - *Initial work* - [@aakash-shah](https://github.com/aakash-shah)

## 🆘 Support

For support and questions:

1. Check the [Issues](https://github.com/your-username/azure-vm-terraform-module/issues) page
2. Create a new issue with detailed information
3. Provide Terraform version and error messages

---

Made with ❤️ for the Terraform community