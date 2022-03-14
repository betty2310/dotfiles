set fish_greeting ""

# starship prompt
starship init fish | source

# aliases
alias llt="exa --icons --git -a --tree -s type -I '.git|node_modules|bower_components|build'"
alias g git
alias fetch="rxfetch"
alias vi "nvim"
alias nv "nvim"
alias cl="clear"
alias cat="bat"
alias ls="logo-ls -XD"
alias ll="logo-ls -XDlh"
alias lla="logo-ls -a -XDlh"
alias ide="tmux split-window -v -p 30"
alias za="zathura"
alias dots="~/.scripts/dots.sh"
alias pls="sudo"

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias :q='exit'

# alias for searching and installing packages
alias pacs="pacman -Slq | fzf -m --preview 'bat --color=always --theme=ansi (pacman -Si {1} | psub) (pacman -Fl {1} | psub |  awk \"{print \$2}\")' | xargs -ro sudo pacman -S"
# alias for searching and installing packages from AUR
alias yays="yay -Slq | fzf -m --preview 'bat (yay -Si {1} | psub) <(yay -Fl {1} | awk \"{print \$2}\" | psub)' | xargs -ro  yay -S"
# alias for searching and removing packages from system
alias pacr="pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns"

alias mirror-update='sudo reflector --verbose -c Vietnam -c Japan -c Singapore --sort rate --save /etc/pacman.d/mirrorlist'

#color scheme

set -U fish_color_param green
set -U fish_color_command brblue
set -U fish_color_operator green
set -U SPACEFISH_DIR_COLOR green
set -U fish_color_error red
set -U fish_color_comment yellow
set -U fish_color_quote yellow
set -g EDITOR nvim
#set -x TERM xterm-256color
set -g man_bold -o green

# PATH
set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH
set -gx PATH ~/.bin $PATH
set -gx PATH ~/.scripts $PATH
set -gx PATH /usr/local/texlive/2021/bin/x86_64-linux/ $PATH

# NodeJS
set -gx PATH node_modules/.bin $PATH

# Go
set -g GOPATH $HOME/go $PATH
set -gx PATH $GOPATH/bin $PATH

#set -x FZF_DEFAULT_OPTS '-e --prompt="הּ " --preview "bat --color=always {1} --theme=ansi" --layout=reverse --height=50% --info=inline --border --margin=1 --padding=1'
set -x FZF_DEFAULT_OPTS '--prompt="הּ "
    --color=hl:#81a1c1
    --color=hl+:#BF616A
    --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
    --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b --layout=reverse --border --margin=1 --padding=1'

alias yo="git add -A && git commit -m (curl -s 'whatthecommit.com/index.txt')"

#auto run tmux
#if status is-interactive
#and not set -q TMUX
#    exec tmux
#end
# random cool image
#colorscript -r
function fish_title
    set -q argv[1];
    # Looks like ~/d/fish: git log
    # or /e/apt: fish
    echo (fish_prompt_pwd_dir_length=1 prompt_pwd) [$argv];
end
thefuck --alias | source
