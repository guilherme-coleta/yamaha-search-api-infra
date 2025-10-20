# ============================================================================
# Azure Monitor Workbooks for Yamaha Search API
# ============================================================================
# Creates interactive dashboards for monitoring API health, performance,
# search analytics, and error tracking
# ============================================================================

# ============================================================================
# Workbook 1: API Health Dashboard
# ============================================================================

resource "azurerm_application_insights_workbook" "api_health" {
  name                = "yamaha-api-health-wb"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = var.location
  display_name        = "Yamaha API - Health Dashboard"
  
  data_json = jsonencode({
    version = "Notebook/1.0"
    items = [
      {
        type = 1
        content = {
          json = "## 🏥 Yamaha Search API - Health Dashboard\\n\\nOverview of API availability, performance, and resource utilization."
        }
      },
      {
        type = 3
        content = {
          version = "KqlItem/1.0"
          query = "requests\\n| where timestamp > ago(1h)\\n| summarize \\n    TotalRequests = count(),\\n    SuccessRate = countif(success == true) * 100.0 / count(),\\n    AvgDuration = avg(duration),\\n    P50Duration = percentile(duration, 50),\\n    P95Duration = percentile(duration, 95),\\n    P99Duration = percentile(duration, 99)\\n| project \\n    TotalRequests,\\n    SuccessRate = round(SuccessRate, 2),\\n    AvgDuration = round(AvgDuration, 2),\\n    P50Duration = round(P50Duration, 2),\\n    P95Duration = round(P95Duration, 2),\\n    P99Duration = round(P99Duration, 2)"
          size = 3
          title = "📊 Performance Summary (Last Hour)"
          queryType = 0
          resourceType = "microsoft.insights/components"
          visualization = "table"
        }
      },
      {
        type = 3
        content = {
          version = "KqlItem/1.0"
          query = "requests\\n| where timestamp > ago(24h)\\n| summarize RequestCount = count() by bin(timestamp, 5m), resultCode\\n| render timechart"
          size = 0
          title = "📈 Requests Over Time (24h) - By Status Code"
          queryType = 0
          resourceType = "microsoft.insights/components"
          visualization = "timechart"
        }
      },
      {
        type = 3
        content = {
          version = "KqlItem/1.0"
          query = "requests\\n| where timestamp > ago(1h)\\n| summarize Count = count() by name\\n| order by Count desc\\n| take 10\\n| render barchart"
          size = 0
          title = "🔝 Top 10 Endpoints (Last Hour)"
          queryType = 0
          resourceType = "microsoft.insights/components"
          visualization = "barchart"
        }
      },
      {
        type = 3
        content = {
          version = "KqlItem/1.0"
          query = "requests\\n| where timestamp > ago(24h)\\n| summarize Count = count() by resultCode\\n| render piechart"
          size = 1
          title = "📊 Status Code Distribution (24h)"
          queryType = 0
          resourceType = "microsoft.insights/components"
          visualization = "piechart"
        }
      }
    ]
    styleSettings = {}
    $schema = "https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json"
  })

  tags = merge(var.tags, {
    WorkbookType = "Health"
  })
}

# ============================================================================
# Workbook 2: Search Analytics Dashboard
# ============================================================================

