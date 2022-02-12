local ok, onenord = pcall(require, "onenord")

if not ok then
    return
end

local colors = require("utils").colors

onenord.setup {
    borders = true,
    fade_nc = true,
    styles = {
        comments = "italic", -- Style that is applied to comments: see `highlight-args` for options
        strings = "NONE", -- Style that is applied to strings: see `highlight-args` for options
        keywords = "NONE", -- Style that is applied to keywords: see `highlight-args` for options
        functions = "NONE",
        variables = "NONE", -- Style that is applied to variables: see `highlight-args` for options
        diagnostics = "NONE",
    },
    disable = {
        background = true,
        cursorline = true,
        eob_lines = false,
    },
    custom_colors = {
        -- purple = "#88C0D0",
        -- yellow = "#88C0D0",
        -- orange = "#B48EAD",
        -- red = "#EBCB8B",
    },
}
