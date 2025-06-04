# Amazon Q with Datadog Integration Demo Script

*A guide for AWS specialists demonstrating to customers*

## Introduction

Today I'll demonstrate how Amazon Q can be enhanced with Model Context Protocol (MCP) servers, focusing specifically on integrating with Datadog for observability insights directly in your chat interface. This powerful combination allows you to query your monitoring data without leaving your development workflow.

## Part 1: Basic Amazon Q Chat Usage

Let's start with the basics of Amazon Q chat. Amazon Q is AWS's AI assistant that helps with development tasks, AWS services, and more.

First, let's start Amazon Q chat using the CLI:
```bash
q chat
```

Let me show you some basic Q capabilities:
- Ask about AWS services: "How do I set up an S3 bucket with versioning?"
- Get code examples: "Write a Python function to list EC2 instances"
- Troubleshoot errors: "What does this error mean: AccessDenied when accessing S3"

## Part 2: Introduction to MCP Servers

Now, let's talk about Model Context Protocol servers. MCP is an open protocol that allows Amazon Q to access additional context and tools through external servers.

Amazon Q can be extended with MCP servers that provide specialized capabilities.
MCP servers can provide:
- Access to internal documentation
- Integration with monitoring tools
- Custom tooling specific to your organization
- Connections to your data sources

## Part 3: Managing MCP Servers

Let's see how to manage MCP servers with Amazon Q.

To list your current MCP servers:
```bash
q mcp list
```

To add an MCP server, you use the 'q mcp add' command:
```bash
q mcp add --name example-server --command /path/to/server-binary
```

To remove an MCP server:
```bash
q mcp remove example-server
```

## Part 4: Adding the Datadog MCP Server

Now, let's focus on adding the Datadog MCP server, which will allow us to query Datadog metrics, logs, and traces directly from Amazon Q.

First, we need to install the Datadog MCP CLI:
```bash
curl -sSL https://coterm.datadoghq.com/mcp-cli/install.sh | bash
```
This installs the CLI to `~/.local/bin/datadog_mcp_cli`

Now, let's add the Datadog MCP server to Amazon Q:
```bash
q mcp add --name datadog --command ~/.local/bin/datadog_mcp_cli
```

Let's verify the server was added successfully:
```bash
q mcp list
```
You should see 'datadog' in the list of servers

The first time you use a Datadog tool, it will open a browser window for OAuth authentication with your Datadog account.

## Part 5: Using Datadog Tools in Amazon Q

Now that we've added the Datadog MCP server, let's see how we can use it to query Datadog data directly from Amazon Q chat.

Let's start Amazon Q chat and try some Datadog queries:
```bash
q chat
```

Here are some example queries you can try:

### Example 1: Query metrics
"Show me the CPU utilization for my EC2 instances over the last 24 hours"

Amazon Q will use datadog___get_metrics to retrieve and visualize this data

### Example 2: Check logs
"Show me error logs from my production environment in the last hour"

Amazon Q will use datadog___get_logs to fetch relevant logs

### Example 3: Investigate traces
"Show me the slowest API calls in my application from today"

Amazon Q will use datadog___list_spans to find slow traces

### Example 4: Monitor status
"Are there any active incidents in my environment?"

Amazon Q will use datadog___list_incidents to check for issues

### Example 5: Complex analysis
"Compare the latency of my payment service before and after the deployment this morning"

Amazon Q will combine multiple Datadog tools to provide this analysis

## Part 6: Advanced Use Cases

Let's explore some more advanced use cases that combine Amazon Q's capabilities with Datadog data.

Advanced use cases:

### 1. Troubleshooting
"I'm seeing high latency in my payment service. Help me diagnose the issue."

Amazon Q will analyze metrics, logs, and traces to identify potential causes

### 2. Performance optimization
"Analyze my Lambda function performance and suggest improvements"

Amazon Q will examine execution metrics and provide optimization recommendations

### 3. Alert investigation
"Explain why my database CPU alert triggered at 2 AM"

Amazon Q will correlate metrics and events around the alert time

### 4. Deployment validation
"Did our deployment at 10 AM impact our service performance?"

Amazon Q will compare before/after metrics to assess impact

## Conclusion

As you've seen, integrating Amazon Q with Datadog through MCP provides a powerful way to access and analyze your observability data directly in your chat workflow. This integration helps you:

Benefits of Amazon Q with Datadog integration:
- Faster troubleshooting by accessing monitoring data without context switching
- More informed decision-making with data-driven insights
- Simplified workflows by combining development and operations tasks
- Enhanced productivity through natural language queries for complex monitoring data

To get started:
1. Install the AWS CLI and Amazon Q CLI
2. Install the Datadog MCP CLI
3. Add the Datadog MCP server to Amazon Q
4. Start using natural language to query your Datadog data

Thank you for joining this demonstration. Any questions?
