require "theme"
require "settings"
require "plugins"
require "lsp"
require "mappings"
require "impatient"

vim.cmd [[autocmd BufEnter,BufWinEnter,WinEnter,CmdwinEnter * if bufname('%') == "NvimTree" | set laststatus=0 | else | set laststatus=2 | endif]]
