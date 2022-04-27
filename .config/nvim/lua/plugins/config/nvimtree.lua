local ok, nvimtree = pcall(require, "nvim-tree")

if not ok then
    return
end

local signs = require("utils").signs

-- vim.g.nvim_tree_window_picker_exclude = {
--     filetype = {
--         "packer",
--         "qf",
--     },
--     buftype = {
--         "terminal",
--     },
-- }
vim.g.nvim_tree_special_files = {}
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
}

nvimtree.setup {
    disable_netrw = true,
    hijack_netrw = true,
    open_on_setup = false,
    ignore_ft_on_setup = {},
    -- auto_close = true,
    open_on_tab = false,
    hijack_cursor = false,
    update_cwd = false,
    update_to_buf_dir = {
        enable = true,
        auto_open = true,
    },
    diagnostics = {
        enable = false,
        icons = {
            hint = signs.Hint,
            info = signs.Info,
            warning = signs.Warning,
            error = signs.Error,
        },
    },
    update_focused_file = {
        enable = false,
        update_cwd = false,
        ignore_list = {},
    },
    system_open = {
        cmd = nil,
        args = {},
    },
    filters = {
        dotfiles = false,
        custom = {},
    },
    git = {
        enable = false,
        ignore = false,
        timeout = 500,
    },
    view = {
        width = 30,
        height = 30,
        hide_root_folder = true,
        side = "left",
        auto_resize = false,
        mappings = {
            custom_only = false,
            list = {},
        },
        number = false,
        relativenumber = false,
        signcolumn = "yes",
    },
    trash = {
        cmd = "trash",
        require_confirm = true,
    },
    actions = {
        change_dir = {
            global = false,
        },
        open_file = {
            quit_on_open = true,
        },
    },
}
