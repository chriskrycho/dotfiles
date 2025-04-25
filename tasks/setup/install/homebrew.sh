#!/usr/bin/env bash

#MISE description = "Install Homebrew if not already installed"

if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH based on platform
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if [[ $(uname -m) == "arm64" ]]; then
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.profile
      eval "$(/opt/homebrew/bin/brew shellenv)"
    else
      echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.profile
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  else
    # Linux
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi

  # Add Homebrew to PATH immediately for this session
  # Avoid masking return values by separating declaration and assignment
  PATH="$PATH:$(/home/linuxbrew/.linuxbrew/bin/brew --prefix)/bin"
  export PATH

  brew --version &>/dev/null && echo "Homebrew installed successfully!"
else
  echo "Homebrew is already installed."
fi
