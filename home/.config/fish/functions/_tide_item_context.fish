function _tide_item_context
    if set -q SSH_TTY
        set -fx tide_context_color $tide_context_color_ssh
    else if test "$EUID" = 0
        set -fx tide_context_color $tide_context_color_root
    else if test "$tide_context_always_display" = true
        set -fx tide_context_color $tide_context_color_default
    else
        return
    end

    # In SSH sessions, prefer the ona environment name or ID over user@host.
    if set -q SSH_TTY; and command -sq ona
        set -l env_name (ona environment get --field name 2>/dev/null | string trim)
        if test -n "$env_name"
            _tide_print_item context $env_name
            return
        end

        set -l env_id (ona environment get --field id 2>/dev/null | string trim)
        if test -n "$env_id"
            _tide_print_item context $env_id
            return
        end
    end

    # Fall back to user@hostname (matches built-in tide behaviour).
    string match -qr "^(?<h>(\.?[^\.]*){0,$tide_context_hostname_parts})" @$hostname
    _tide_print_item context $USER$h
end
