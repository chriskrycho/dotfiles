function tmux-into
    switch $argv[1]
        case cs
            gh cs ssh -c $argv[2] -- -t "tmux -CC new -A -s $argv[1]"
        case ona
            gitpod environment ssh $argv[2] --start -- -t "tmux -CC new -A -s $argv[1]"
        case '*'
            echo "Unknown environment: $argv[1]" >&2
            return 1
    end
end