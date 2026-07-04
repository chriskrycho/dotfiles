#!/usr/bin/env bash

#MISE description="Install tide prompt plugin for fish via Fisher"
#MISE depends=["setup:fish:fisher", "setup:configs"]

# shellcheck source=tasks/setup/lib/homebrew.sh
source "$MISE_PROJECT_ROOT/tasks/setup/lib/homebrew.sh"
require_homebrew

if command -v fish &> /dev/null; then
  echo "Applying tide configuration..."
  fish -c "source ~/.config/fish/conf.d/tide_config.fish"
else
  echo "Fish shell not found. Make sure it's installed via your Brewfile."
fi
