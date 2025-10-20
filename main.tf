# ============================================================================
# Yamaha Search API - Monitoring & Workbooks Configuration
# ============================================================================

terraform {
  required_version = ">= 1.5"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# ============================================================================
# Data Sources
# ============================================================================

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_application_insights" "main" {
  resource_group_name = data.azurerm_resource_group.main.name
  name                = split("/", var.application_insights_id)[8]
}
