status --is-interactive; and source (rbenv init -|psub)
set -gx PATH $PATH ~/.local/bin
set -gx PATH $PATH ~/.local/bin

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
eval (dox-init)
