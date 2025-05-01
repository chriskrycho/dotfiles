function fish_greeting
    echo '';
    echo (printf "\e[1m--> Glorify God. Love people.\e[0m")
end

function fish_prompt --description 'Write out the prompt'
    set -l last_status $status
    set -l normal (set_color normal)
    set -l status_color (set_color brgreen)
    set -l cwd_color (set_color $fish_color_cwd)
    set -l prompt_status ""

    # Since we display the prompt on a new line allow the directory names to be longer.
    set -q fish_prompt_pwd_dir_length
    or set -lx fish_prompt_pwd_dir_length 0

    # Color the prompt differently when we're root
    set -l suffix '➤'
    if functions -q fish_is_root_user; and fish_is_root_user
        if set -q fish_color_cwd_root
            set cwd_color (set_color $fish_color_cwd_root)
        end
        set suffix '!'
    end

    # Color the prompt in red on error
    if test $last_status -ne 0
        set status_color (set_color $fish_color_error)
        set prompt_status $status_color "[" $last_status "]" $normal
    end

    echo ''
    echo -s (prompt_login) ' ' $cwd_color (prompt_pwd --full-length-dirs=2 --dir-length=1) $normal ' ' $prompt_status
    echo -n -s $status_color $suffix ' ' $normal
end

function add_to_path
  set NEW_ENTRY $argv[1]
  string match -r $NEW_ENTRY $PATH > /dev/null; or set -gx PATH $NEW_ENTRY $PATH
end

# Homebrew setup
# Check for Homebrew in different locations
set -l brew_cmd
if test -x /opt/homebrew/bin/brew
    set brew_cmd /opt/homebrew/bin/brew  # macOS ARM
else if test -x /usr/local/bin/brew
    set brew_cmd /usr/local/bin/brew     # macOS Intel or Linux
else if test -x /home/linuxbrew/.linuxbrew/bin/brew
    set brew_cmd /home/linuxbrew/.linuxbrew/bin/brew  # Linux alternate location
end

# Only run brew shellenv if we found Homebrew
if test -n "$brew_cmd"
    eval ($brew_cmd shellenv)
else
    echo "INFO: brew not installed"
end

# PATH updates
add_to_path $HOME/.cargo/bin

# Don't attempt to set the shell title!
function fish_title
  # intentionally does nothing!
end

# GPG config
# set -gx GPG_TTY (tty)

# Aliases
alias "real-ls" /bin/ls
alias ls lsd
alias p pnpm

if test (uname) = "Darwin"
  set -gx EDITOR "bbedit -w"
end

if command -v volta &> /dev/null
  set -gx VOLTA_HOME "$HOME/.volta"
  set -gx PATH "$VOLTA_HOME/bin" $PATH
  set -gx VOLTA_FEATURE_PNPM 1
end

# Mise setup
~/.local/bin/mise activate fish | source
if status is-interactive
  mise activate fish | source
else
  mise activate fish --shims | source
end

if test -e ~/.config/op/plugins.sh
    source ~/.config/op/plugins.sh
end
