# -------------------------------------------------------------------------- #
#         Intelligent Claude Environment Proxy Function                      #
# -------------------------------------------------------------------------- #
#                                                                            #
# This function inspects the command-line arguments for `--model`.           #
# If the specified model matches a custom provider (glm, qwen, deepseek),    #
# it sets the correct environment variables for that provider before         #
# executing the command. Otherwise, it runs the original claude              #
# command with the default environment.                                      #
#                                                                            #
# Providers Configuration:                                                   #
#   export ZHIPU_API_KEY=your_key       # For zhipu models: glm-4.5 .        #
#   export DASHSCOPE_API_KEY=your_key   # For alibaba: qwen3-coder-plus      #
#   export DEEPSEEK_API_KEY=your_key    # For deepseek: deepseek-chat        #
#   export MOONSHOT_API_KEY=your_key    # For moonshot: kimi-k2-0905-preview #
#                                                                            #
# -------------------------------------------------------------------------- #

unalias claude 2>/dev/null

# First unset function definition (if exists), then find the real claude binary path
unset -f claude 2>/dev/null
CLAUDE_BIN="$(command -v claude 2>/dev/null)"

# Model providers configuration for zsh
typeset -A PROVIDERS=(
  zhipu "ZHIPU_API_KEY|https://open.bigmodel.cn/api/anthropic|glm-4.5"
  alibaba "DASHSCOPE_API_KEY|https://dashscope.aliyuncs.com/api/v2/apps/claude-code-proxy|qwen3-coder-plus"
  deepseek "DEEPSEEK_API_KEY|https://api.deepseek.com/anthropic|deepseek-chat"
  moonshot "MOONSHOT_API_KEY|https://api.moonshot.cn/anthropic|kimi-k2-0905-preview"
)

claude() {
  # 1. Use the pre-found claude binary path
  if [[ -z "$CLAUDE_BIN" ]]; then
    echo "❌ Claude CLI not found!"
    echo "Please install using the following command:"
    echo "  npm install -g @anthropic-ai/claude-code"
    echo "Or visit https://claude.ai/code for installation guide"
    return 1
  fi
  local claude_bin="$CLAUDE_BIN"

  # 2. Parse command line arguments to find --model value
  local model_arg=""
  local _args=("$@")
  # Use a loop to safely find --model and its value
  # This method can handle --model in any position
  for ((i=1; i<=${#_args[@]}; i++)); do
    if [[ "${_args[$i]}" == "--model" ]]; then
      # Found --model, its value is the next argument
      model_arg="${_args[$((i+1))]}"
      break
    elif [[ "${_args[$i]}" == --model=* ]]; then
      # Also handle --model=value format
      model_arg="${_args[$i]#*=}"
      break
    fi
  done

  # 3. Dynamic provider lookup based on model_arg
  if [[ -n "$model_arg" ]]; then
    for provider_name in "${(@k)PROVIDERS}"; do
      provider_config="${PROVIDERS[$provider_name]}"
      IFS="|" read api_key_env base_url models <<< "$provider_config"

      # Check if model_arg is in this provider's model list
      if [[ ",$models," == *",$model_arg,"* ]]; then
        if [[ -z "${(P)api_key_env}" ]]; then
          echo "❌ $api_key_env environment variable not set!"
          echo "Please set it with: export $api_key_env=your_api_key"
          return 1
        fi

        echo "🚀 Intercepted model '$model_arg'. Routing to ${provider_name} provider..."
        ANTHROPIC_BASE_URL="$base_url" \
        ANTHROPIC_AUTH_TOKEN="${(P)api_key_env}" \
        ANTHROPIC_MODEL="$model_arg" \
        ANTHROPIC_SMALL_FAST_MODEL="$model_arg" \
        API_TIMEOUT_MS=600000 \
        "$claude_bin" "$@"
        return $?
      fi
    done
  fi

  # 4. If model_arg is not one of our defined special models, or no --model parameter
  #    Execute the original command directly without adding any custom environment variables
  # echo "🤖 No special provider detected. Passing command to native claude..."
  "$claude_bin" "$@"
}
