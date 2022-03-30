#!/bin/sh

sameLine="\e[1A\e[K"

echo "🛑 Clearing configurations directory..."
rm -rf ~/ghq/github.com/betty2310/dotfiles/.config/
# creating it again for backup.
sleep 1
echo -e "$sameLine✅ Configurations directory cleared."
sleep 1

echo -e "$sameLine🏁 Starting backup..."
sleep 1
mkdir ~/ghq/github.com/betty2310/dotfiles/.config

echo -e "$sameLine🚩 Backup your dotfiles..."
sleep 1
cp -a ~/.config/awesome/ ~/ghq/github.com/betty2310/dotfiles/.config/
cp -a ~/.config/bat/ ~/ghq/github.com/betty2310/dotfiles/.config/
cp -a ~/.config/btop/ ~/ghq/github.com/betty2310/dotfiles/.config/
cp -a ~/.config/cava/ ~/ghq/github.com/betty2310/dotfiles/.config/
cp -a ~/.config/fish/ ~/ghq/github.com/betty2310/dotfiles/.config/
cp -a ~/.config/kitty/ ~/ghq/github.com/betty2310/dotfiles/.config/
cp -a ~/.config/mpd/ ~/ghq/github.com/betty2310/dotfiles/.config/
cp -a ~/.config/mpv/ ~/ghq/github.com/betty2310/dotfiles/.config/
cp -a ~/.config/mutt/ ~/ghq/github.com/betty2310/dotfiles/.config/
cp -a ~/.config/ncmpcpp/ ~/ghq/github.com/betty2310/dotfiles/.config/
cp -a ~/.config/neofetch/ ~/ghq/github.com/betty2310/dotfiles/.config/
cp -a ~/.config/nvim/ ~/ghq/github.com/betty2310/dotfiles/.config/
cp -a ~/.config/picom/ ~/ghq/github.com/betty2310/dotfiles/.config/
cp -a ~/.config/ranger/ ~/ghq/github.com/betty2310/dotfiles/.config/
cp -a ~/.config/zathura/ ~/ghq/github.com/betty2310/dotfiles/.config/
cp -a ~/.config/fontconfig/ ~/ghq/github.com/betty2310/dotfiles/.config/
cp -a ~/.config/ulauncher/ ~/ghq/github.com/betty2310/dotfiles/.config/
cp ~/.config/starship.toml ~/ghq/github.com/betty2310/dotfiles/.config/

echo -e "$sameLine🚩 Backup your scripts..."
sleep 1
rm -rf ~/ghq/github.com/betty2310/dotfiles/.scripts/*
cp ~/.scripts/* ~/ghq/github.com/betty2310/dotfiles/.scripts/

echo -e "$sameLine🚩 Backup another..."
sleep 1
rm -rf ~/ghq/github.com/betty2310/dotfiles/X11/*
cp ~/.xprofile ~/ghq/github.com/betty2310/dotfiles/X11/
cp ~/.Xresources ~/ghq/github.com/betty2310/dotfiles/X11/
cp ~/.xinitrc ~/ghq/github.com/betty2310/dotfiles/X11/
#git add .
timestamp() {
	date +"%d-%m-%Y at %T"
}
cd ~/ghq/github.com/betty2310/dotfiles/
git add .
git commit -m "⭐ feat(*): automatic update: $(timestamp)"
echo -e "$sameLine🎉 Backup finished! You can push to remote on github.com."
