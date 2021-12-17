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
                colors.red,
                colors.orange,
                colors.yellow,
                colors.green,
                colors.magenta,
                colors.cyan,
                colors.blue,
            },
            enable = true,
            extended_mode = true,
            max_file_lines = nil,
        },
    }
end
