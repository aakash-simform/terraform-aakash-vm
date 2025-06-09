terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.30.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "12fd17ea-0bfb-4ace-b444-f135064c14d9"
}
