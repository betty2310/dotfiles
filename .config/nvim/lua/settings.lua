local utils = require "utils"

-- Disable ~ character in empty lines
vim.cmd [[set fcs=eob:\ ]]

local indent = 2
vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.cmd [[inoremap jj <Esc>]]

vim.cmd [[filetype plugin indent on]]
vim.cmd [[set noshowmode]]
vim.cmd [[
    set nobackup
    set noswapfile
    set timeoutlen=200
]]

utils.opt("b", "expandtab", true)
utils.opt("b", "shiftwidth", indent)
utils.opt("b", "smartindent", true)
utils.opt("b", "tabstop", indent)
utils.opt("o", "hidden", true)
utils.opt("o", "ignorecase", true)
utils.opt("o", "scrolloff", 2)
utils.opt("o", "timeoutlen", 0)
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
vim.api.nvim_command [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

vim.cmd [[
autocmd BufEnter,BufWinEnter,WinEnter,CmdwinEnter * if bufname('%') == "NvimTree" | set laststatus=0 | else | set laststatus=2 | endif
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=1
highlight cursorLineNr guifg=#EBCb8B
hi CompetiTestRunning cterm=bold     gui=bold
hi CompetiTestDone    cterm=none     gui=none
hi CompetiTestCorrect ctermfg=green  guifg=#A3BE8C
hi CompetiTestWarning ctermfg=yellow guifg=#D08770
hi CompetiTestWrong   ctermfg=red    guifg=#BF616A
hi Normal guibg=NONE ctermbg=NONE
]]
