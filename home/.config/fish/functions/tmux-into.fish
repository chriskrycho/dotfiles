function tmux-into
    if test (count $argv) -lt 1
        echo "Usage: tmux-into <environment-id-or-name>" >&2
        return 1
    end

    set input $argv[1]

    # If the input looks like a UUID, use it directly; otherwise look up by name
    if string match -qr '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$' $input
        set env_id $input
    else
        set env_id (ona environment list | tail -n +2 | awk -v name=$input '$2 == name {print $1}')
        if test -z "$env_id"
            echo "tmux-into: no environment found with name '$input'" >&2
            return 1
        end
    end

    ona environment ssh $env_id --start -- \
        -R 52698:localhost:52698 \
        -t "tmux -CC new -A -s gitpod"
end