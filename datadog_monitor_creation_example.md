# Creating Datadog Monitors with Amazon Q and Datadog MCP Server

This document explains how to use Amazon Q with the Datadog MCP (Model Context Protocol) server to create and deploy Datadog monitors for AWS Bedrock services.

## Overview

In this example, we demonstrate how to:
1. Use Amazon Q to discover relevant Datadog metrics for AWS Bedrock
2. Create a monitor configuration for Bedrock invocation rates
3. Deploy the monitor using the Datadog API

## Step-by-Step Process

### 1. Discovering Available Metrics

Amazon Q leverages the Datadog MCP server to query available metrics related to AWS Bedrock:

```
datadog___list_metrics(search="bedrock")
```

This returns the available Bedrock-related metrics:
- aws.bedrock.dataautomation.invocation_client_errors
- aws.bedrock.dataautomation.invocation_latency
- aws.bedrock.dataautomation.invocation_server_errors
- aws.bedrock.dataautomation.invocation_throttle_errors
- aws.bedrock.dataautomation.invocations

### 2. Creating the Monitor Configuration

Based on the available metrics, Amazon Q creates a monitor configuration file (`bedrock_invocations_monitor.json`) that:
- Monitors the rate of Bedrock invocations
- Alerts when the rate exceeds 5 invocations per minute
- Includes appropriate notification settings and tags

The monitor uses this query:
```
sum(last_5m):sum:aws.bedrock.dataautomation.invocations{*}.as_rate() > 5
```

Here's the complete monitor configuration file:

```json
{
  "name": "Bedrock Invocations Above Threshold",
  "type": "query alert",
  "query": "sum(last_5m):sum:aws.bedrock.dataautomation.invocations{*}.as_rate() > 5",
  "message": "Bedrock invocations have exceeded the threshold of 5 per minute.\n\nPlease investigate the increased usage of Amazon Bedrock services.\n\n@slack-datadog-alerts",
  "tags": [
    "service:bedrock",
    "alert:invocation_rate",
    "team:ai-ml"
  ],
  "options": {
    "thresholds": {
      "critical": 5
    },
    "notify_audit": true,
    "require_full_window": false,
    "notify_no_data": false,
    "renotify_interval": 0,
    "include_tags": true,
    "evaluation_delay": 60,
    "new_host_delay": 300,
    "silenced": {}
  }
}
```

### 3. Deploying the Monitor

The monitor can be deployed either through:
- The Datadog UI (manually)
- The Datadog API (using the provided script)

#### Installation Script

We've created a bash script (`create_bedrock_monitor.sh`) to automate the deployment of the monitor:

```bash
#!/bin/bash

# Script to create a Datadog monitor for Bedrock invocations
# This script requires DD_API_KEY and DD_APP_KEY environment variables to be set

# Check if environment variables are set
if [ -z "$DD_API_KEY" ] || [ -z "$DD_APP_KEY" ]; then
  echo "Error: DD_API_KEY and DD_APP_KEY environment variables must be set"
  echo "Example usage:"
  echo "  DD_API_KEY=your_api_key DD_APP_KEY=your_app_key ./create_bedrock_monitor.sh"
  exit 1
fi

# Path to the monitor configuration file
MONITOR_CONFIG="bedrock_invocations_monitor.json"

# Check if the configuration file exists
if [ ! -f "$MONITOR_CONFIG" ]; then
  echo "Error: Monitor configuration file '$MONITOR_CONFIG' not found"
  exit 1
fi

# Create the monitor using the Datadog API
echo "Creating Datadog monitor for Bedrock invocations..."
RESPONSE=$(curl -s -X POST "https://api.datadoghq.com/api/v1/monitor" \
  -H "Content-Type: application/json" \
  -H "DD-API-KEY: ${DD_API_KEY}" \
  -H "DD-APPLICATION-KEY: ${DD_APP_KEY}" \
  -d @"$MONITOR_CONFIG")

# Check if the monitor was created successfully
if echo "$RESPONSE" | grep -q "\"id\""; then
  MONITOR_ID=$(echo "$RESPONSE" | grep -o '"id":[0-9]*' | cut -d':' -f2)
  echo "Monitor created successfully with ID: $MONITOR_ID"
  echo "You can view this monitor at: https://app.datadoghq.com/monitors/$MONITOR_ID"
else
  echo "Error creating monitor:"
  echo "$RESPONSE"
  exit 1
fi
```

#### How to Install the Monitor

To install the Bedrock invocations monitor, follow these steps:

1. **Save the configuration file**:
   - Create a file named `bedrock_invocations_monitor.json` with the JSON configuration shown above
   - Customize the threshold, notification channels, and tags as needed for your environment

2. **Save the installation script**:
   - Create a file named `create_bedrock_monitor.sh` with the bash script shown above
   - Make the script executable: `chmod +x create_bedrock_monitor.sh`

3. **Get your Datadog API and Application keys**:
   - Go to the Datadog website: https://app.datadoghq.com/organization-settings/api-keys
   - Create or copy your API key
   - Go to https://app.datadoghq.com/organization-settings/application-keys
   - Create or copy an Application key

4. **Run the installation script**:
   ```bash
   DD_API_KEY=your_api_key DD_APP_KEY=your_app_key ./create_bedrock_monitor.sh
   ```

5. **Verify the monitor**:
   - The script will output a URL to view your new monitor in the Datadog UI
   - Check that the monitor is configured correctly and is receiving data

## Benefits of Using Amazon Q with Datadog MCP

- **Efficiency**: Quickly discover relevant metrics without navigating the Datadog UI
- **Accuracy**: Generate properly formatted monitor configurations
- **Automation**: Create deployment scripts for programmatic monitor creation
- **Documentation**: Generate explanatory documentation alongside technical artifacts

## Next Steps

After deploying this monitor, you can:
1. Adjust thresholds based on your application's normal behavior
2. Create additional monitors for errors or latency
3. Set up dashboards to visualize Bedrock usage patterns

## Related Resources

- [Datadog AWS Integration Documentation](https://docs.datadoghq.com/integrations/amazon_web_services/)
- [Datadog Monitor API Documentation](https://docs.datadoghq.com/api/latest/monitors/)
- [AWS Bedrock Documentation](https://docs.aws.amazon.com/bedrock/)
