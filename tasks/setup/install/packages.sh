#!/usr/bin/env bash

#MISE description="Install packages from Brewfile"
#MISE depends=["setup:install:homebrew"]

# shellcheck source=tasks/setup/lib/homebrew.sh
source "$MISE_PROJECT_ROOT/tasks/setup/lib/homebrew.sh"
require_homebrew

echo "Installing Homebrew packages"
brew bundle install
