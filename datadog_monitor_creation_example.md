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

### 3. Deploying the Monitor

The monitor can be deployed either through:
- The Datadog UI (manually)
- The Datadog API (using the provided script)

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
