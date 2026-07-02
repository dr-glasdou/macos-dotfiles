#!/usr/bin/env zsh

# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"



zmodload zsh/zpty

# =============================================================================
# .zshrc Configuration
# =============================================================================

# Oh My Zsh Configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="spaceship"

# Plugin Configuration
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    you-should-use
    docker
    docker-compose
    npm
    yarn
    bun
    fnm
    flutter
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh
# Initialize Spaceship prompt globals to avoid unset-parameter warnings
typeset -gA SPACESHIP_CACHE
export SPACESHIP_TIME_ASYNC=false
export SPACESHIP_RPROMPT_ADD_NEWLINE=false

# =============================================================================
# Environment Variables
# =============================================================================

# Portless (HTTP instead of HTTPS)
export PORTLESS_HTTPS=0

# Node.js (fnm)
eval "$(fnm env --use-on-cd --shell zsh)"

# Flutter & Dart
export PATH="$HOME/flutter/bin:$PATH"
export PATH="$HOME/.pub-cache/bin:$PATH"
export FLUTTER_ROOT="$HOME/flutter"
# Chrome for Flutter web
export CHROME_EXECUTABLE="/Applications/Arc.app/Contents/MacOS/Arc"

# Java
export JAVA_HOME="/opt/homebrew/Cellar/openjdk@17/17.0.17/libexec/openjdk.jdk/Contents/Home"

# Docker
export COMPOSE_BAKE=true

# History configuration
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$HOME/.zsh_history"
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# =============================================================================
# Basic Aliases
# =============================================================================

# System
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias la='ls -la --color=auto'
alias grep='grep --color=auto'
alias cl='clear'
alias mkdir='mkdir -p'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Configuration
alias ec="zed $HOME/.dotfiles/.zshrc"
alias sc="source $HOME/.zshrc"
alias reload="exec zsh"
alias aec="zed $HOME/.dotfiles/aerospace.toml"

# Applications
alias lzd="lazydocker"

# =============================================================================
# Git Aliases
# =============================================================================

# Basic Git Aliases
# Basic Git Aliases
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpp='git pull'
alias gpo='git push origin'
alias gpoht='git push origin HEAD -u --tags'
alias gpom='git push origin main'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gbd='git branch -d'
alias gm='git merge'
alias gl='git log --oneline'
alias gd='git diff'
alias gds='git diff --staged'


# Advanced Git Aliases
alias gbalocal="git branch -l | grep -v -E '(prod|main|dev|develop|staging|HEAD)' | sed 's/ origin\///'"
alias gclearlocal="git branch -l | grep -v -E '(prod|main|dev|develop|staging|HEAD)' | sed 's/ origin\///' | xargs -n 1 git branch -D"
alias gbaorigin="git branch -r | grep -v -E '(origin/prod|origin/main|origin/dev|origin/develop|origin/staging|origin/HEAD)' | sed 's/origin\///'"
alias gclearorigin="git branch -r | grep -v -E '(origin/prod|origin/main|origin/dev|origin/develop|origin/staging|origin/HEAD)' | sed 's/origin\///' | xargs -n 1 git push origin --delete"

# =============================================================================
# Docker Aliases
# =============================================================================

alias d='docker'
alias dc='docker compose'
alias dup='docker compose up'
alias ddown='docker compose down'
alias dps='docker container ls'
alias dpsa='docker container ls -a'
alias di='docker images'
alias dprune='docker system prune -af'

# =============================================================================
# Package Manager Aliases
# =============================================================================

alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'

alias yi='yarn install'
alias ya='yarn add'
alias yad='yarn add --dev'
alias yr='yarn run'
alias ys='yarn start'
alias yt='yarn test'
alias yb='yarn build'

alias pi='pnpm install'
alias pa='pnpm add'
alias pad='pnpm add -D'
alias pr='pnpm run'
alias ps='pnpm start'
alias pt='pnpm test'
alias pb='pnpm build'

# Update all package managers
alias @update='npm i -g npm yarn pnpm bun && brew update && brew upgrade'
alias brewup="brew update && brew upgrade && brew cleanup"

# =============================================================================
# Utility Functions
# =============================================================================

# Checkout to branch and pull the changes
gcop() {
    git checkout "$1" && git pull
}

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Find process by name
findproc() {
    ps aux | grep -i "$1" | grep -v grep
}

# Kill process by name
killproc() {
    pkill -f "$1"
}

# List processes on a specific port (or all ports if no argument)
ports() {
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo "Usage: ports [port]"
        echo "  List processes on a specific port, or all ports if no argument."
        return 0
    fi

    if [ -z "$1" ]; then
        lsof -i -P | grep LISTEN
    else
        lsof -i :"$1" | grep LISTEN
    fi
}

