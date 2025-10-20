# ============================================================================
# Yamaha Search API - Terraform Outputs
# ============================================================================

output "resource_group_name" {
  description = "Name of the resource group"
  value       = data.azurerm_resource_group.main.name
}

output "application_insights_id" {
  description = "Resource ID of the Application Insights"
  value       = data.azurerm_application_insights.main.id
}

output "application_insights_instrumentation_key" {
  description = "Application Insights instrumentation key"
  value       = data.azurerm_application_insights.main.instrumentation_key
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "Application Insights connection string"
  value       = data.azurerm_application_insights.main.connection_string
  sensitive   = true
}

output "workbook_health_id" {
  description = "Resource ID of the API Health workbook"
  value       = azurerm_application_insights_workbook.api_health.id
}

output "workbook_search_analytics_id" {
  description = "Resource ID of the Search Analytics workbook"
  value       = azurerm_application_insights_workbook.search_analytics.id
}

output "workbook_dependencies_id" {
  description = "Resource ID of the Dependencies workbook"
  value       = azurerm_application_insights_workbook.dependencies.id
}

output "workbook_error_analysis_id" {
  description = "Resource ID of the Error Analysis workbook"
  value       = azurerm_application_insights_workbook.error_analysis.id
}

output "alert_action_group_id" {
  description = "Resource ID of the alert action group"
  value       = var.enable_alerts ? azurerm_monitor_action_group.main[0].id : null
}
