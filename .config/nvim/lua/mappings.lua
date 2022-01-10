local ok, wk = pcall(require, "which-key")
local utils = require "utils"
local map = utils.map

-- Disable move by arrow keys
map("n", "<Left>", "<cmd>echom 'ﮧ Use h bro!'<cr>")
map("n", "<Right>", "<cmd>echom 'ﮧ Use l bro!'<cr>")
map("n", "<Up>", "<cmd>echom 'ﮧ Use k bro!'<cr>")
map("n", "<Down>", "<cmd>echom 'ﮧ Use j bro!'<cr>")

wk.register {

    -- [bufferline] Moving arround buffer tab
    ["[b"] = { "<cmd>BufferLineCycleNext<cr>", "Go next buffer" },
    ["]b"] = { "<cmd>BufferLineCyclePrev<cr>", "Go previous buffer" },
    ["<leader>mv"] = { "<cmd>bdelete<cr>", "Close current buffer" },
    -- [run]
    ["<leader>tg"] = { "<cmd>ToggleTerm direction=float<cr>", "[toggleterm] Open floating terminal" },
    ["<leader>g"] = { '<cmd>TermExec cmd="g++ -Wall % && ./a.out" go_back=0 size=13<cr>', "[C++] Compile an run!!" },
    -- [nvim-tree]
    ["<c-n>"] = { "<cmd>NvimTreeToggle<cr>", "[nvimtree] Toggle" },
    ["<leader>r"] = { "<cmd>NvimTreeRefresh<cr>", "[nvimtree] Refresh" },

    -- [Telescope]
    ["<leader>f"] = {
        name = "+file",
        f = { "<cmd>Telescope find_files<cr>", "[Telescope] Find File" },
        g = { "<cmd>Telescope live_grep<cr>", "[Telescope] Find File by grep" },
        b = { "<cmd>Telescope buffers<cr>", "[Telescope] Find buffers" },
        h = { "<cmd>Telescope help_tags<cr>", "[Telescope] Help tags" },
        m = { "<cmd>Telescope marks<cr>", "[Telescope] Marks" },
        o = { "<cmd>Telescope oldfiles<cr>", "[Telescope] Old files" },
    },

    -- [Trouble.nvim]
    ["<leader>x"] = {
        x = { "<cmd>Trouble<cr>", "[Trouble] Show trouble list" },
        w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "[Trouble] Show LSP workspace diagnostic" },
        d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "[Trouble] Show LSP Document diagnostic" },
        l = { "<cmd>Trouble loclist<cr>", "[Trouble] Locklist" },
        q = { "<cmd>Trouble quickfix<cr>", "[Trouble] Quick fix" },
    },
    ["gR"] = { "<cmd>Trouble lsp_references<cr>", "[Trouble] References" },

    -- [Vista.vim] ctags
    ["<leader>v"] = { "<cmd>Vista!!<cr>", "[Vista] Show" },

    -- [symbols-outline.nvim] A tree like view for symbols
    ["<leader>s"] = { "<cmd>SymbolsOutline<cr>", "[Symbol Outline] Show" },

    -- [lspsaga]
    ["K"] = { "<cmd>Lspsaga hover_doc<CR>", "[SAGA] Hover doc" },
    ["<leader>ls"] = {
        n = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "[SAGA] Diagnostic jump next" },
        p = { "<cmd>Lspsaga diagnostic_jump_prev<cr>", "[SAGA] Diagnostic jump previous" },
        d = { "<cmd>Lspsaga preview_definition<cr>", "[SAGA] Preview definition" },
        f = { "<cmd>Lspsaga lsp_finder<cr>", "[SAGA] LSP Finder" },
        c = { "<cmd>Lspsaga code_action<cr>", "[SAGA] Code Action" },
    },
    ["<leader>rn"] = { "<cmd>Lspsaga rename<cr>", "[SAGA] Rename" },
}
wk.setup {}
