local ok, lspcolors = pcall(require, "lsp-colors")

if ok then
    local colors = require "utils"

    lspcolors.setup {
        Error = colors.red,
        Warning = colors.yellow,
        Information = colors.blue,
        Hint = colors.cyan,
    }
end
