local utils = require "utils"
local map = utils.map

-- Disable move by arrow keys
map("n", "<Left>", "<cmd>echom 'ﮧ Use h bro!'<cr>")
map("n", "<Right>", "<cmd>echom 'ﮧ Use l bro!'<cr>")
map("n", "<Up>", "<cmd>echom 'ﮧ Use k bro!'<cr>")
map("n", "<Down>", "<cmd>echom 'ﮧ Use j bro!'<cr>")

-- Resize buffer
map("", "<M-l>", "<cmd>vertical resize +3<CR>", { silent = true, noremap = true })
map("", "<M-h>", "<cmd>vertical resize -3<CR>", { silent = true, noremap = true })
map("", "<M-j>", "<cmd>resize +3<CR>", { silent = true, noremap = true })
map("", "<M-k>", "<cmd>resize -3<CR>", { silent = true, noremap = true })

-- [vim-tmux-navigator] Moving arround vim buffers and tmux panes
map("n", "<c-k>", "<cmd>TmuxNavigateUp<cr>", { silent = true })
map("n", "<c-j>", "<cmd>TmuxNavigateDown<cr>", { silent = true })
map("n", "<c-h>", "<cmd>TmuxNavigateLeft<cr>", { silent = true })
map("n", "<c-l>", "<cmd>TmuxNavigateRight<cr>", { silent = true })

-- [bufferline] Moving arround buffer tab
map("", "<a-.>", "<cmd>BufferLineCycleNext<cr>", { silent = true }) -- Move to next buffer
map("", "<a-,>", "<cmd>BufferLineCyclePrev<cr>", { silent = true }) -- Move to prev buffer
map("", "<a-q>", "<cmd>bdelete<cr>", { silent = true }) -- Close current buffer
map("", "<a-Q>", "<cmd>bufdo bd<cr>", { silent = true }) -- Close all buffers

-- [nvim-tree]
map("n", "<c-n>", "<cmd>NvimTreeToggle<cr>")
map("n", "<leader>r", "<cmd>NvimTreeRefresh<cr>")

-- [Telescope]
map("", "<c-p>", "<cmd>Telescope find_files<cr>")
map("", "<leader>ff", "<cmd>Telescope find_files<cr>")
map("", "<leader>fg", "<cmd>Telescope live_grep<cr>")
map("", "<leader>fo", "<cmd>Telescope live_grep<cr>")
map("", "<leader>fb", "<cmd>Telescope buffers<cr>")
map("", "<leader>fh", "<cmd>Telescope help_tags<cr>")
map("", "<leader>fm", "<cmd>Telescope marks<cr>")

-- [dashboard.nvim]
map("", "<leader>fn", "<cmd>DashboardNewFile<cr>")

-- [Trouble.nvim]
map("n", "<leader>xx", "<cmd>Trouble<cr>", { silent = true, noremap = true })
map("n", "<leader>xw", "<cmd>Trouble lsp_workspace_diagnostics<cr>", { silent = true, noremap = true })
map("n", "<leader>xd", "<cmd>Trouble lsp_document_diagnostics<cr>", { silent = true, noremap = true })
map("n", "<leader>xl", "<cmd>Trouble loclist<cr>", { silent = true, noremap = true })
map("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", { silent = true, noremap = true })
map("n", "gR", "<cmd>Trouble lsp_references<cr>", { silent = true, noremap = true })

-- [Vista.vim] ctags
map("n", "<leader>v", "<cmd>Vista!!<cr>", { silent = true, noremap = true })

-- [symbols-outline.nvim] A tree like view for symbols
map("n", "<leader>s", "<cmd>SymbolsOutline<cr>", { silent = true, noremap = true })

-- [Neoformat]
map("n", "<leader>fm", "<cmd>Format<cr>", { silent = true, noremap = true })

map("i", "jj", "<Esc>")
