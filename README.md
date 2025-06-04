Here are the next steps to set up the temporary workaround that uses a local binary to connect to our remote MCP server preview:

Install the stdio proxy (macOS and Linux only):

```
curl -sSL https://coterm.datadoghq.com/mcp-cli/install.sh | bash
```

That will install it to `~/.local/bin/datadog_mcp_cli` and then you can use it like any stdio MCP server.

The first time it's launched, it will open a web browser to walk you through OAuth login to Datadog.

For the use cases we discussed, the following tools might be most relevant: get_logs, get_metrics, get_monitors, get_trace, list_incidents.

Now I have the correct syntax for adding an MCP server to Amazon Q. Based on the information I've gathered, here's how to add the Datadog MCP
server to Amazon Q chat:

1. First, install the Datadog MCP CLI (stdio proxy) if you haven't already:

   curl -sSL https://coterm.datadoghq.com/mcp-cli/install.sh | bash


2. Add the Datadog MCP server to Amazon Q using the following command:

   q mcp add --name datadog --command ~/.local/bin/datadog_mcp_cli


This will:
• Register the Datadog MCP server with the name "datadog"
• Use the installed binary at ~/.local/bin/datadog_mcp_cli

The first time you use a tool from this MCP server in Amazon Q chat, it will open a web browser to walk you through OAuth login to Datadog.

After adding the server, you can use Datadog tools in your Q chat sessions by referencing them with the server name prefix, like
datadog___get_logs, datadog___get_metrics, etc.

You can verify your MCP server configuration by running:
q mcp list

# datadog-mcp-amazon-q
