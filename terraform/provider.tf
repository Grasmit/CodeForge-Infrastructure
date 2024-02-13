# Azure Provider source and version being used
terraform {
    required_version = ">=0.12"
    required_providers {
         azapi = {
            source  = "azure/azapi"
            version = "~>1.5"
        }
         azurerm = {
            source  = "hashicorp/azurerm"
            version = "~>2.0"
        }
    }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
    features {}
}