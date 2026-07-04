#!/usr/bin/env bash

#MISE description="Install Fisher plugin manager for fish"
#MISE depends=["setup:fish:use_as_default", "setup:configs"]

# shellcheck source=tasks/setup/lib/homebrew.sh
source "$MISE_PROJECT_ROOT/tasks/setup/lib/homebrew.sh"
require_homebrew

if command -v fish &> /dev/null; then
  if fish -c "type -q fisher" 2>/dev/null; then
    echo "Fisher already installed."
  else
    echo "Installing Fisher..."
    fish -c "source ~/.config/fish/config.fish; curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
    echo "Fisher installed."
  fi

  echo "Installing Fisher plugins from ~/.config/fish/fish_plugins..."
  fish -c "source ~/.config/fish/config.fish; fisher update"
else
  echo "Fish shell not found. Make sure it's installed via your Brewfile."
fi
