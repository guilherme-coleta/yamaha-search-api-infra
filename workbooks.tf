# ============================================================================
# Azure Monitor Workbooks for Yamaha Search API
# ============================================================================

resource "azurerm_application_insights_workbook" "api_health" {
  name                = "a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = var.location
  display_name        = "Yamaha API - Health Dashboard"
  
  data_json = jsonencode({
    version = "Notebook/1.0"
    items = [{
      type = 1
      content = {
        json = "## Health Dashboard\n\nAPI monitoring overview."
      }
    }]
  })

  tags = merge(var.tags, {
    WorkbookType = "Health"
  })
}

resource "azurerm_application_insights_workbook" "search_analytics" {
  name                = "b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = var.location
  display_name        = "Yamaha API - Search Analytics"
  
  data_json = jsonencode({
    version = "Notebook/1.0"
    items = [{
      type = 1
      content = {
        json = "## Search Analytics\n\nSearch query analysis."
      }
    }]
  })

  tags = merge(var.tags, {
    WorkbookType = "SearchAnalytics"
  })
}

resource "azurerm_application_insights_workbook" "dependencies" {
  name                = "c3d4e5f6-a7b8-4c9d-0e1f-2a3b4c5d6e7f"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = var.location
  display_name        = "Yamaha API - Dependencies"
  
  data_json = jsonencode({
    version = "Notebook/1.0"
    items = [{
      type = 1
      content = {
        json = "## Dependencies\n\nExternal dependencies monitoring."
      }
    }]
  })

  tags = merge(var.tags, {
    WorkbookType = "Dependencies"
  })
}

resource "azurerm_application_insights_workbook" "error_analysis" {
  name                = "d4e5f6a7-b8c9-4d0e-1f2a-3b4c5d6e7f8a"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = var.location
  display_name        = "Yamaha API - Error Analysis"
  
  data_json = jsonencode({
    version = "Notebook/1.0"
    items = [{
      type = 1
      content = {
        json = "## Error Analysis\n\nError tracking and analysis."
      }
    }]
  })

  tags = merge(var.tags, {
    WorkbookType = "ErrorAnalysis"
  })
}
