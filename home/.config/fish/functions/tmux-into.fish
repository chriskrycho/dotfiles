function tmux-into
    if test (count $argv) -lt 1
        echo "Usage: tmux-into <environment-id>" >&2
        return 1
    end

    gitpod environment ssh $argv[1] --start -- \
        -R 52698:localhost:52698 \
        -t "tmux -CC new -A -s gitpod"
end