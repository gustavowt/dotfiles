set -x PATH /usr/local/bin $PATH
set -x PATH /usr/local/share/npm/bin $PATH
set -x PATH ~/go/bin $PATH
set -x PATH ~/.local/bin $PATH
set -x PATH /opt/homebrew/bin $PATH
set -x PATH ~/Library/Python/3.11/bin $PATH
set -x PATH ~/rails/works-on-my-machine/bin $PATH
set -Ux OBJC_DISABLE_INITIALIZE_FORK_SAFETY YES
set -Ux PGGSSENCMODE disable
set -Ux EDITOR nvim
eval (/Users/gustavo/rails/doximity/dox-compose/bin/dox-init)

#aliases
alias rake='bundle exec rake'
alias spec='bundle exec spec'
alias rspec='bundle exec rspec'
alias brails='bundle exec rails'
alias bengem='bundle exec engem'
alias clear_drive='rm -rf .fseventsd ._.Trashes .Trashes .Spotlight-V100'
alias rtest='env SPEC=true ruby -Itest'
alias mt='ctags -R ./app/ ./lib/'
alias bat="bat --theme='Solarized (dark)'"

source /opt/homebrew/opt/asdf/libexec/asdf.fish
status --is-interactive; and rbenv init - fish | source
nvm use lts

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.fish 2>/dev/null || :
source ~/.sensitive.fish 2>/dev/null || :
set -gx PATH $PATH ~/.local/bin
