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
                "#81A1C1",
                "#88C0D0",
                "#8FBCBB",
                "#A3BE8C",
            },
            enable = true,
            extended_mode = true,
            max_file_lines = nil,
        },
    }
end
