# ============================================================================# ============================================================================

# Yamaha Search API - Terraform Outputs# Yamaha Search API - Terraform Outputs

# ============================================================================# ============================================================================



output "resource_group_name" {output "resource_group_name" {

  description = "Name of the resource group"  description = "Name of the resource group"

  value       = data.azurerm_resource_group.main.name  value       = data.azurerm_resource_group.main.name

}}



output "application_insights_id" {output "web_app_name" {

  description = "Resource ID of the Application Insights"  description = "Name of the App Service"

  value       = data.azurerm_application_insights.main.id  value       = azurerm_linux_web_app.main.name

}}



output "application_insights_instrumentation_key" {output "web_app_url" {

  description = "Application Insights instrumentation key"  description = "URL of the deployed application"

  value       = data.azurerm_application_insights.main.instrumentation_key  value       = "https://${azurerm_linux_web_app.main.default_hostname}"

  sensitive   = true}

}

output "web_app_id" {

output "application_insights_connection_string" {  description = "Resource ID of the App Service"

  description = "Application Insights connection string"  value       = azurerm_linux_web_app.main.id

  value       = data.azurerm_application_insights.main.connection_string}

  sensitive   = true

}output "managed_identity_principal_id" {

  description = "Principal ID of the App Service Managed Identity"

# ============================================================================  value       = azurerm_linux_web_app.main.identity[0].principal_id

# Workbook Outputs}

# ============================================================================

output "managed_identity_tenant_id" {

output "workbook_health_id" {  description = "Tenant ID of the App Service Managed Identity"

  description = "Resource ID of the API Health workbook"  value       = azurerm_linux_web_app.main.identity[0].tenant_id

  value       = azurerm_application_insights_workbook.api_health.id}

}

output "app_service_plan_id" {

output "workbook_search_analytics_id" {  description = "Resource ID of the App Service Plan"

  description = "Resource ID of the Search Analytics workbook"  value       = azurerm_service_plan.main.id

  value       = azurerm_application_insights_workbook.search_analytics.id}

}

output "application_insights_instrumentation_key" {

output "workbook_dependencies_id" {  description = "Application Insights instrumentation key"

  description = "Resource ID of the Dependencies workbook"  value       = var.enable_application_insights ? azurerm_application_insights.main[0].instrumentation_key : null

  value       = azurerm_application_insights_workbook.dependencies.id  sensitive   = true

}}



output "workbook_error_analysis_id" {output "application_insights_connection_string" {

  description = "Resource ID of the Error Analysis workbook"  description = "Application Insights connection string"

  value       = azurerm_application_insights_workbook.error_analysis.id  value       = var.enable_application_insights ? azurerm_application_insights.main[0].connection_string : null

}  sensitive   = true

}

output "workbook_urls" {

  description = "Direct URLs to access the workbooks in Azure Portal"output "deployment_info" {

  value = {  description = "Deployment information and next steps"

    health_dashboard = "https://portal.azure.com/#@/resource${azurerm_application_insights_workbook.api_health.id}"  value = {

    search_analytics = "https://portal.azure.com/#@/resource${azurerm_application_insights_workbook.search_analytics.id}"    app_url          = "https://${azurerm_linux_web_app.main.default_hostname}"

    dependencies     = "https://portal.azure.com/#@/resource${azurerm_application_insights_workbook.dependencies.id}"    api_docs_url     = "https://${azurerm_linux_web_app.main.default_hostname}/docs"

    error_analysis   = "https://portal.azure.com/#@/resource${azurerm_application_insights_workbook.error_analysis.id}"    health_check_url = "https://${azurerm_linux_web_app.main.default_hostname}/health"

  }    kudu_url         = "https://${azurerm_linux_web_app.main.name}.scm.azurewebsites.net"

}    portal_url       = "https://portal.azure.com/#@/resource${azurerm_linux_web_app.main.id}"

  }

# ============================================================================}

# Alert Outputs

# ============================================================================# ============================================================================

# Workbook Outputs

output "alerts_enabled" {# ============================================================================

  description = "Whether alerts are enabled"

  value       = var.enable_alertsoutput "workbook_health_id" {

}  description = "Resource ID of the API Health workbook"

  value       = azurerm_application_insights_workbook.api_health.id

output "action_group_id" {}

  description = "Resource ID of the action group (if alerts enabled)"

  value       = var.enable_alerts ? azurerm_monitor_action_group.main[0].id : nulloutput "workbook_search_analytics_id" {

}  description = "Resource ID of the Search Analytics workbook"

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

output "workbook_urls" {
  description = "Direct URLs to access the workbooks in Azure Portal"
  value = {
    health_dashboard     = "https://portal.azure.com/#@/resource${azurerm_application_insights_workbook.api_health.id}"
    search_analytics     = "https://portal.azure.com/#@/resource${azurerm_application_insights_workbook.search_analytics.id}"
    dependencies         = "https://portal.azure.com/#@/resource${azurerm_application_insights_workbook.dependencies.id}"
    error_analysis       = "https://portal.azure.com/#@/resource${azurerm_application_insights_workbook.error_analysis.id}"
  }
}
