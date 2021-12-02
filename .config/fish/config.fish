set fish_greeting ""

# aliases
alias llt="exa --icons --git -a --tree -s type -I '.git|node_modules|bower_components|build'"
alias g git
alias nv "nvim"
alias cat="bat"
alias ls="logo-ls -XD"
alias ll="logo-ls -XDlh"
alias lla="logo-ls -a -XDlh"
alias fetch="rxfetch"

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

set -gx EDITOR nvim
set -x TERM xterm-256color

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

# NodeJS
set -gx PATH node_modules/.bin $PATH

set -U fish_color_param green
set -U fish_color_command brblue
set -U fish_color_operator green

# Go
set -g GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH

#auto run tmux
#if status is-interactive
#and not set -q TMUX
#    exec tmux
#end
# random cool image
# colorscript -e pacman
