local ok, nvimtree = pcall(require, "nvim-tree")

if ok then
    nvimtree.setup {}
    local signs = require("utils").signs

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
    nvimtree.setup {
        update_to_buf_dir = {
            enable = true,
            auto_open = true,
        },
        update_focused_file = {
            enable = true,
            update_cwd = true,
            ignore_list = {},
        },
        git = {
            enable = false,
        },
        filters = {
            dotfiles = false,
            custom = {
                ".git",
            },
        },
        view = {
            hide_root_folder = true,
            auto_resize = true,
        },
    }
end
