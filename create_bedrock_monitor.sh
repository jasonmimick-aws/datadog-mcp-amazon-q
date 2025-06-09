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
