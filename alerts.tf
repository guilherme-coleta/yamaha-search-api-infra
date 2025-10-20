# ============================================================================
# Azure Monitor Alerts for Yamaha Search API
# ============================================================================
# Configures basic alerts for critical issues
# ============================================================================

# ============================================================================
# Action Group - Email/SMS notifications
# ============================================================================

resource "azurerm_monitor_action_group" "main" {
  count               = var.enable_alerts ? 1 : 0
  name                = "yamaha-api-alert-group"
  resource_group_name = data.azurerm_resource_group.main.name
  short_name          = "yamaha-api"

  email_receiver {
    name                    = "admin-email"
    email_address           = var.alert_email
    use_common_alert_schema = true
  }

  tags = var.tags
}

# ============================================================================
# Alert 1: High Error Rate
# ============================================================================

resource "azurerm_monitor_metric_alert" "high_error_rate" {
  count               = var.enable_alerts ? 1 : 0
  name                = "yamaha-api-high-error-rate"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [data.azurerm_application_insights.main.id]
  description         = "Alert when error rate exceeds 10 errors in 15min"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "microsoft.insights/components"
    metric_name      = "requests/failed"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = 10
  }

  action {
    action_group_id = azurerm_monitor_action_group.main[0].id
  }

  tags = var.tags
}

# ============================================================================
# Alert 2: High Response Time
# ============================================================================

resource "azurerm_monitor_metric_alert" "high_response_time" {
  count               = var.enable_alerts ? 1 : 0
  name                = "yamaha-api-high-response-time"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [data.azurerm_application_insights.main.id]
  description         = "Alert when average response time exceeds 5 seconds"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "microsoft.insights/components"
    metric_name      = "requests/duration"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 5000
  }

  action {
    action_group_id = azurerm_monitor_action_group.main[0].id
  }

  tags = var.tags
}

# ============================================================================
# Alert 3: Low Availability
# ============================================================================

resource "azurerm_monitor_metric_alert" "low_availability" {
  count               = var.enable_alerts ? 1 : 0
  name                = "yamaha-api-low-availability"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [data.azurerm_application_insights.main.id]
  description         = "Alert when availability drops below 99%"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "microsoft.insights/components"
    metric_name      = "availabilityResults/availabilityPercentage"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 99
  }

  action {
    action_group_id = azurerm_monitor_action_group.main[0].id
  }

  tags = var.tags
}

# ============================================================================
# Alert 4: Dependency Failures
# ============================================================================

resource "azurerm_monitor_metric_alert" "dependency_failures" {
  count               = var.enable_alerts ? 1 : 0
  name                = "yamaha-api-dependency-failures"
  resource_group_name = data.azurerm_resource_group.main.name
  scopes              = [data.azurerm_application_insights.main.id]
  description         = "Alert when dependency failures increase"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "microsoft.insights/components"
    metric_name      = "dependencies/failed"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = 5
  }

  action {
    action_group_id = azurerm_monitor_action_group.main[0].id
  }

  tags = var.tags
}
