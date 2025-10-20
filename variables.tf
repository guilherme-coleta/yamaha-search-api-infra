# ============================================================================# ============================================================================

# Yamaha Search API - Terraform Variables# Yamaha Search API - Terraform Variables

# ============================================================================# ============================================================================



# ============================================================================# ============================================================================

# REQUIRED: Update these with your existing Azure resource names# Required Variables - Must be provided

# ============================================================================# ============================================================================



variable "resource_group_name" {variable "resource_group_name" {

  description = "Name of the existing Azure Resource Group"  description = "Name of the existing Azure Resource Group"

  type        = string  type        = string

}}



variable "application_insights_name" {variable "key_vault_name" {

  description = "Name of the existing Application Insights instance"  description = "Name of the existing Azure Key Vault"

  type        = string  type        = string

}}



# ============================================================================variable "search_service_name" {

# OPTIONAL: Customize these settings  description = "Name of the existing Azure AI Search service"

# ============================================================================  type        = string

}

variable "location" {

  description = "Azure region for resources"variable "openai_account_name" {

  type        = string  description = "Name of the existing Azure OpenAI account"

  default     = "eastus2"  type        = string

}}



variable "environment" {variable "cosmos_account_name" {

  description = "Environment name (dev, staging, prod)"  description = "Name of the existing Cosmos DB account"

  type        = string  type        = string

  default     = "prod"}

}

variable "web_app_name" {

# ============================================================================  description = "Name for the App Service (must be globally unique)"

# Monitoring & Alerts  type        = string

# ============================================================================}



variable "enable_alerts" {# ============================================================================

  description = "Enable Azure Monitor alerts"# Optional Variables - Have defaults

  type        = bool# ============================================================================

  default     = false

}variable "location" {

  description = "Azure region for resources"

variable "alert_email" {  type        = string

  description = "Email address for alert notifications"  default     = "eastus2"

  type        = string}

  default     = ""

}variable "environment" {

  description = "Environment name (dev, staging, prod)"

# ============================================================================  type        = string

# Tags  default     = "prod"

# ============================================================================}



variable "tags" {variable "app_service_plan_name" {

  description = "Tags to apply to all resources"  description = "Name for the App Service Plan"

  type        = map(string)  type        = string

  default = {  default     = "yamaha-search-plan"

    Project     = "Yamaha Search API"}

    ManagedBy   = "Terraform"

    Environment = "Production"variable "app_service_sku" {

  }  description = "SKU for App Service Plan (B1, B2, B3, S1, S2, S3, P1v2, P2v2, P3v2)"

}  type        = string

  default     = "B1"

  validation {
    condition     = can(regex("^(B[1-3]|S[1-3]|P[1-3]v[2-3]|F1|D1)$", var.app_service_sku))
    error_message = "Invalid SKU. Must be one of: F1, D1, B1-B3, S1-S3, P1v2-P3v2, P1v3-P3v3"
  }
}

variable "log_level" {
  description = "Application log level"
  type        = string
  default     = "INFO"

  validation {
    condition     = contains(["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"], var.log_level)
    error_message = "Log level must be one of: DEBUG, INFO, WARNING, ERROR, CRITICAL"
  }
}

variable "workers_count" {
  description = "Number of Gunicorn workers"
  type        = number
  default     = 4

  validation {
    condition     = var.workers_count >= 1 && var.workers_count <= 32
    error_message = "Workers count must be between 1 and 32"
  }
}

# ============================================================================
# Azure Service Configuration
# ============================================================================

variable "search_index_suffix" {
  description = "Suffix for Azure AI Search indices"
  type        = string
  default     = "prod"
}

variable "openai_api_version" {
  description = "Azure OpenAI API version"
  type        = string
  default     = "2024-02-01"
}

variable "openai_embedding_deployment" {
  description = "Name of the OpenAI embedding deployment"
  type        = string
  default     = "text-embedding-ada-002"
}

variable "openai_chat_deployment" {
  description = "Name of the OpenAI chat deployment"
  type        = string
  default     = "gpt-4"
}

variable "cosmos_database_name" {
  description = "Cosmos DB database name"
  type        = string
  default     = "yamaha-search"
}

variable "cosmos_collection_name" {
  description = "Cosmos DB collection name for chat history"
  type        = string
  default     = "chat-history"
}

# ============================================================================
# Security & Networking
# ============================================================================

variable "cors_allowed_origins" {
  description = "List of allowed CORS origins"
  type        = list(string)
  default     = ["*"]
}

variable "enable_application_insights" {
  description = "Enable Application Insights for monitoring"
  type        = bool
  default     = true
}

variable "enable_alerts" {
  description = "Enable Azure Monitor alerts"
  type        = bool
  default     = false
}

variable "alert_email" {
  description = "Email address for alert notifications"
  type        = string
  default     = ""
}

# ============================================================================
# Tags
# ============================================================================

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "Yamaha Search API"
    ManagedBy   = "Terraform"
    Environment = "Production"
  }
}
