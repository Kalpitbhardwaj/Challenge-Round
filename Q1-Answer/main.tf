terraform {
  required_version = "~> 1.3.0"
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = ">= 3.0"
    }
  }
  backend "azurerm" {
        resource_group_name  = "ProjectName-ResourceGroup"
        storage_account_name = "tfstate1"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }

