<p align="center">
    <b>🐧 Betty's configuration files 🐧</b>
</p>

<div align="center">
    <p></p>
    <a href="https://github.com/betty2310/dotfiles/stargazers">
        <img src="https://img.shields.io/github/stars/betty2310/dotfiles?color=%238FBCBB&labelColor=%233B4252&style=for-the-badge">
    </a>
    <a href="https://github.com/betty2310/dotfiles/network/members/">
        <img src="https://img.shields.io/github/forks/betty2310/dotfiles?color=%2388C0D0&labelColor=%233B4252&style=for-the-badge">
    </a>
    <img src="https://img.shields.io/github/repo-size/betty2310/dotfiles?color=%2381A1C1&labelColor=%233B4252&style=for-the-badge">
   <img src="https://badges.pufler.dev/visits/betty2310/dotfiles?style=for-the-badge&color=5E81AC&logoColor=white&labelColor=3B4252"/>
</div>

<p/>
</br></br>
<img src="https://github.com/betty2310/file/blob/main/awesome/out.png?raw=true" alt="img" align="right" width="400px">

This is my personal collection of configuration files.


## 🐬 Here are some details about my setup

+ **WM**: [AwesomeWM](https://github.com/awesomeWM/awesome/) 💙 config included!
+ **OS**: Arch Linux
+ **Shell**: [fish](https://fishshell.com/)
+ **Terminal**: [st](https://st.suckless.org/) 💙 and [my config](https://github.com/betty2310/st)
+ **Editor**: [Neovim](https://github.com/neovim/neovim/) 💙 config included!
+ **Colorscheme**: [nord](https://www.nordtheme.com/)
+ **File Manager**: [Ranger](https://github.com/ranger/ranger) with [icons](https://github.com/alexanderjeurissen/ranger_devicons)
+ **Launcher**: [rofi](https://github.com/davatorium/rofi/) and [Ulauncher](https://ulauncher.io/)
+ **Compositor**: [Picom](https://github.com/Arian8j2/picom-jonaburg-fix) 

</br> </br> 
## :star: Setup

Here are the instructions you should follow to replicate my AwesomeWM setup.

1. Install the [git version of AwesomeWM](https://github.com/awesomeWM/awesome/).

   **Arch users** can use the [awesome-git AUR package](https://aur.archlinux.org/packages/awesome-git/).
   ```shell
   yay -S awesome-git
   ```

   **For other distros**, build instructions are [here](https://github.com/awesomeWM/awesome/#building-and-installation).

2. Install dependencies and enable services
   + Software

     - **Ubuntu** 18.04 or newer (and all Ubuntu-based distributions)

         ```shell
         sudo apt install rofi lm-sensors acpid jq fortune-mod redshift mpd mpc maim feh pulseaudio inotify-tools xdotool

         # Install light, which is not in the official Ubuntu repositories
         wget https://github.com/haikarainen/light/releases/download/v1.2/light_1.2_amd64.deb
         sudo dpkg -i light_1.2_amd64.deb
         ```

     - **Arch Linux** (and all Arch-based distributions)

         *Assuming your AUR helper is* `yay`

         ```shell
         yay -S rofi lm_sensors acpid jq fortune-mod redshift mpd mpc maim feh light-git pulseaudio inotify-tools xdotool
         ```
   + Services

      ```shell
      # For automatically launching mpd on login
      systemctl --user enable mpd.service
      systemctl --user start mpd.service
      # For charger plug/unplug events (if you have a battery)
      sudo systemctl enable acpid.service
      sudo systemctl start acpid.service
      ```

3. Install needed fonts

   You will need to install a few fonts (mainly icon fonts) in order for text and icons to be rendered properly. Almost is available
 in my folder [font](https://github.com/betty2310/dotfiles/tree/master/fonts). Just copy it to `/usr/share/fonts` or `~/.local/share/fonts/`

4. Install my AwesomeWM configuration files in your config folder `~/.config/`
5. Log out and enjoy.

## ⌨ Keybinds

I use <kbd>super</kbd> AKA alt key as my main modifier.

#### Keyboard
| Keybind | Action |
| --- | --- |
| <kbd>super + enter</kbd> | Spawn terminal |
| <kbd>super + shift + enter</kbd> | Spawn floating terminal |
| <kbd>super + /</kbd> | Launch rofi |
| <kbd>shift + space</kbd> | Launch Ulauncher |
| <kbd>super + q</kbd> | Close client |
| <kbd>super + space</kbd> | Toggle floating client |
| <kbd>super + [1-0]</kbd> | View tag AKA change workspace |
| <kbd>super + shift + [1-0]</kbd> | Move focused client to tag |
| <kbd>super + [hjkl]</kbd> | Change focus by direction |
| <kbd>super + shift + [hjkl]</kbd> | Move client by direction. Move to edge if it is floating. |
| <kbd>super + control + [hjkl]</kbd> | Resize client |
| <kbd>windowkey + n</kbd> | Change to next layout |
| <kbd>super + f</kbd> | Toggle fullscreen |
| <kbd>super + UpArrow</kbd> | Toggle Maximize |
| <kbd>super + DownArrow</kbd> | Minimize |
| <kbd>super + Tab</kbd> | toggle window switcher |
| <kbd>super + c</kbd> | Center floating client |
| <kbd>super + u</kbd> | Jump to urgent client (or back to last tag if there is no such client) |
| <kbd>super + b</kbd> | Toggle bar |
| <kbd>super + =</kbd> | Toggle tray |
| <kbd>super + p</kbd> | Toggle notif center |

*... And many many more.* 
You can press <kbd>windowkey + f</kbd> to show help keybindings default of Awesomewm
## :hugs: :hugs: And special thanks to:
* [Elenapan](https://github.com/elenapan/dotfiles) for awesomeWM's config. 
* [Thanhvule0310](https://github.com/thanhvule0310/dotfiles) for bspwm, neovim, polybar,... I'm newbie to Linux and his dotfiles help me so lot.
* [Nord](https://www.nordtheme.com/) for colorsheme that very suitable for me.
* [Bling](https://github.com/BlingCorp/bling) and [Rubato](https://github.com/andOrlando/rubato).
* Our local linux community [Linuxer Desktop Art](https://facebook.com/groups/linuxart), [r/unixporn](https://www.reddit.com/r/unixporn).
* © All artists who create icons, illustrations, and wallpapers.

<p align="center"><img src="https://raw.githubusercontent.com/arcticicestudio/nord-docs/develop/assets/images/nord/repository-footer-separator.svg?sanitize=true" /></p>

<p align="center"><a href="https://github.com/rxyhn/dotfiles/blob/main/LICENSE"><img src="https://img.shields.io/static/v1.svg?style=flat-square&label=License&message=GPL-3.0&logoColor=eceff4&logo=github&colorA=4c566a&colorB=88c0d0"/></a></p>
