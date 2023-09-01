set fish_git_dirty_color red

function fish_prompt
    printf '%s%s %s[%s]%s %s%s %s%s$ ' (set_color green) (whoami) (set_color magenta) (prompt_pwd) (set_color normal)
end