resource "azurerm_application_insights_workbook" "search_analytics" {
  name                = "yamaha-search-analytics-wb"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = var.location
  display_name        = "Yamaha API - Search Analytics"
  
  data_json = jsonencode({
    version = "Notebook/1.0"
    items = [
      {
        type = 1
        content = {
          json = "## 🔍 Yamaha Search API - Search Analytics\\n\\nDetailed analytics on search patterns, performance, and user behavior."
        }
      },
      {
        type = 3
        content = {
          version = "KqlItem/1.0"
          query = "customEvents\\n| where name == \\"SearchRequest\\"\\n| where timestamp > ago(24h)\\n| summarize SearchCount = count() by bin(timestamp, 1h)\\n| render timechart"
          size = 0
          title = "📈 Search Volume Over Time (24h)"
          queryType = 0
          resourceType = "microsoft.insights/components"
          visualization = "timechart"
        }
      },
      {
        type = 3
        content = {
          version = "KqlItem/1.0"
          query = "customEvents\\n| where name == \\"SearchRequest\\"\\n| where timestamp > ago(24h)\\n| extend categories = tostring(customDimensions.categories)\\n| summarize SearchCount = count() by categories\\n| order by SearchCount desc\\n| render barchart"
          size = 0
          title = "📚 Searches by Category (24h)"
          queryType = 0
          resourceType = "microsoft.insights/components"
          visualization = "barchart"
        }
      },
      {
        type = 3
        content = {
          version = "KqlItem/1.0"
          query = "customEvents\\n| where name == \\"SearchCompleted\\"\\n| where timestamp > ago(24h)\\n| extend duration_ms = todouble(customMeasurements.duration_ms)\\n| summarize \\n    AvgDuration = avg(duration_ms),\\n    P50 = percentile(duration_ms, 50),\\n    P95 = percentile(duration_ms, 95),\\n    P99 = percentile(duration_ms, 99),\\n    MaxDuration = max(duration_ms)\\n| project \\n    AvgDuration = round(AvgDuration, 2),\\n    P50 = round(P50, 2),\\n    P95 = round(P95, 2),\\n    P99 = round(P99, 2),\\n    MaxDuration = round(MaxDuration, 2)"
          size = 3
          title = "⏱️ Search Performance Metrics (Last 24h)"
          queryType = 0
          resourceType = "microsoft.insights/components"
          visualization = "table"
        }
      },
      {
        type = 3
        content = {
          version = "KqlItem/1.0"
          query = "customEvents\\n| where name == \\"SearchCompleted\\"\\n| where timestamp > ago(24h)\\n| extend result_count = toint(customDimensions.result_count)\\n| summarize AvgResults = avg(result_count) by bin(timestamp, 1h)\\n| render timechart"
          size = 0
          title = "📊 Average Search Results Over Time"
          queryType = 0
          resourceType = "microsoft.insights/components"
          visualization = "timechart"
        }
      },
      {
        type = 3
        content = {
          version = "KqlItem/1.0"
          query = "customEvents\\n| where name == \\"SearchRequest\\"\\n| where timestamp > ago(24h)\\n| extend model = tostring(customDimensions.model_filter)\\n| where model != \\"none\\"\\n| summarize Count = count() by model\\n| order by Count desc\\n| take 10\\n| render barchart"
          size = 0
          title = "🏷️ Top 10 Models Searched (24h)"
          queryType = 0
          resourceType = "microsoft.insights/components"
          visualization = "barchart"
        }
      }
    ]
    styleSettings = {}
    $schema = "https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json"
  })

  tags = merge(var.tags, {
    WorkbookType = "SearchAnalytics"
  })
}

# ============================================================================
# Workbook 3: Dependencies & Integration Dashboard
# ============================================================================

resource "azurerm_application_insights_workbook" "dependencies" {
  name                = "yamaha-dependencies-wb"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = var.location
  display_name        = "Yamaha API - Dependencies & Integration"
  
  data_json = jsonencode({
    version = "Notebook/1.0"
    items = [
      {
        type = 1
        content = {
          json = "## 🔗 Yamaha Search API - Dependencies & Integration\\n\\nMonitoring of external service calls (Azure AI Search, OpenAI, Cosmos DB)."
        }
      },
      {
        type = 3
        content = {
          version = "KqlItem/1.0"
          query = "dependencies\\n| where timestamp > ago(1h)\\n| summarize \\n    TotalCalls = count(),\\n    SuccessRate = countif(success == true) * 100.0 / count(),\\n    AvgDuration = avg(duration),\\n    P95Duration = percentile(duration, 95)\\nby target, type\\n| order by TotalCalls desc"
          size = 0
          title = "📊 Dependency Overview (Last Hour)"
          queryType = 0
          resourceType = "microsoft.insights/components"
          visualization = "table"
        }
      },
      {
        type = 3
        content = {
          version = "KqlItem/1.0"
          query = "dependencies\\n| where timestamp > ago(24h)\\n| summarize AvgDuration = avg(duration) by bin(timestamp, 30m), target\\n| render timechart"
          size = 0
          title = "⏱️ Dependency Response Time Trends (24h)"
          queryType = 0
          resourceType = "microsoft.insights/components"
          visualization = "timechart"
        }
      },
      {
        type = 3
        content = {
          version = "KqlItem/1.0"
          query = "dependencies\\n| where timestamp > ago(24h)\\n| where success == false\\n| summarize FailureCount = count() by target, resultCode\\n| order by FailureCount desc"
          size = 0
          title = "❌ Dependency Failures (24h)"
          queryType = 0
          resourceType = "microsoft.insights/components"
          visualization = "table"
        }
      },
      {
        type = 3
        content = {
          version = "KqlItem/1.0"
          query = "dependencies\\n| where timestamp > ago(24h)\\n| summarize CallCount = count() by bin(timestamp, 1h), target\\n| render areachart"
          size = 0
          title = "📞 Dependency Call Volume (24h)"
          queryType = 0
          resourceType = "microsoft.insights/components"
          visualization = "areachart"
        }
      }
    ]
    styleSettings = {}
    $schema = "https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json"
  })

  tags = merge(var.tags, {
    WorkbookType = "Dependencies"
  })
}

