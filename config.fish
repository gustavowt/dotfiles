set -x PATH /usr/local/bin $PATH
set -x PATH /usr/local/heroku/bin $PATH
set -x PATH /usr/local/share/npm/bin $PATH
set -x PATH /Applications/Postgres.app/Contents/Versions/13/bin $PATH
set -x PATH ~/go/bin $PATH
set -x PATH ~/.local/bin $PATH
set -x PATH ~/.gem/ruby/2.7.0/bin $PATH
set -U GEM_HOME ~/.local/share/nvim/lsp_servers/solargraph
set -U EDITOR lvim
set RUBY_GC_MALLOC_LIMIT 60000000
set RUBY_FREE_MIN 200000

#rbenv
set -x PATH $HOME/.rbenv/bin $PATH
set -x PATH $HOME/.rbenv/shims $PATH
rbenv rehash >/dev/null

#aliases
alias rake='bundle exec rake'
alias spec='bundle exec spec'
alias rspec='bundle exec rspec'
alias brails='bundle exec rails'
alias bengem='bundle exec engem'
alias clear_drive='rm -rf .fseventsd ._.Trashes .Trashes .Spotlight-V100'
alias rtest='env SPEC=true ruby -Itest'
alias mt='ctags -R ./app/ ./lib/'

source /usr/local/opt/asdf/libexec/asdf.fish
