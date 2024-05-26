set -x PATH /usr/local/bin $PATH
set -x PATH /usr/local/share/npm/bin $PATH
set -x PATH ~/go/bin $PATH
set -x PATH ~/.local/bin $PATH
set -x PATH /opt/homebrew/bin $PATH
set -x PATH ~/Library/Python/3.11/bin $PATH
set -U GEM_HOME ~/.local/share/nvim/lsp_servers/solargraph
set -Ux OBJC_DISABLE_INITIALIZE_FORK_SAFETY YES
set -Ux PGGSSENCMODE disable
set -Ux EDITOR lvim

#aliases
alias rake='bundle exec rake'
alias spec='bundle exec spec'
alias rspec='bundle exec rspec'
alias brails='bundle exec rails'
alias bengem='bundle exec engem'
alias clear_drive='rm -rf .fseventsd ._.Trashes .Trashes .Spotlight-V100'
alias rtest='env SPEC=true ruby -Itest'
alias mt='ctags -R ./app/ ./lib/'
alias cat="bat --theme='Solarized (dark)'"

source /opt/homebrew/opt/asdf/libexec/asdf.fish
status --is-interactive; and rbenv init - fish | source
