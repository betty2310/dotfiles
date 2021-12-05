local ok, nvimtree = pcall(require, "nvim-tree")

if ok then
    nvimtree.setup {}
    local signs = require("utils").signs

    function NvimTreeOSOpen()
        local lib = require "nvim-tree.lib"
        local node = lib.get_node_at_cursor()
        if node then
            vim.fn.jobstart("open '" .. node.absolute_path .. "' &", { detach = true })
        end
    end

    vim.g.nvim_tree_root_folder_modifier = ":t"
    vim.g.nvim_tree_quit_on_open = 1
    vim.g.nvim_tree_indent_markers = 1
    vim.g.nvim_tree_side = "left"
    vim.g.nvim_tree_width = 30
    vim.g.nvim_tree_window_picker_exclude = {
        filetype = {
            "packer",
            "qf",
        },
        buftype = {
            "terminal",
        },
    }
    vim.g.nvim_tree_special_files = { ["README.md"] = 1, ["Makefile"] = 1, ["MAKEFILE"] = 1 }
    vim.g.nvim_tree_show_icons = {
        git = 0,
        folders = 1,
        files = 1,
        folder_arrows = 0,
    }

    vim.g.nvim_tree_icons = {
        default = "",
        symlink = "",
        git = {
            unstaged = "✗",
            staged = "✓",
            unmerged = "",
            renamed = "➜",
            untracked = "★",
            deleted = "",
            ignored = "◌",
        },
        folder = {
            arrow_open = "",
            arrow_closed = "",
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
            symlink_open = "",
        },
        lsp = {
            hint = signs.Hint,
            info = signs.Info,
            warning = signs.Warning,
            error = signs.Error,
        },
    }
end
