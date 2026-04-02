# Fisher plugin manager: use a separate path so plugins don't overwrite our config files.
# See: https://github.com/jorgebucaran/fisher/issues/640
set -g fisher_path ~/.local/share/fisher
set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..-1]
set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..-1]
for file in $fisher_path/conf.d/*.fish
    source $file
end

function fish_greeting
    echo '';
    echo (printf "\e[1m--> Glorify God. Love people.\e[0m")
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
fish_add_path (brew --prefix rustup)/bin

# # Don't attempt to set the shell title!
# function fish_title
#   # intentionally does nothing!
# end

# GPG config
# set -gx GPG_TTY (tty)

# Editor: use BBEdit via rmate reverse-tunnel protocol
set --export EDITOR "rmate --wait"

# Aliases
alias "real-ls" /bin/ls
alias ls eza
alias p pnpm

# Mise setup
if status is-interactive
  ~/.local/bin/mise activate fish | source
else
  ~/.local/bin/mise activate fish --shims | source
end

if test -e ~/.config/op/plugins.sh
    source ~/.config/op/plugins.sh
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
