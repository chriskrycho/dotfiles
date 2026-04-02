#!/usr/bin/env bash

#MISE description="Symlink config files from home/ to ~"
#MISE depends=["setup:install:packages"]

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
HOME_SRC="$DOTFILES_DIR/home"

echo "Symlinking config files from $HOME_SRC to $HOME..."

while IFS= read -r -d '' src; do
    rel="${src#"$HOME_SRC"/}"

    # Library/ is macOS-only
    if [[ "$rel" == Library/* ]] && [[ "$(uname)" != "Darwin" ]]; then
        continue
    fi

    dest="$HOME/$rel"
    dest_dir="$(dirname "$dest")"

    # Create parent directory only if it doesn't already exist
    if [[ ! -d "$dest_dir" ]]; then
        mkdir -p "$dest_dir"
    fi

    # Skip regular files that aren't ours — don't stomp user data
    if [[ -e "$dest" ]] && [[ ! -L "$dest" ]]; then
        echo "  SKIP (exists, not a symlink): $rel" >&2
        continue
    fi

    ln -sf "$src" "$dest"
    echo "  Linked: $rel"
done < <(find "$HOME_SRC" -type f -print0)

echo "Config files linked."
