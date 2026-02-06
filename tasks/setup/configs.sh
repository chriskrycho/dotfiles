#!/usr/bin/env bash

#MISE description="Deploy config files from home/ to ~"
#MISE depends=["setup:install:packages"]

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo "Deploying config files from $DOTFILES_DIR/home/ to $HOME..."
cp -R "$DOTFILES_DIR/home/." "$HOME/"
echo "Config files deployed."
