# Claude Code Proxy Configuration

This repository contains a shell script that provides intelligent proxy functionality for Claude Code CLI, allowing it to work with multiple AI model providers through a unified interface.

## Overview

The `.claude.sh` script intercepts Claude Code CLI commands and automatically routes them to the appropriate model provider based on the `--model` parameter. It supports multiple Chinese AI providers while maintaining compatibility with the standard Claude Code interface.

## Supported Model Providers

The script supports the following model providers and their corresponding models:

| Provider | Environment Variable | Base URL | Supported Models |
|----------|---------------------|----------|------------------|
| Zhipu (智谱) | `ZHIPU_API_KEY` | `https://open.bigmodel.cn/api/anthropic` | `glm-4.5` |
| Alibaba (阿里) | `DASHSCOPE_API_KEY` | `https://dashscope.aliyuncs.com/api/v2/apps/claude-code-proxy` | `qwen3-coder-plus` |
| DeepSeek | `DEEPSEEK_API_KEY` | `https://api.deepseek.com/anthropic` | `deepseek-chat` |
| Moonshot (月之暗面) | `MOONSHOT_API_KEY` | `https://api.moonshot.cn/anthropic` | `kimi-k2-0905-preview` |
| LongCat | `LONGCAT_API_KEY` | `https://api.longcat.chat/anthropic` | `LongCat-Flash-Chat` |

## Installation

1. Install Claude Code CLI:
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```

2. Source the proxy script in your shell configuration:
   ```bash
   # Add to ~/.zshrc or ~/.bashrc
   source /path/to/.claude.sh
   ```

3. Set up your API keys for the desired providers:
   ```bash
   export ZHIPU_API_KEY=your_zhipu_key
   export DASHSCOPE_API_KEY=your_alibaba_key
   export DEEPSEEK_API_KEY=your_deepseek_key
   export MOONSHOT_API_KEY=your_moonshot_key
   export LONGCAT_API_KEY=your_longcat_key
   ```

## Usage

Use Claude Code as normal, but specify the desired model with the `--model` parameter:

```bash
# Use Zhipu's GLM-4.5 model
claude --model glm-4.5

# Use Alibaba's Qwen3 Coder Plus
claude --model qwen3-coder-plus

# Use DeepSeek Chat
claude --model deepseek-chat

# Use Moonshot's Kimi K2
claude --model kimi-k2-0905-preview

# Use LongCat's model
claude --model LongCat-Flash-Chat

# Use default Claude model (no proxy)
claude
```

## Features

- **Automatic Provider Detection**: The script automatically detects which provider to use based on the model name
- **Environment Variable Validation**: Checks that required API keys are set before routing requests
- **Transparent Proxy**: Maintains full compatibility with Claude Code CLI syntax and options
- **Error Handling**: Provides clear error messages when API keys are missing or invalid
- **Flexible Model Parameter**: Supports both `--model model_name` and `--model=model_name` formats

## Configuration

The script uses a associative array (`PROVIDERS`) to configure provider mappings. Each entry contains:
- Environment variable name for the API key
- Base URL for the provider's Anthropic-compatible API
- Comma-separated list of supported models

## Error Messages

The script provides helpful error messages:
- **CLI Not Found**: Instructions for installing Claude Code if not detected
- **Missing API Key**: Specific environment variable name needed for each provider
- **Provider Routing**: Confirmation when successfully routing to a specific provider

## Timeout Configuration

All proxied requests use a 10-minute timeout (`API_TIMEOUT_MS=600000`) to accommodate longer processing times for complex tasks.