set -g fish_greeting

set -x GOPATH $HOME/Developer/Packages/go

fish_add_path -p $GOPATH/bin $HOME/.cargo/bin $HOME/.local/share/bob/nvim-bin $HOME/.local/bin

set -x EDITOR nvim

zoxide init fish | source
starship init fish | source

function vim --wraps nvim
    nvim $argv
end

function g --wraps git
    git $argv
end

function vi --wraps nvim
    nvim $argv
end

function ls --wraps eza
    eza --icons $argv
end

function random_quote
  set animal (random choice {default,dragon,dragon-and-cow,elephant,moose,stegosaurus,tux,vader,www})
  fortune -s | cowsay -f $animal -s
end

random_quote