# Kill process on a specific port
killport() {
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo "Usage: killport <port>"
        echo "  Kill the process running on the specified port."
        return 0
    fi

    if [ -z "$1" ]; then
        echo "Usage: killport <port>"
        return 1
    fi

    local pid
    pid=$(lsof -t -i :"$1")

    if [ -z "$pid" ]; then
        echo "No process found on port $1"
        return 1
    fi

    echo "Killing process $pid on port $1..."
    kill -9 "$pid" && echo "Done!" || echo "Failed to kill process"
}

zed_settings() {
  local dir=".zed"
  local file="$dir/settings.json"
  local base_url="https://raw.githubusercontent.com/Dounder/macos-dotfiles/main/.zed"
  local requested="$1"
  local remote_name
  local remote_url
  local tmpfile

  mkdir -p "$dir"

  # Determine which remote file to request
  if [[ -z "$requested" ]]; then
    remote_name="settings.json"
  else
    remote_name="${requested}_settings.json"
  fi

  remote_url="$base_url/$remote_name"

  # Download to a temporary file first so we don't overwrite on failure
  tmpfile=$(mktemp) || { echo "❌ Could not create temp file"; return 1; }

  if ! curl -fsSL "$remote_url" -o "$tmpfile"; then
    # If requested a non-default and it failed, try default as a fallback
    if [[ "$remote_name" != "settings.json" ]]; then
      echo "⚠️  Requested config '$remote_name' not found. Falling back to default settings.json..."
      if ! curl -fsSL "$base_url/settings.json" -o "$tmpfile"; then
        echo "❌ Failed to download default settings.json as fallback"
        rm -f "$tmpfile"
        return 1
      else
        echo "ℹ️  Using default settings.json"
      fi
    else
      echo "❌ Failed to download default settings.json"
      rm -f "$tmpfile"
      return 1
    fi
  fi

  # Ask before overwriting existing local file
  if [ -f "$file" ]; then
    echo "⚠️  $file already exists. Overwrite? (y/N): "
    read -r answer
    if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
      echo "Aborted." && rm -f "$tmpfile" && return 1
    fi
  fi

  mv "$tmpfile" "$file" && echo "✅ Created $file (from $remote_name)" || { echo "❌ Failed to write $file"; rm -f "$tmpfile"; return 1; }
}

# vsc_flutter_settings() {
#   local dir=".vscode"
#   local file="$dir/settings.json"
#   local url="https://raw.githubusercontent.com/Dounder/macos-dotfiles/main/.vscode/flutter_settings.json"

#   mkdir -p "$dir"

#   if [ -f "$file" ]; then
#     echo "⚠️  $file already exists. Overwrite? (y/N): "
#     read -r answer
#     [[ "$answer" != "y" && "$answer" != "Y" ]] && echo "Aborted." && return 1
#   fi

#   curl -fsSL "$url" -o "$file" && echo "✅ Created $file" || echo "❌ Failed to download settings"
# }

# =============================================================================
# SSH & Git Management Functions
# =============================================================================

# Start SSH agent on shell startup
init_ssh_agent()

# Initialize SSH agent environment (run on shell startup)
init_ssh_agent() {
    local agent_env="$HOME/.ssh/agent-environment"

    # Try to load existing agent environment
    if [[ -f "$agent_env" ]]; then
        source "$agent_env" >/dev/null
    fi

    # Check if the loaded agent is still running
    if ! ssh-add -l >/dev/null 2>&1; then
        # Start new agent and save environment
        echo "🔄 Initializing SSH agent..."
        ssh-agent -s > "$agent_env"
        source "$agent_env" >/dev/null
        echo "✅ SSH agent initialized"
    fi
}

# Function to ensure SSH agent is running and add a specific key
start_ssh_agent() {
    local key_path="$1"

    if [[ -z "$key_path" ]]; then
        echo "Usage: start_ssh_agent <path_to_ssh_key>"
        return 1
    fi

    # Check if key file exists
    if [[ ! -f "$key_path" ]]; then
        echo "SSH key not found at $key_path"
        return 1
    fi

    # Check if ssh-agent is accessible and running
    if ! ssh-add -l >/dev/null 2>&1; then
        # No agent running or not accessible, start a new one
        echo "🔄 Starting SSH agent..."
        eval "$(ssh-agent -s)"

        # Export the agent info for the current session
        export SSH_AGENT_PID
        export SSH_AUTH_SOCK
    else
        echo "🔑 Using existing SSH agent"
    fi

    # Get the key fingerprint for comparison
    local key_fingerprint
    key_fingerprint=$(ssh-keygen -lf "$key_path" 2>/dev/null | awk '{print $2}')

    if [[ -z "$key_fingerprint" ]]; then
        echo "❌ Could not read key fingerprint from $key_path"
        return 1
    fi

    # Check if key is already added
    if ssh-add -l 2>/dev/null | grep -q "$key_fingerprint"; then
        echo "✅ Key already loaded: $(basename "$key_path")"
    else
        # Add the key
        if ssh-add "$key_path" 2>/dev/null; then
            echo "✅ Added key: $(basename "$key_path")"
        else
            echo "❌ Failed to add key: $key_path"
            return 1
        fi
    fi
}

