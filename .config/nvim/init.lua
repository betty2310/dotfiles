require "theme"

vim.cmd [[
nmap ;;w  <Plug>(easymotion-w)
nmap ;;b  <Plug>(easymotion-b)

let g:nord_underline_option = 'none'
let g:nord_italic = v:false
let g:nord_italic_comments = v:true
let g:nord_minimal_mode = v:false
let g:nord_alternate_backgrounds = v:false
]]
--colorscheme nordic
require "settings"
require "plugins"
require "lsp"
require "mappings"
require "impatient"

require("better_escape").setup {
    mapping = { "jj" }, -- a table with mappings to use
    timeout = 300, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
    clear_empty_lines = false, -- clear line after escaping if there is only whitespace
    keys = "<Esc>", -- keys used for escaping, if it is a function will use the result everytime
}

vim.cmd [[autocmd BufEnter,BufWinEnter,WinEnter,CmdwinEnter * if bufname('%') == "NvimTree" | set laststatus=0 | else | set laststatus=2 | endif]]
