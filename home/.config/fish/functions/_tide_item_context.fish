function _tide_item_context
    set -l is_remote false
    if set -q SSH_CONNECTION; or set -q SSH_CLIENT; or set -q SSH_TTY
        set is_remote true
    end

    if test "$is_remote" = true
        set -fx tide_context_color $tide_context_color_ssh
    else if test "$EUID" = 0
        set -fx tide_context_color $tide_context_color_root
    else
        set -fx tide_context_color $tide_context_color_default
    end

    # Prefer the ona environment name or ID over user@host when available.
    if command -sq ona
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

    if test "$is_remote" != true; and test "$EUID" != 0; and test "$tide_context_always_display" != true
        return
    end

    # Fall back to user@hostname (matches built-in tide behaviour).
    string match -qr "^(?<h>(\.?[^\.]*){0,$tide_context_hostname_parts})" @$hostname
    _tide_print_item context $USER$h
end
