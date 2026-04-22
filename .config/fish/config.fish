set -g fish_greeting

set -x GOPATH $HOME/Developer/Packages/go

set fish_pager_color_progress black --background=blue

fish_add_path -p $GOPATH/bin $HOME/.cargo/bin $HOME/.local/share/bob/nvim-bin $HOME/.local/bin $HOME/.dotnet/tools $HOME/.lmstudio/bin
fish_add_path /opt/homebrew/sbin
fish_add_path /opt/local/bin
fish_add_path /opt/local/sbin
fish_add_path /Users/betty/Library/Python/3.9/bin

# opencode
fish_add_path /Users/betty/.opencode/bin

fish_add_path /Users/betty/Developer/gnss-tools/gnss-sdr/install
fish_add_path /Users/betty/Developer/gnss-tools/gps-sdr-sim/

set -x EDITOR nvim

set -x fish_color_command green

set -g fish_history_max 10000
set -g fish_history_save_on_exit 1

zoxide init fish | source
starship init fish | source

function fish_user_key_bindings
    bind ctrl-shift-b backward-word
    bind ctrl-shift-f forward-word
    bind ctrl-d kill-word
end

function vim --wraps nvim
    nvim $argv
end

function g --wraps git
    git $argv
end

function c --wraps claude
    claude $argv
end

function vi --wraps nvim
    nvim $argv
end

function v --wraps nvim
    nvim $argv
end

function ls --wraps eza
    eza --icons --group-directories-first --git $argv
end

function lg --wraps lazygit
    lazygit $argv
end

function ld --wraps lazydocker
    lazydocker $argv
end

alias gnss-sdr-monitor="/Users/betty/Developer/gnss-tools/gnss-sdr-monitor/cmake-build-debug/src/gnss-sdr-monitor.app/Contents/MacOS/gnss-sdr-monitor"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

set --export DOTNET_ROOT /usr/local/share/dotnet
set --export PATH $DOTNET_ROOT $PATH

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
