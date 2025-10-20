# Yamaha Search API - Terraform Monitoring & Workbooks

This directory contains Terraform configuration to deploy monitoring workbooks and alerts for the Yamaha Search API using an existing Application Insights instance.

## 📋 Prerequisites

### 1. Existing Azure Resources

The following resources must **already exist** in Azure:

- ✅ **Resource Group**
- ✅ **Application Insights** (already configured and receiving telemetry)

### 2. Required Tools

```bash
# Azure CLI
az --version

# Terraform
terraform --version

# Azure login
az login
```

To install Terraform on Windows:
```bash
winget install Hashicorp.Terraform
```

## 🚀 Deployment

### Step 1: Configure Variables

```bash
# Copy the example file
cp terraform.tfvars.example terraform.tfvars

# Edit with your values
nano terraform.tfvars  # or use your preferred editor
```

**Required values to update in `terraform.tfvars`:**
- `resource_group_name` - Name of your existing Resource Group
- `application_insights_name` - Name of your existing Application Insights instance

**Optional values:**
- `location` - Azure region (default: eastus2)
- `environment` - Environment name (default: prod)
- `enable_alerts` - Enable monitoring alerts (default: false)
- `alert_email` - Email for alert notifications (required if alerts enabled)

### Step 2: Initialize Terraform

```bash
cd infra/terraform
terraform init
```

### Step 3: Validate Configuration

```bash
# Validate syntax
terraform validate

# View execution plan
terraform plan
```

### Step 4: Apply Configuration

```bash
# Deploy with auto-approval
terraform apply -auto-approve

# OR deploy with manual confirmation
terraform apply
```

### Step 5: Get Outputs

```bash
# View all outputs
terraform output

# View workbook URLs
terraform output workbook_urls

# View Application Insights connection string
terraform output -raw application_insights_connection_string
```

## 📊 Resources Created

This Terraform configuration creates:

### Workbooks (Always Created)
- ✅ **API Health Dashboard** - Availability, performance, and resource utilization
- ✅ **Search Analytics** - Search patterns, performance metrics, and user behavior
- ✅ **Dependencies & Integration** - External service monitoring (Azure AI Search, OpenAI, Cosmos DB)
- ✅ **Error Analysis** - Error tracking, failure patterns, and troubleshooting

### Alerts (Optional - if `enable_alerts = true`)
- ✅ **High Error Rate** - Triggers when > 10 errors in 15 minutes
- ✅ **High Response Time** - Triggers when average response > 5 seconds
- ✅ **Low Availability** - Triggers when availability < 99%
- ✅ **Dependency Failures** - Triggers when > 5 dependency failures in 15 minutes

## 📈 Workbooks Overview

### 1. 🏥 API Health Dashboard

**Purpose:** Real-time monitoring of API health and availability.

**Key Metrics:**
- Performance summary (success rate, P50/P95/P99 latencies)
- Requests over time by status code
- Top 10 endpoints
- Status code distribution

**Use when:**
- Checking if API is healthy
- Investigating performance degradation
- Analyzing traffic patterns
- Validating SLAs

---

### 2. 🔍 Search Analytics

**Purpose:** Detailed analysis of search behavior and resource usage.

**Key Metrics:**
- Search volume trends
- Searches by category
- Search performance metrics (average, P50, P95, P99)
- Average results per search
- Top models searched
- Top-K distribution

**Use when:**
- Understanding user patterns
- Optimizing specific searches
- Identifying popular categories
- Planning capacity and costs

---

### 3. 🔗 Dependencies & Integration

**Purpose:** Monitoring external services (Azure AI Search, OpenAI, Cosmos DB).

**Key Metrics:**
- Dependency overview (success rate, latency per service)
- Response time trends
- Dependency failures
- Call volume per service

**Use when:**
- Investigating API slowness
- Identifying bottlenecks in external services
- Planning rate limits and costs
- Troubleshooting integrations

---

### 4. ⚠️ Error Analysis

**Purpose:** Detailed error tracking and troubleshooting.

**Key Metrics:**
- Error trends over time
- Top 10 errors with messages
- Failed requests by endpoint
- Search error distribution
- Recent exceptions with stack traces

**Use when:**
- Investigating reported issues
- Analyzing deploy impact
- Prioritizing bug fixes
- Root cause analysis

## 🔍 Access Workbooks

