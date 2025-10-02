function rubocop-reset --description "Reset RuboCop server (kill processes and clear cache)"
    # Kill any running RuboCop server processes
    set rubocop_pids (ps aux | grep "rubocop --server" | grep -v grep | awk '{print $2}')
    if test -n "$rubocop_pids"
        echo "Killing RuboCop server processes: $rubocop_pids"
        kill -9 $rubocop_pids
    else
        echo "No RuboCop server processes found"
    end

    # Remove server cache
    if test -d ~/.cache/rubocop_cache/server
        rm -rf ~/.cache/rubocop_cache/server
        echo "Removed RuboCop server cache"
    else
        echo "No RuboCop server cache found"
    end

    echo "RuboCop server reset complete"
end
