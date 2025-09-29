# MCP Integration

This document provides the commands to add various MCP sources to Claude, Gemini, and Codex assistants.

## Claude Code

To add MCP sources to Claude, use the following commands:

```bash
claude mcp add --transport sse cf-docs https://docs.mcp.cloudflare.com/sse -s user
claude mcp add --transport sse context7 https://mcp.context7.com/sse -s user
claude mcp add chrome-devtools npx chrome-devtools-mcp@latest -s user
```

## Gemini

To add MCP sources to Gemini, use the following commands:

```bash
gemini mcp add --transport sse cf-docs https://docs.mcp.cloudflare.com/sse -s user
gemini mcp add --transport sse context7 https://mcp.context7.com/sse -s user
gemini mcp add chrome-devtools npx chrome-devtools-mcp@latest -s user
```

## Codex

To add MCP sources to Codex, use the following commands:

```bash
codex mcp add cf-docs npx mcp-remote https://docs.mcp.cloudflare.com/sse
codex mcp add cloudflare-observability npx mcp-remote https://observability.mcp.cloudflare.com/sse
codex mcp add cloudflare-bindings npx mcp-remote https://bindings.mcp.cloudflare.com/sse
codex mcp add context7 npx @upstash/context7-mcp
codex mcp add chrome-devtools npx chrome-devtools-mcp@latest
```
