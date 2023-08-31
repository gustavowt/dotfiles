set fish_git_dirty_color red

function get_ruby_version
  echo (ruby --version | cut -d' ' -f2)
end

function fish_prompt
    printf '%s%s %s[%s]%s %s%s %s%s$ ' (set_color green) (whoami) (set_color brblue) (prompt_pwd) (set_color purple) (get_ruby_version) (set_color normal)
end
