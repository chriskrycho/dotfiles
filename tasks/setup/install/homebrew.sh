#!/usr/bin/env bash

#MISE description="Install Homebrew if not already installed"

if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH based on platform
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if [[ $(uname -m) == "arm64" ]]; then
      BREW_SHELLENV='eval "$(/opt/homebrew/bin/brew shellenv)"'
    else
      BREW_SHELLENV='eval "$(/usr/local/bin/brew shellenv)"'
    fi
  else
    # Linux
    BREW_SHELLENV='eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
  fi

  # Add to both bash and zsh configs
  for rcfile in ~/.bashrc ~/.zshrc; do
    if [[ -f "$rcfile" ]] || [[ "$rcfile" == ~/.bashrc ]] || [[ "$rcfile" == ~/.zshrc ]]; then
      if ! grep -q "brew shellenv" "$rcfile" 2>/dev/null; then
        echo "$BREW_SHELLENV" >> "$rcfile"
        echo "Added Homebrew to $rcfile"
      fi
    fi
  done

  # Source for current shell
  eval "$BREW_SHELLENV"

  brew --version &>/dev/null && echo "Homebrew installed successfully!"
else
  echo "Homebrew is already installed."
fi
