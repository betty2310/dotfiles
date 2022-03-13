<h1 align="center"> ━━━━━━  ❖  ━━━━━━ </h1>

<div align="center">
    <p></p>
    <a href="https://github.com/betty2310/nvim-backup/stargazers">
        <img src="https://img.shields.io/github/stars/betty2310/nvim-backup?color=%238FBCBB&labelColor=%233B4252&style=for-the-badge">
    </a>
    <a href="https://github.com/betty2310/nvim-backup/network/members/">
        <img src="https://img.shields.io/github/forks/betty2310/nvim-backup?color=%2388C0D0&labelColor=%233B4252&style=for-the-badge">
    </a>
    <img src="https://img.shields.io/github/repo-size/betty2310/nvim-backup?color=%2381A1C1&labelColor=%233B4252&style=for-the-badge">
   <img src="https://badges.pufler.dev/visits/betty2310/nvim-backup?style=for-the-badge&color=5E81AC&logoColor=white&labelColor=3B4252"/>
</div>

<p/>
  
### What is this?
Modular NeoVim configuration inspired by [@thanhvule0310](https://github.com/thanhvule0310/dotfiles/tree/main/nvim) nvimrc.

### Preview
![image](https://github.com/betty2310/file/blob/main/nvim/out.png?raw=true)
### Instalation
First, clone my repo to your .config.
```bash
$ git clone https://github.com/betty2310/nvim-backup ~/.config/nvim
```
I use [packer](https://github.com/wbthomason/packer.nvim) for plugin-manager. So you need to install it, and run:
```bash
$ nvim + PackerInstall
```
#### Main plugins 

|    Function    | Plugins                                                                                                       |
| :------------: | ------------------------------------------------------------------------------------------------------------- |
| Plugin Manager | [packer.nvim](https://github.com/wbthomason/packer.nvim)                                                      |
|  File Manager  | [nvim-tree.lua](https://github.com/kyazdani42/nvim-tree.lua)                                                  |
|  Status line   | [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)                                                 |
|  Buffer line   | [nvim-cokeline](https://github.com/noib3/nvim-cokeline)                                                          |
|  Colorscheme   | [onenord.nvim](https://github.com/betty2310/onenord.nvim)                                                       |
|      Icon      | [nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons)                                          |
|      Git       | [gitsign](https://github.com/lewis6991/gitsigns.nvim) |
| Auto Complete  | [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)                                                    |
| Debug          | [vimspector](https://github.com/puremourning/vimspector)                                                    |

### Keybinds
<kbd>leader</kbd> is <kbd>SPACE</kbd>
#### Nvimtree

| Keybind               | Action           |
| --------------------- | ---------------- |
| <kbd>ctrl + n</kbd>   | Toggle nvimtree  |
| <kbd>leader + r</kbd> | Refresh nvimtree |

#### Git <kbd>leader + g</kbd>

| Keybind                   | Action       |
| ------------------------- | ------------ |
| <kbd>leader + g + b</kbd> | Show diff    |
| <kbd>leader + g + p</kbd> | Preview hunk |
| <kbd>leader + g + r</kbd> | Toggle signs |

#### LSP <kbd>leader + l</kbd>

| Keybind                   | Action                   |
| ------------------------- | ------------------------ |
| <kbd>leader + l + c</kbd> | Show code actions        |
| <kbd>leader + l + d</kbd> | Preview definition       |
| <kbd>leader + l + x</kbd> | Finder                   |
| <kbd>leader + l + f</kbd> | Format current buffer    |
| <kbd>leader + l + h</kbd> | Show signature help      |
| <kbd>leader + l + n</kbd> | Diagnostic jump next     |
| <kbd>leader + l + p</kbd> | Diagnostic jump previous |
| <kbd>leader + l + r</kbd> | Rename                   |

#### Telescope <kbd>leader + f</kbd>

| Keybind                   | Action            |
| ------------------------- | ----------------- |
| <kbd>leader + f + f</kbd> | Find file         |
| <kbd>leader + f + g</kbd> | Find file by grep |
| <kbd>leader + f + b</kbd> | Find buffers      |
| <kbd>leader + f + h</kbd> | Help tags         |
| <kbd>leader + f + m</kbd> | Marks             |


#### Trouble <kbd>leader + x</kbd>

| Keybind                   | Action                        |
| ------------------------- | ----------------------------- |
| <kbd>leader + x + x</kbd> | Show trouble list             |
| <kbd>leader + x + d</kbd> | Show LSP document diagnostic  |
| <kbd>leader + x + l</kbd> | Locklist                      |
| <kbd>leader + x + q</kbd> | Quick fix                     |
| <kbd>leader + x + r</kbd> | References                    |
| <kbd>leader + x + w</kbd> | Show LSP workspace diagnostic |
<p align="center"><img src="https://raw.githubusercontent.com/arcticicestudio/nord-docs/develop/assets/images/nord/repository-footer-separator.svg?sanitize=true" /></p>
<p align="center"><a href="https://github.com/betty2310/nvim-backup/blob/main/LICENSE"><img src="https://img.shields.io/static/v1.svg?style=flat-square&label=License&message=GPL-3.0&logoColor=eceff4&logo=github&colorA=4c566a&colorB=88c0d0"/></a></p>