# ============================================================================
# Workbook 4: Error Analysis Dashboard
# ============================================================================

resource "azurerm_application_insights_workbook" "error_analysis" {
  name                = "yamaha-error-analysis-wb"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = var.location
  display_name        = "Yamaha API - Error Analysis"
  
  data_json = jsonencode({
    version = "Notebook/1.0"
    items = [
      {
        type = 1
        content = {
          json = "## ⚠️ Yamaha Search API - Error Analysis\\n\\nDetailed error tracking, failure patterns, and troubleshooting insights."
        }
      },
      {
        type = 3
        content = {
          version = "KqlItem/1.0"
          query = "exceptions\\n| where timestamp > ago(24h)\\n| summarize ErrorCount = count() by bin(timestamp, 1h)\\n| render timechart"
          size = 0
          title = "📈 Error Trends (24h)"
          queryType = 0
          resourceType = "microsoft.insights/components"
          visualization = "timechart"
        }
      },
      {
        type = 3
        content = {
          version = "KqlItem/1.0"
          query = "exceptions\\n| where timestamp > ago(24h)\\n| summarize Count = count() by type, outerMessage\\n| order by Count desc\\n| take 10"
          size = 0
          title = "🔝 Top 10 Errors (24h)"
          queryType = 0
          resourceType = "microsoft.insights/components"
          visualization = "table"
        }
      },
      {
        type = 3
        content = {
          version = "KqlItem/1.0"
          query = "requests\\n| where timestamp > ago(24h)\\n| where success == false\\n| summarize FailureCount = count() by name, resultCode\\n| order by FailureCount desc"
          size = 0
          title = "❌ Failed Requests by Endpoint (24h)"
          queryType = 0
          resourceType = "microsoft.insights/components"
          visualization = "table"
        }
      },
      {
        type = 3
        content = {
          version = "KqlItem/1.0"
          query = "customEvents\\n| where name == \\"SearchError\\"\\n| where timestamp > ago(24h)\\n| extend error_type = tostring(customDimensions.error_type)\\n| summarize ErrorCount = count() by error_type\\n| render piechart"
          size = 1
          title = "🎯 Search Error Distribution (24h)"
          queryType = 0
          resourceType = "microsoft.insights/components"
          visualization = "piechart"
        }
      },
      {
        type = 3
        content = {
          version = "KqlItem/1.0"
          query = "exceptions\\n| where timestamp > ago(24h)\\n| order by timestamp desc\\n| take 20\\n| project timestamp, type, outerMessage, method, problemId"
          size = 0
          title = "📋 Recent Exceptions (Last 20)"
          queryType = 0
          resourceType = "microsoft.insights/components"
          visualization = "table"
        }
      }
    ]
    styleSettings = {}
    $schema = "https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json"
  })

  tags = merge(var.tags, {
    WorkbookType = "ErrorAnalysis"
  })
}
