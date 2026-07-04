#!/usr/bin/env bash

#MISE description="Install Homebrew if not already installed"

# shellcheck source=tasks/setup/lib/homebrew.sh
source "$MISE_PROJECT_ROOT/tasks/setup/lib/homebrew.sh"

setup_homebrew_env

if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  setup_homebrew_env
  require_homebrew
  BREW_SHELLENV="eval \"\$($(command -v brew) shellenv)\""

  # Add to both bash and zsh configs
  for rcfile in ~/.bashrc ~/.zshrc; do
    if [[ -f "$rcfile" ]] || [[ "$rcfile" == ~/.bashrc ]] || [[ "$rcfile" == ~/.zshrc ]]; then
      if ! grep -q "brew shellenv" "$rcfile" 2>/dev/null; then
        echo "$BREW_SHELLENV" >> "$rcfile"
        echo "Added Homebrew to $rcfile"
      fi
    fi
  done

  echo "Homebrew installed successfully!"
else
  echo "Homebrew is already installed."
fi
