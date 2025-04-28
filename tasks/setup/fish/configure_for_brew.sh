#!/usr/bin/env bash

#MISE description="Configure fish for homebrew (path etc.)"
#MISE depends=["setup:install:packages"]

echo "Configuring fish for Homebrew..."

# Create fish config directory if it doesn't exist
mkdir -p ~/.config/fish

# Use brew shellenv to configure fish
fish -c '
  if not grep -q "brew shellenv" ~/.config/fish/config.fish 2>/dev/null
    # Find brew executable path
    set brew_cmd (which brew)
    if test -n "$brew_cmd"
      echo "# Homebrew setup" >> ~/.config/fish/config.fish
      echo "eval ($brew_cmd shellenv)" >> ~/.config/fish/config.fish
      echo "Added Homebrew shellenv to fish config"
    else
      echo "Could not find Homebrew installation"
    end
  else
    echo "Homebrew shellenv already configured in fish"
  end
'
