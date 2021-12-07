sudo pacman --noconfirm -Syu
sudo pacman --noconfirm -S rustup cargo alacritty bspwm dunst kitty neovim picom polybar ranger rofi fish xorg xorg-xinit xorg-xinput unzip ripgepbat clang gdb lm_sensors playerctl light redshift exo tig bonsai xbacklight clangd-format peco gcc cmake exa ctags imwheel

mv ~/.config ~/.config-bak
mv ~/.Xauthority ~/.Xauthority-bak
mv ~/.Xresources ~/.Xresources-bak
mv ~/.fehbg ~/.fehbg-bak
mv ~/.tmux.conf ~/.tmux.conf-bak
mv ~/.xprofile ~/.xprofile-bak
mv ~/Pictures ~/Pictures-bak
mv ~/.scripts ~/.scripts-bak
rm -rf ~/.config
cp -r ./config ~/.config
cp ./config/.Xauthority ~/
cp ./config/.Xresources ~/
cp ./config/.fehbg ~/
cp ./config/.tmux.conf ~/
cp ./config/.xprofile ~/
cp ./config/.zshrc ~/
cp -r ./config/.script ~/
cp -r ./config/.ascii ~/
cp -r ./config/.local/bin ~/
cp -r ./Pictures ~/
cp -r ./.scripts ~/
cp -r ./fonts/* /usr/share/fonts/
mkdir ~/screenshots
