#!/usr/bin/env bash

#MISE description="Configure fish for homebrew (path etc.)"
#MISE depends=["setup:install:packages"]

echo "Configuring fish for mise..."

# Create fish config directory if it doesn't exist
mkdir -p ~/.config/fish

# Use brew shellenv to configure fish
fish -c '
  if not grep -q "mise activate fish" ~/.config/fish/config.fish 2>/dev/null
    echo "~/.local/bin/mise activate fish | source" >> ~/.config/fish/config.fish
  else
    echo "Homebrew shellenv already configured in fish"
  end
'
