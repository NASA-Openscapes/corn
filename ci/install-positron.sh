#!/usr/bin/env bash
set -euo pipefail

# Download Positron server to temporary directory
# Note: this is the url for x64 architecture machines
curl -L "https://cdn.posit.co/positron/releases/server/x86_64/positron-server-linux-x64-2026.05.0-179.tar.gz" -o /tmp/positron-server.tar.gz

# Create directory
mkdir -p /opt/positron-server

# Unpack Positron Server into newly created directory
tar -xzf /tmp/positron-server.tar.gz -C /opt/positron-server --strip-components=1

rm /tmp/positron-server.tar.gz
