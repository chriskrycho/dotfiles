#!/usr/bin/env bash

#MISE description="Setup fish as the default shell"
#MISE depends=["setup:install:packages"]

# shellcheck source=tasks/setup/lib/homebrew.sh
source "$MISE_PROJECT_ROOT/tasks/setup/lib/homebrew.sh"
require_homebrew

current_login_shell() {
  case "$(uname -s)" in
    Darwin)
      dscl . -read "/Users/$(id -un)" UserShell 2>/dev/null | awk '{print $2}'
      ;;
    Linux)
      getent passwd "$(id -un)" | cut -d: -f7
      ;;
    *)
      echo "${SHELL:-}"
      ;;
  esac
}

if command -v fish &> /dev/null; then
  FISH_PATH=$(command -v fish)
  CURRENT_SHELL=$(current_login_shell)

  if [[ "$CURRENT_SHELL" == "$FISH_PATH" ]]; then
    echo "Fish is already the default login shell."
    exit 0
  fi

  if ! grep -Fxq "$FISH_PATH" /etc/shells; then
    echo "Adding fish to /etc/shells..."
    sudo -n add-shell "$FISH_PATH"
  fi

  echo "Setting fish as default shell..."
  sudo -n chsh -s "$FISH_PATH" "$(id -un)"
  echo "Default shell set to fish. Changes will take effect on next login."
else
  echo "Fish shell not found. Make sure it's installed via your Brewfile."
fi
