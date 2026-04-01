function _tide_item_jj
    command -sq jj or return

    set -l info (
        jj log 2>/dev/null --no-graph --ignore-working-copy --color=never --revisions @ \
            --template '
                surround(
                    "(",
                    ")",
                    separate(
                        " ",
                        bookmarks.join(", "),
                        change_id.shortest(),
                        commit_id.shortest(),
                        if(conflict, "×"),
                        if(divergent, "??"),
                        if(hidden, "(hidden)"),
                        if(immutable, "◆"),
                        coalesce(
                            if(
                                empty,
                                coalesce(
                                    if(parents.len() > 1, "(merged)"),
                                    "(empty)",
                                ),
                            ),
                            "*"
                        ),
                    )
                )
            '
    ) or return

    test -n "$info" and _tide_print_item jj $info
end
