# ============================================================================
# Yamaha Search API - Terraform Variables
# ============================================================================

# ============================================================================
# Required Variables - Must be provided
# ============================================================================

variable "resource_group_name" {
  description = "Name of the existing Azure Resource Group"
  type        = string
}

variable "application_insights_id" {
  description = "Resource ID of the existing Application Insights instance"
  type        = string
}

# ============================================================================
# Optional Variables - Have defaults
# ============================================================================

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus2"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "prod"
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
