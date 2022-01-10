local ok, treesitter = pcall(require, "nvim-treesitter.configs")

if ok then
    local colors = require("utils").colors

    treesitter.setup {
        autotag = {
            enable = true,
        },
        ensure_installed = "all",
        highlight = {
            enable = true,
        },
        rainbow = {
            colors = {
                colors.magenta,
                colors.blue,
                colors.green,
                colors.yellow,
                colors.cyan,
                colors.green,
                colors.blue,
            },
            enable = true,
            extended_mode = true,
            max_file_lines = nil,
        },
    }
end
