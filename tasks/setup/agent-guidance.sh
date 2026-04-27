#!/usr/bin/env bash

#MISE description="Install global agent guidance and local supplemental links"
#MISE depends=["setup:install:packages"]
#MISE [options]
#MISE flag("--force", "-f", help="Override existing non-symlink files after showing a diff")

set -euo pipefail

if [[ -z "${MISE_PROJECT_ROOT}" ]]; then
    echo "MISE_PROJECT_ROOT is not set; run this via mise (e.g. mise run setup:agent-guidance)" >&2
    exit 1
fi

DOTFILES_DIR="$MISE_PROJECT_ROOT"
AGENTS_GUIDANCE="$DOTFILES_DIR/home/.agents/AGENTS.md"
AGENTS_SKILLS_DIR="$DOTFILES_DIR/home/.agents/skills"
GUIDANCE_DIR="$DOTFILES_DIR/home/.config/agent-guidance"
CLAUDE_SRC_DIR="$DOTFILES_DIR/home/.claude"

FORCE=false
for arg in "$@"; do
    case "$arg" in
        --force|-f) FORCE=true ;;
    esac
done

pick_diff_tool() {
    if command -v delta &>/dev/null; then
        echo delta
    elif command -v difft &>/dev/null; then
        echo difft
    else
        echo diff
    fi
}

vanta_checkout_path() {
    local remote_checkout="/workspaces/obsidian"
    local local_checkout="$HOME/dev/VantaInc/obsidian"

    if command -v ona &>/dev/null && ona environment get &>/dev/null; then
        echo "$remote_checkout"
    else
        echo "$local_checkout"
    fi
}

link_file() {
    local src="$1"
    local dest="$2"
    local label="$3"
    local dest_dir

    dest_dir="$(dirname "$dest")"
    mkdir -p "$dest_dir"

    if [[ -L "$dest" || ! -e "$dest" ]]; then
        ln -sf "$src" "$dest"
        echo "  Linked: $label"
        return
    fi

    if [[ -f "$dest" && ! -s "$dest" ]]; then
        ln -sf "$src" "$dest"
        echo "  Linked: $label (replaced empty file)"
        return
    fi

    if [[ "$FORCE" = false ]]; then
        echo "  SKIP (exists, not a symlink): $label" >&2
        return
    fi

    echo "  OVERRIDE (was not a symlink): $label"
    local diff_tool
    diff_tool="$(pick_diff_tool)"
    echo "  --- diff via $diff_tool ---"
    "$diff_tool" "$dest" "$src" || true
    echo "  ---"

    ln -sf "$src" "$dest"
    echo "  Linked: $label"
}

link_skill_dirs() {
    local dest_root="$1"
    local label_root="$2"

    if [[ ! -d "$AGENTS_SKILLS_DIR" ]]; then
        return
    fi

    mkdir -p "$dest_root"

    local src
    while IFS= read -r -d '' src; do
        local skill_name
        skill_name="$(basename "$src")"

        if [[ ! -f "$src/SKILL.md" ]]; then
            echo "  SKIP (missing SKILL.md): $src" >&2
            continue
        fi

        link_file "$src" "$dest_root/$skill_name" "$label_root/$skill_name"
    done < <(find "$AGENTS_SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d -print0)
}

echo "Installing agent guidance..."

link_file "$AGENTS_GUIDANCE" "$HOME/.codex/AGENTS.md" ".codex/AGENTS.md"
link_file "$CLAUDE_SRC_DIR/CLAUDE.md" "$HOME/.claude/CLAUDE.md" ".claude/CLAUDE.md"
link_file "$CLAUDE_SRC_DIR/RTK.md" "$HOME/.claude/RTK.md" ".claude/RTK.md"
link_skill_dirs "$HOME/.codex/skills" ".codex/skills"
link_skill_dirs "$HOME/.claude/skills" ".claude/skills"

VANTA_CHECKOUT="$(vanta_checkout_path)"
if [[ -d "$VANTA_CHECKOUT" ]]; then
    link_file "$GUIDANCE_DIR/vanta-agent-guidance.md" "$VANTA_CHECKOUT/AGENTS.local.md" "$VANTA_CHECKOUT/AGENTS.local.md"
else
    echo "  SKIP (Vanta checkout not found): $VANTA_CHECKOUT"
fi

echo "Agent guidance installed."
