# ============================================================================# ============================================================================

# Yamaha Search API - Monitoring & Workbooks Configuration# Yamaha Search API - Monitoring & Workbooks Configuration

# ============================================================================# ============================================================================

# Creates Workbooks and Alerts for monitoring# Creates Application Insights, Workbooks and Alerts for monitoring

# References existing Application Insights# Assumes Application Insights already exists - references it

# ============================================================================# ============================================================================



terraform {terraform {

  required_version = ">= 1.5"  required_version = ">= 1.5"

    

  required_providers {  required_providers {

    azurerm = {    azurerm = {

      source  = "hashicorp/azurerm"      source  = "hashicorp/azurerm"

      version = "~> 3.80"      version = "~> 3.80"

    }    }

  }  }

}}



provider "azurerm" {provider "azurerm" {

  features {}  features {}

}}



# ============================================================================# ============================================================================

# Data Sources - Reference existing Azure resources# Data Sources - Reference existing Azure resources

# ============================================================================# ============================================================================



data "azurerm_client_config" "current" {}data "azurerm_client_config" "current" {}



# Reference existing Resource Group# Reference existing Resource Group

data "azurerm_resource_group" "main" {data "azurerm_resource_group" "main" {

  name = var.resource_group_name  name = var.resource_group_name

}}



# Reference existing Application Insights# Reference existing Application Insights

data "azurerm_application_insights" "main" {data "azurerm_application_insights" "main" {

  name                = var.application_insights_name  name                = var.application_insights_name

  resource_group_name = var.resource_group_name  resource_group_name = var.resource_group_name

}}