### Via Azure Portal

1. Navigate to: **Portal → Resource Group → Application Insights → Workbooks**
2. Look for workbooks with "Yamaha API" prefix

### Via Direct URLs

After deployment, get the URLs:
```bash
terraform output workbook_urls
```

### Via Terraform Output

```bash
# Health Dashboard
terraform output workbook_health_id

# Search Analytics
terraform output workbook_search_analytics_id

# Dependencies
terraform output workbook_dependencies_id

# Error Analysis
terraform output workbook_error_analysis_id
```

## 🔔 Alerts Configuration

### Enable Alerts

Edit `terraform.tfvars`:
```hcl
enable_alerts = true
alert_email   = "your-email@example.com"
```

Then apply:
```bash
terraform apply
```

### Alert Details

| Alert | Threshold | Severity | Action |
|-------|-----------|----------|--------|
| High Error Rate | > 10 errors in 15min | Warning | Email |
| High Response Time | Average > 5s | Warning | Email |
| Low Availability | < 99% | Critical | Email |
| Dependency Failures | > 5 failures in 15min | Warning | Email |

### Customize Alert Thresholds

Edit the `alerts.tf` file to modify thresholds, windows, or add new alerts.

## 📊 KQL Query Examples

### Find Slow Searches
```kql
customEvents
| where name == "SearchCompleted"
| extend duration_ms = todouble(customMeasurements.duration_ms)
| where duration_ms > 5000
| order by duration_ms desc
| take 20
```

### Success Rate by Category
```kql
customEvents
| where name == "SearchRequest"
| extend categories = tostring(customDimensions.categories)
| summarize 
    Total = count(),
    Success = countif(customDimensions.result_count != "0")
| extend SuccessRate = (Success * 100.0) / Total
```

### Top Failed Queries
```kql
customEvents
| where name == "SearchError"
| extend error_msg = tostring(customDimensions.error_message)
| summarize Count = count() by error_msg
| order by Count desc
```

## 🔧 Troubleshooting

### Workbooks Not Loading Data

1. Verify Application Insights is receiving data:
   ```bash
   # In Azure Portal → Application Insights → Logs
   requests | take 10
   ```

2. Check if instrumentation is configured in the application

3. Wait 5-10 minutes for first telemetry to appear

### Custom Events Not Showing

1. Verify application is using telemetry middleware
2. Check imports: `from app.middleware import track_custom_event`
3. Verify logs for initialization errors
4. Redeploy application if needed

### Terraform Errors

```bash
# If resources already exist
terraform import azurerm_application_insights_workbook.api_health /subscriptions/.../workbooks/...

# Or destroy and recreate
terraform destroy -target=azurerm_application_insights_workbook.api_health
terraform apply
```

### Alerts Not Firing

1. Verify email is configured:
   ```hcl
   enable_alerts = true
   alert_email   = "your-email@example.com"
   ```

2. Check alert rules in Azure Portal → Monitor → Alerts

3. Test by generating errors or load

## 🧹 Destroy Resources

```bash
# Preview changes
terraform plan -destroy

# Destroy all workbooks and alerts
terraform destroy -auto-approve
```

⚠️ **Note:** This will NOT destroy the Application Insights instance, only the workbooks and alerts created by this Terraform configuration.


## 📚 Useful Links

- [Azure Monitor Workbooks Documentation](https://docs.microsoft.com/azure/azure-monitor/visualize/workbooks-overview)
- [KQL Query Language](https://docs.microsoft.com/azure/data-explorer/kusto/query/)
- [Application Insights](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

## 🎯 Best Practices

### Daily Monitoring
- ✅ Check **Health Dashboard** every morning
- ✅ Review **Error Analysis** for new issues
- ✅ Monitor **Dependencies** for degradation

### After Deployment
- ✅ Monitor **Error Trends** for 1 hour
- ✅ Compare **Performance Summary** before/after
- ✅ Verify **Dependency Failures** haven't increased

### Capacity Planning
- 📊 **Search Volume** to predict growth
- 📊 **Dependency Call Volume** for API costs
- 📊 **Top Categories** for index optimization

## 💡 Next Steps

1. Customize workbooks for specific business needs
2. Add custom charts and queries
3. Create additional alerts for specific thresholds
4. Integrate with Azure Dashboards
5. Set up automated reports
6. Configure Power BI integration
