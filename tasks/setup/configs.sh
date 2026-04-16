#!/usr/bin/env bash

#MISE description="Symlink config files from home/ to ~"
#MISE depends=["setup:install:packages"]
#MISE [options]
#MISE flag("--force", "-f", help="Override existing non-symlink files (shows diff first)")

if [[ -z "${MISE_PROJECT_ROOT}" ]]; then
    echo "MISE_PROJECT_ROOT is not set; run this via mise (e.g. mise run setup:configs)" >&2
    exit 1
fi
DOTFILES_DIR="$MISE_PROJECT_ROOT"
HOME_SRC="$DOTFILES_DIR/home"

# Parse flags
FORCE=false
for arg in "$@"; do
    case "$arg" in
        --force|-f) FORCE=true ;;
    esac
done

# Pick a diff tool: prefer richer output, fall back to plain diff
pick_diff_tool() {
    if command -v delta &>/dev/null; then
        echo delta
    elif command -v difft &>/dev/null; then
        echo difft
    else
        echo diff
    fi
}

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
        if [[ "$FORCE" = false ]]; then
            echo "  SKIP (exists, not a symlink): $rel" >&2
            continue
        fi

        # --force: show the diff then override
        echo "  OVERRIDE (was not a symlink): $rel"
        DIFF_TOOL="$(pick_diff_tool)"
        echo "  --- diff via $DIFF_TOOL ---"
        "$DIFF_TOOL" "$dest" "$src" || true
        echo "  ---"
    fi

    ln -sf "$src" "$dest"
    echo "  Linked: $rel"
done < <(find "$HOME_SRC" -type f -print0)

echo "Config files linked."