# Function to configure git for work
workgit() {
    start_ssh_agent "$HOME/.ssh/work"

    if git rev-parse --is-inside-work-tree &>/dev/null; then
        git config user.name "dr.glasdou"
        git config user.email "daramirez@disagro.com"

        echo "✅ Git configured for WORK environment"
        echo "📧 Name: $(git config user.name)"
        echo "📧 Email: $(git config user.email)"
    else
        echo "⚠️  Not in a git repository. SSH key added but git config not changed."
    fi
}

# Function to configure git for personal use
personalgit() {
    start_ssh_agent "$HOME/.ssh/personal"

    if git rev-parse --is-inside-work-tree &>/dev/null; then
        git config user.name "dr.glasdou"
        git config user.email "dr.glasdou@gmail.com"

        echo "✅ Git configured for PERSONAL environment"
        echo "📧 Name: $(git config user.name)"
        echo "📧 Email: $(git config user.email)"
    else
        echo "⚠️  Not in a git repository. SSH key added but git config not changed."
    fi
}

# Function to load both SSH keys
gitall() {
    start_ssh_agent "$HOME/.ssh/work"
    start_ssh_agent "$HOME/.ssh/personal"

    echo "🔑 Both SSH keys loaded"
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        echo "📧 Current Git config:"
        echo "   Name: $(git config user.name)"
        echo "   Email: $(git config user.email)"
    fi
}

# Show current git configuration
gitconfig() {
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        echo "📧 Current repository Git config:"
        echo "   Name: $(git config user.name)"
        echo "   Email: $(git config user.email)"
        echo "🌐 Global Git config:"
        echo "   Name: $(git config --global user.name)"
        echo "   Email: $(git config --global user.email)"
    else
        echo "⚠️  Not in a git repository"
        echo "🌐 Global Git config:"
        echo "   Name: $(git config --global user.name)"
        echo "   Email: $(git config --global user.email)"
    fi
}

# Show SSH agent status and loaded keys
sshstatus() {
    if ssh-add -l >/dev/null 2>&1; then
        echo "🔑 SSH Agent Status: Running"
        echo "📋 Loaded keys:"
        ssh-add -l | while read -r line; do
            echo "   • $line"
        done
    else
        echo "❌ SSH Agent Status: Not running or no keys loaded"
    fi

    echo ""
    echo "🌐 Environment variables:"
    echo "   SSH_AGENT_PID: ${SSH_AGENT_PID:-'not set'}"
    echo "   SSH_AUTH_SOCK: ${SSH_AUTH_SOCK:-'not set'}"
}

# =============================================================================
# Development Shortcuts
# =============================================================================

# Quick project navigation (customize these paths)
alias dev="cd ~/dev"

# Flutter shortcuts
alias frun='flutter run'
alias fbuild='flutter build'
alias ftest='flutter test'
alias fclean='flutter clean'
alias fpub='flutter pub get'

# =============================================================================
# Claude Code Aliases (Multi-Account)
# =============================================================================

alias claude-personal='CLAUDE_CONFIG_DIR=$HOME/.claude-personal $HOME/.local/bin/claude'
alias claude-work='CLAUDE_CONFIG_DIR=$HOME/.claude-work $HOME/.local/bin/claude'

# =============================================================================
# Terminal Integration & Completions
# =============================================================================

# Angular CLI autocompletion
if command -v ng &> /dev/null; then
    source <(ng completion script)
fi

# VSCode Shell Integration
# [[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# Go Lang
export PATH="$HOME/go/bin:$PATH"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# The next line updates PATH for the Google Cloud SDK.
if [ -f "${HOME}/google-cloud-sdk/path.zsh.inc" ]; then . "${HOME}/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "${HOME}/google-cloud-sdk/completion.zsh.inc" ]; then . "${HOME}/google-cloud-sdk/completion.zsh.inc"; fi

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# Bitbucket API token
export BITBUCKET_USERNAME="dr.glasdou@gmail.com"
export BITBUCKET_API_TOKEN=$(security find-generic-password -a "$USER" -s "BITBUCKET_API_TOKEN" -w)

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/DARamirez/.lmstudio/bin"
# End of LM Studio CLI section

export GOPATH=$HOME/go

# pnpm
export PNPM_HOME="/Users/DARamirez/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"


# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
