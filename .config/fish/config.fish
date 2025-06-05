set -g fish_greeting

set -x GOPATH $HOME/Developer/Packages/go

fish_add_path -p $GOPATH/bin $HOME/.cargo/bin $HOME/.local/share/bob/nvim-bin $HOME/.local/bin $HOME/.dotnet/tools

set -x EDITOR nvim

set -x GTK_IM_MODULE ""
set -x QT_IM_MODULE ""
set -x SDL_IM_MODULE ""


set -g fish_history_max 10000
set -g fish_history_save_on_exit 1

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

function lg --wraps lazygit
    lazygit $argv
end

function ld --wraps lazydocker
    lazydocker $argv
end

function random_quote
    set animal (random choice {default,dragon,dragon-and-cow,elephant,moose,stegosaurus,tux,vader,www})
    fortune -s | cowsay -f $animal -s
end

random_quote

