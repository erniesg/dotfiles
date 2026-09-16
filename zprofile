# Setup the PATH for pyenv binaries and shims
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(/opt/homebrew/bin/brew shellenv 2> /dev/null)"

# Figma OAuth token for Codex MCP in login shells.
if [ -f "/Users/erniesg/.config/figma/oauth.env" ]; then
  source "/Users/erniesg/.config/figma/oauth.env"
fi

# Prefer a locally patched Codex build when present.
if [ -x "$HOME/.codex/bin/codex" ]; then
  export PATH="$HOME/.codex/bin:$PATH"
fi

type -a pyenv > /dev/null && eval "$(pyenv init --path)"

# Created by `pipx` on 2025-03-11 14:44:00
export PATH="$PATH:/Users/erniesg/.local/bin"


# Added by Antigravity CLI installer
export PATH="/Users/erniesg/.local/bin:$PATH"
