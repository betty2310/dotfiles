local _M = {}

local scopes = { o = vim.o, b = vim.bo, w = vim.wo }

function _M.opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= "o" then
        scopes["o"][key] = value
    end
end

function _M.map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

_M.colors = {
    bg = "#2e3440",
    extra = "2D333E",
    bg1 = "#3b4252",
    bg2 = "#262b36",
    bg3 = "#4c566a",
    test = "#262b33",
    fg = "#e5e9f0",
    fg1 = "#707788",
    red = "#bf616a",
    white = "#a5abb8",
    black = "#222733",
    orange = "#d08770",
    yellow = "#ebcb8b",
    blue = "#5e81ac",
    green = "#a3be8c",
    cyan = "#88c0d0",
    magenta = "#b48ead",
    pink = "#FFA19F",
    blue_light = "#81A1C1",
    cyan_light = "#8FBCBB",
}

_M.signs = { Error = "", Warn = "", Hint = "", Info = "" }

_M.powerline = {
    circle = {
        left = "",
        right = "",
    },
    arrow = {
        left = "",
        right = "",
    },
    triangle = {
        left = "",
        right = "",
    },
}
function _M.setSpacesSize(filetypes)
    for filetype, size in pairs(filetypes) do
        vim.cmd(string.format("autocmd FileType %s set sw=%s", filetype, size))
        vim.cmd(string.format("autocmd FileType %s set ts=%s", filetype, size))
        vim.cmd(string.format("autocmd FileType %s set sts=%s", filetype, size))
    end
end
return _M
