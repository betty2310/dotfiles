set fish_greeting ""

# starship prompt
starship init fish | source

# aliases
alias llt="exa --icons --git -a --tree -s type -I '.git|node_modules|bower_components|build'"
alias g git
alias fetch="rxfetch"
alias vi "nvim"
alias cat="bat"
alias ls="logo-ls -XD"
alias ll="logo-ls -XDlh"
alias lla="logo-ls -a -XDlh"
alias ide="tmux split-window -v -p 30"
alias za="zathura"
alias dots="~/.scripts/dots.sh"

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias :q='exit'
alias cl='clear'

#color scheme

set -U fish_color_param green
set -U fish_color_command brblue
set -U fish_color_operator green
set -U SPACEFISH_DIR_COLOR green
set -U fish_color_error red
set -U fish_color_comment yellow
set -U fish_color_quote yellow
set -gx EDITOR nvim
#set -x TERM xterm-256color

# PATH
set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH
set -gx PATH ~/.bin $PATH
set -gx PATH ~/.scripts $PATH

# NodeJS
set -gx PATH node_modules/.bin $PATH


# Go
set -g GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH

set -x FZF_DEFAULT_OPTS '-e --prompt="הּ " --preview "bat --color=always {1} --theme=ansi" --layout=reverse --height=50% --info=inline --border --margin=1 --padding=1'

alias yo="git add -A && git commit -m (curl -s 'whatthecommit.com/index.txt')"

#auto run tmux
#if status is-interactive
#and not set -q TMUX
#    exec tmux
#end
# random cool image
# colorscript -e pacman



