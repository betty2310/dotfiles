local utils = require "utils"

-- Load the colorscheme
local isExistNordTheme, fox = pcall(require, "nord")
if isExistNordTheme then
    vim.g.nord_contrast = false
    vim.g.nord_italic = true
    vim.g.nord_disable_background = false
    vim.g.nord_italic_comments = true

    vim.cmd [[colorscheme nord]]
end

vim.cmd [[set fcs=eob:\ ]]

local indent = 2
vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.cmd [[filetype plugin indent on]]
vim.cmd [[set noshowmode]]
vim.cmd [[
    set nobackup
    set noswapfile
]]

utils.opt("o", "guifont", "Liga SFMono Nerd Font:h11")
utils.opt("b", "expandtab", true)
utils.opt("b", "shiftwidth", indent)
utils.opt("b", "smartindent", true)
utils.opt("b", "tabstop", indent)
utils.opt("o", "hidden", true)
utils.opt("o", "ignorecase", true)
utils.opt("o", "scrolloff", 2)
utils.opt("o", "shiftround", true)
utils.opt("o", "smartcase", true)
utils.opt("o", "splitbelow", true)
utils.opt("o", "splitright", true)
utils.opt("w", "number", true)
utils.opt("w", "relativenumber", true)
utils.opt("o", "clipboard", "unnamed,unnamedplus")
utils.opt("w", "cursorline", true)
utils.opt("o", "shiftround", true)
utils.opt("o", "shortmess", vim.o.shortmess .. "c")
utils.opt("o", "mouse", "a")
utils.opt("o", "cmdheight", 1)

-- Highlight on yank
vim.cmd "au TextYankPost * lua vim.highlight.on_yank {on_visual = false}"

vim.api.nvim_command [[autocmd FileType python,c,cpp,go,lua set sw=4 ]]
vim.api.nvim_command [[autocmd FileType python,c,cpp,go,lua set ts=4 ]]
vim.api.nvim_command [[autocmd FileType python,c,cpp,go,lua set sts=4 ]]

vim.g.neovide_refresh_rate = 60
vim.g.neovide_cursor_vfx_mode = "pixiedust"
