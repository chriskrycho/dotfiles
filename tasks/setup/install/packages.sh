#!/usr/bin/env bash

#MISE description="Install packages from Brewfile"
#MISE depends=["setup:install:homebrew"]

# shellcheck source=tasks/setup/lib/homebrew.sh
source "$MISE_PROJECT_ROOT/tasks/setup/lib/homebrew.sh"
require_homebrew

install_bubblewrap_if_needed() {
  if [[ "$(uname -s)" != "Linux" ]]; then
    echo "Skipping bubblewrap; it is only needed on Linux."
    return 0
  fi

  if command -v bwrap &>/dev/null || brew list --formula bubblewrap &>/dev/null; then
    echo "bubblewrap is already installed."
    return 0
  fi

  echo "Installing bubblewrap..."
  local install_log
  install_log="$(mktemp)"
  if brew install bubblewrap >"$install_log" 2>&1; then
    cat "$install_log"
    rm -f "$install_log"
    return 0
  fi

  local install_status
  install_status=$?
  cat "$install_log" >&2

  if grep -q "no bottle available" "$install_log"; then
    echo "bubblewrap has no bottle for this environment; building from source..."
    rm -f "$install_log"
    brew install --build-from-source bubblewrap
    return
  fi

  rm -f "$install_log"
  return "$install_status"
}

echo "Installing Homebrew packages"
brew bundle install

install_bubblewrap_if_needed
