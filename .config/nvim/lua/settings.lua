local utils = require "utils"
local colors = require("utils").colors

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
vim.o.signcolumn = "yes"
-- Highlight on yank
vim.cmd "au TextYankPost * lua vim.highlight.on_yank {on_visual = false}"

utils.setSpacesSize { go = 4, python = 4, rust = 4, cpp = 4, c = 4, lua = 4 }

--vim.api.nvim_command [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

-- Disable comment new line
vim.cmd [[autocmd BufNewFile,BufRead * setlocal formatoptions-=cro]]

vim.cmd [[
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
hi TelescopePreviewTitle guibg=#a3be8c guifg=#2e3440 gui=italic
hi TelescopePromptTitle guibg=#bf616a guifg=#2e3440 gui=italic
hi TelescopeResultsTitle guibg=#ebcb8b guifg=#2e3440 gui=italic
]]
