terraform {
  required_version = ">= 1.0" #Terraform version you want to use in your project
  backend "azurerm" { #to store terraform state file
    resource_group_name  = "terraformstatefile-rg"
    storage_account_name = "projectnametfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.94.0"
    }
  }
}

