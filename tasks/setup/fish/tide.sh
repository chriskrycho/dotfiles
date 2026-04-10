#!/usr/bin/env bash

#MISE description="Install tide prompt plugin for fish via Fisher"
#MISE depends=["setup:fish:fisher", "setup:configs"]

if command -v fish &> /dev/null; then
  if fish -c "type -q tide" 2>/dev/null; then
    echo "Tide already installed."
  else
    echo "Installing Tide..."
    fish -c "fisher install IlanCosman/tide@v6"
    echo "Tide installed."
  fi
  echo "Applying tide configuration..."
  fish -c "source ~/.config/fish/conf.d/tide_config.fish"
else
  echo "Fish shell not found. Make sure it's installed via your Brewfile."
fi
