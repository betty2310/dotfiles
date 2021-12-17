local ok, gl = pcall(require, "galaxyline")

if ok then
    local colors = require("utils").colors
    local powerline = require("utils").powerline.arrow
    local gls = gl.section

    local function trailing_whitespace()
        local trail = vim.fn.search("\\s$", "nw")
        if trail ~= 0 then
            return " "
        else
            return nil
        end
    end

    TrailingWhiteSpace = trailing_whitespace

    local buffer_not_empty = function()
        if vim.fn.empty(vim.fn.expand "%:t") ~= 1 then
            return true
        end
        return false
    end

    local checkwidth = function()
        local squeeze_width = vim.fn.winwidth(0) / 2
        if squeeze_width > 40 then
            return true
        end
        return false
    end

    gl.short_line_list = { "NvimTree", "vista", "dbui" }

    gls.left[1] = {
        ViModeStart = {
            provider = function()
                local mode_color = {
                    n = colors.cyan,
                    i = colors.green,
                    v = colors.magenta,
                    c = colors.red,
                    no = colors.magenta,
                    s = colors.orange,
                    [""] = colors.orange,
                    ic = colors.yellow,
                    R = colors.magenta,
                    Rv = colors.magenta,
                    cv = colors.red,
                    ce = colors.red,
                    r = colors.cyan,
                    rm = colors.cyan,
                    ["r?"] = colors.cyan,
                    ["!"] = colors.red,
                    t = colors.red,
                }
                vim.api.nvim_command("hi GalaxyViModeStart guibg=" .. mode_color[vim.fn.mode()])
                return " "
            end,
            separator = " ",
            separator_highlight = { "NONE", colors.black },
            highlight = { colors.red, colors.bg, "bold" },
        },
    }

    gls.left[2] = {
        ViMode = {
            provider = function()
                local mode_color = {
                    n = colors.cyan,
                    i = colors.green,
                    v = colors.magenta,
                    c = colors.red,
                    no = colors.magenta,
                    s = colors.orange,
                    [""] = colors.orange,
                    ic = colors.yellow,
                    R = colors.magenta,
                    Rv = colors.magenta,
                    cv = colors.red,
                    ce = colors.red,
                    r = colors.cyan,
                    rm = colors.cyan,
                    ["r?"] = colors.cyan,
                    ["!"] = colors.red,
                    t = colors.red,
                }

                local alias = {
                    n = "NORMAL גּ ",
                    i = "INSERT הּ ",
                    c = "COMMAND בּ ",
                    V = "VISUAL  ",
                    [""] = "VISUAL  ",
                    v = "VISUAL  ",
                    R = "REPLACE הּ ",
                    no = "no",
                    s = "SELECT הּ ",
                    [""] = " ",
                    ic = "ic",
                    Rv = "Rv",
                    cv = "cv",
                    ce = "ce",
                    r = "R",
                    rm = "RM",
                    ["r?"] = "r?",
                    ["!"] = "!",
                    t = "TERMINAL  ",
                }
                vim.api.nvim_command("hi GalaxyViMode guifg=" .. mode_color[vim.fn.mode()])
                return alias[vim.fn.mode()]
            end,
            highlight = { colors.red, colors.black, "bold" },
            separator = powerline.right,
            separator_highlight = { colors.black, colors.bg },
        },
    }

    gls.right[1] = {
        LeftPLEnd = {
            provider = function()
                return powerline.left
            end,
            highlight = { colors.bg1, colors.bg },
        },
    }

    gls.right[2] = {
        FileIcon = {
            separator = " ",
            separator_highlight = { colors.bg1, colors.bg1 },
            provider = "FileIcon",
            condition = buffer_not_empty,
            highlight = {
                require("galaxyline.provider_fileinfo").get_file_icon_color,
                colors.bg1,
            },
        },
    }

    gls.right[3] = {
        FileName = {
            provider = { "FileName" },
            condition = buffer_not_empty,
            highlight = { require("galaxyline.provider_fileinfo").get_file_icon_color, colors.bg1 },
        },
    }

    gls.right[4] = {
        DiagnosticError = {
            provider = "DiagnosticError",
            icon = " ",
            highlight = { colors.red, colors.bg1 },
        },
    }

    gls.right[5] = {
        DiagnosticWarn = {
            provider = "DiagnosticWarn",
            icon = " ",
            highlight = { colors.yellow, colors.bg1 },
        },
    }

    gls.right[6] = {
        DiagnosticHint = {
            provider = "DiagnosticHint",
            icon = " ",
            highlight = { colors.cyan, colors.bg1 },
        },
    }

    gls.right[7] = {
        DiagnosticInfo = {
            provider = "DiagnosticInfo",
            icon = " ",
            highlight = { colors.blue, colors.bg1 },
        },
    }

    gls.right[8] = {
        GetLspClient = {
            provider = "GetLspClient",
            icon = "  ",
            highlight = { colors.green, colors.bg1, "italic" },
            separator = " ",
            separator_highlight = { "NONE", colors.bg1 },
        },
    }

    gls.right[9] = {
        FileEncode = {
            provider = "FileEncode",
            separator = " ",
            separator_highlight = { "NONE", colors.bg1 },
            highlight = { colors.blue, colors.bg1 },
        },
    }

    gls.right[10] = {
        FileFormat = {
            provider = "FileFormat",
            highlight = { colors.blue, colors.bg1 },
            separator = " ",
            separator_highlight = { "NONE", colors.bg1 },
        },
    }

    gls.right[11] = {
        GitIcon = {
            provider = function()
                return " "
            end,
            condition = require("galaxyline.provider_vcs").check_git_workspace,
            highlight = { colors.magenta, colors.black, "bold" },
            separator = " " .. powerline.left,
            separator_highlight = { colors.black, colors.bg1 },
        },
    }

    gls.right[12] = {
        GitBranch = {
            provider = "GitBranch",
            condition = require("galaxyline.provider_vcs").check_git_workspace,
            separator = " ",
            separator_highlight = { "NONE", colors.black },
            highlight = { colors.magenta, colors.black },
        },
    }

    gls.right[13] = {
        DiffAdd = {
            separator = " ",
            separator_highlight = { "NONE", colors.black },
            provider = "DiffAdd",
            condition = checkwidth,
            icon = " ",
            highlight = { colors.green, colors.black },
        },
    }
    gls.right[14] = {
        DiffModified = {
            provider = "DiffModified",
            condition = checkwidth,
            icon = " ",
            highlight = { colors.orange, colors.black },
        },
    }
    gls.right[15] = {
        DiffRemove = {
            provider = "DiffRemove",
            condition = checkwidth,
            icon = " ",
            highlight = { colors.red, colors.black },
        },
    }

    gls.right[16] = {
        ViModeEnd = {
            provider = function()
                -- auto change color according the vim mode
                local mode_color = {
                    n = colors.cyan,
                    i = colors.green,
                    v = colors.magenta,
                    [""] = colors.blue,
                    c = colors.red,
                    no = colors.magenta,
                    s = colors.orange,
                    ic = colors.yellow,
                    R = colors.magenta,
                    Rv = colors.magenta,
                    cv = colors.red,
                    ce = colors.red,
                    r = colors.cyan,
                    rm = colors.cyan,
                    ["r?"] = colors.cyan,
                    ["!"] = colors.red,
                    t = colors.red,
                }
                vim.api.nvim_command("hi GalaxyViModeEnd guibg=" .. mode_color[vim.fn.mode()])
                return " "
            end,
            separator = "",
            separator_highlight = { "NONE", colors.black },
            highlight = { colors.red, colors.bg, "bold" },
        },
    }

    gls.short_line_left[1] = {
        SIcon = {
            provider = function()
                return " "
            end,
            highlight = { colors.fg1, colors.fg1 },
            separator = " ",
            separator_highlight = { colors.black, colors.black },
        },
    }

    gls.short_line_left[2] = {
        SFileIcon = {
            separator = "",
            separator_highlight = { colors.bg, colors.bg },
            provider = "FileIcon",
            condition = buffer_not_empty,
            highlight = {
                colors.fg1,
                colors.black,
            },
        },
    }

    gls.short_line_left[3] = {
        SFileName = {
            provider = { "FileName" },
            condition = buffer_not_empty,
            highlight = { colors.fg1, colors.black, "bold" },
        },
    }

    gls.short_line_left[4] = {
        PLRIcon = {
            provider = function()
                return " "
            end,
            highlight = { colors.black, colors.black, "bold" },
            separator = powerline.right,
            separator_highlight = { colors.black, colors.bg },
        },
    }

    gls.short_line_right[1] = {
        SRIcon = {
            provider = function()
                return ""
            end,
            highlight = { colors.bg, colors.bg, "bold" },
        },
    }
end
