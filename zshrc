ZSH=$HOME/.oh-my-zsh

# You can change the theme with another one from https://github.com/robbyrussell/oh-my-zsh/wiki/themes
ZSH_THEME="robbyrussell"

# Useful oh-my-zsh plugins for Le Wagon bootcamps
plugins=(git gitfast last-working-dir common-aliases zsh-syntax-highlighting history-substring-search)

# (macOS-only) Prevent Homebrew from reporting - https://github.com/Homebrew/brew/blob/master/docs/Analytics.md
export HOMEBREW_NO_ANALYTICS=1

# Disable warning about insecure completion-dependent directories
ZSH_DISABLE_COMPFIX=true

# Actually load Oh-My-Zsh
source "${ZSH}/oh-my-zsh.sh"
unalias rm # No interactive rm by default (brought by plugins/common-aliases)
unalias cp mv 2>/dev/null # cp -i / mv -i hang coding agents on overwrite prompts nobody can answer
unalias lt # we need `lt` for https://github.com/localtunnel/localtunnel

# Load rbenv if installed (to manage your Ruby versions)
export PATH="${HOME}/.rbenv/bin:${PATH}" # Needed for Linux/WSL
type -a rbenv > /dev/null && eval "$(rbenv init -)"

# Load pyenv (to manage your Python versions)
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
type -a pyenv > /dev/null && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init - 2> /dev/null)" && RPROMPT+='[🐍 $(pyenv version-name)]'

# Load nvm (to manage your node versions)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Call `nvm use` automatically in a directory with a `.nvmrc` file
autoload -U add-zsh-hook
load-nvmrc() {
  if nvm -v &> /dev/null; then
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use --silent
      fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
      nvm use default --silent
    fi
  fi
}
type -a nvm > /dev/null && add-zsh-hook chpwd load-nvmrc
type -a nvm > /dev/null && load-nvmrc

# Keep the prompt readable when Terminal flips between light and dark profiles.
typeset -g ERNIESG_APPEARANCE_MTIME=""
typeset -g ERNIESG_DARK_MODE=""

erniesg_update_prompt_for_appearance() {
  local appearance_plist="$HOME/Library/Preferences/.GlobalPreferences.plist"
  local appearance_mtime="0"

  if [[ -r "$appearance_plist" ]]; then
    appearance_mtime="$(stat -f %m "$appearance_plist" 2>/dev/null || printf '0')"
  fi

  if [[ "$appearance_mtime" != "$ERNIESG_APPEARANCE_MTIME" ]]; then
    if defaults read -g AppleInterfaceStyle >/dev/null 2>&1; then
      ERNIESG_DARK_MODE=1
    else
      ERNIESG_DARK_MODE=0
    fi
    ERNIESG_APPEARANCE_MTIME="$appearance_mtime"
  fi

  if [[ "$ERNIESG_DARK_MODE" == "1" ]]; then
    PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%c%{$reset_color%}\$(git_prompt_info) "
    ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[blue]%}git:(%{$fg[red]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
    ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
  else
    PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg_bold[blue]%}%c%{$reset_color%}\$(git_prompt_info) "
    ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[magenta]%}git:(%{$fg_bold[red]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[magenta]%}) %{$fg_bold[red]%}%1{✗%}"
    ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[magenta]%})"
  fi
}

add-zsh-hook precmd erniesg_update_prompt_for_appearance
erniesg_update_prompt_for_appearance

# Rails and Ruby uses the local `bin` folder to store binstubs.
# So instead of running `bin/rails` like the doc says, just run `rails`
# Same for `./node_modules/.bin` and nodejs
export PATH="./bin:./node_modules/.bin:${PATH}:/usr/local/sbin"

# Store your own aliases in the ~/.aliases file and load the here.
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Encoding stuff for the terminal
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export BUNDLER_EDITOR=code
export EDITOR=code

# Set ipdb as the default Python debugger
export PYTHONBREAKPOINT=ipdb.set_trace

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc' ]; then . '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc' ]; then . '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc'; fi


export PATH=/Users/erniesg/bin:$PATH

[[ -e "/Users/erniesg/lib/oracle-cli/lib/python3.10/site-packages/oci_cli/bin/oci_autocomplete.sh" ]] && source "/Users/erniesg/lib/oracle-cli/lib/python3.10/site-packages/oci_cli/bin/oci_autocomplete.sh"

# Created by `pipx` on 2025-03-11 14:44:00
export PATH="$PATH:/Users/erniesg/.local/bin"

autoload -U compinit && compinit
autoload -U bashcompinit
bashcompinit
eval "$(register-python-argcomplete pipx)"

# bun completions
[ -s "/Users/erniesg/.bun/_bun" ] && source "/Users/erniesg/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Added by Antigravity
export PATH="/Users/erniesg/.antigravity/antigravity/bin:$PATH"
# Figma OAuth token for Codex MCP
if [ -f "/Users/erniesg/.config/figma/oauth.env" ]; then
  source "/Users/erniesg/.config/figma/oauth.env"
fi

# Prefer a locally patched Codex build when present.
if [ -x "$HOME/.codex/bin/codex" ]; then
  case ":$PATH:" in
    *":$HOME/.codex/bin:"*) ;;
    *) export PATH="$HOME/.codex/bin:$PATH" ;;
  esac
fi

# Keep modern CLIs in color mode without leaking forced color into TUIs.
unset FORCE_COLOR
unset NO_COLOR
export CLICOLOR=1

# Apple Terminal cannot render 24-bit color; advertising truecolor there makes
# TUIs (Claude Code, codex) emit RGB escapes it mis-parses as random backgrounds.
# Terminals that really support truecolor (iTerm2, Ghostty, kitty) set COLORTERM
# themselves, so never force it.
if [ "$TERM_PROGRAM" = "Apple_Terminal" ]; then
  unset COLORTERM
fi

codex() {
  env -u NO_COLOR CLICOLOR=1 FORCE_COLOR=1 command codex "$@"
}

claude() {
  env -u FORCE_COLOR TERM="${TERM:-xterm-256color}" CLICOLOR=1 command claude "$@"
}

# Added by Antigravity IDE
export PATH="/Users/erniesg/.antigravity-ide/antigravity-ide/bin:$PATH"


# Added by Antigravity CLI installer
export PATH="/Users/erniesg/.local/bin:$PATH"
