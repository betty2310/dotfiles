local ok, onenord = pcall(require, "onenord")
local colors = require("utils").colors

if ok then
    onenord.setup {
        borders = true,
        italics = {
            comments = true,
            strings = false,
            keywords = false,
            functions = false,
            variables = false,
        },
        disable = {
            background = false,
            cursorline = false,
            eob_lines = true,
        },
        custom_highlights = {
            GitSignsAdd = { fg = colors.green },
            GitSignsChange = { fg = colors.orange },
            GitSignsDelete = { fg = colors.red },
            NvimTreeNormal = { fg = colors.fg, bg = colors.bg },
            CmpItemAbbr = { fg = colors.fg1 },
            CmpItemAbbrDeprecated = { fg = colors.red },
            CmpItemAbbrMatch = { fg = colors.green, style = "bold" },
            CmpItemKind = { fg = colors.orange },
            CmpItemMenu = { fg = colors.magenta },
            CmpItemAbbrMatchFuzzy = { fg = colors.yellow },

            LspFloatWinNormal = { bg = colors.bg },
        },
    }
end
