require("scrollbar").setup {
    show = true,
    handle = {
        text = " ",
        color = "#3B4252",
        hide_if_all_visible = true, -- Hides handle if all lines are visible
    },
    marks = {
        Search = { text = { "-", "=" }, priority = 0, color = "#D08770" },
        Error = { text = { "-", "=" }, priority = 1, color = "#BF616A" },
        Warn = { text = { "-", "=" }, priority = 2, color = "#EBCB8B" },
        Info = { text = { "-", "=" }, priority = 3, color = "#81A1C1" },
        Hint = { text = { "-", "=" }, priority = 4, color = "#B48EAD" },
        Misc = { text = { "-", "=" }, priority = 5, color = "#B48EAD" },
    },
    excluded_filetypes = {
        "",
        "prompt",
        "TelescopePrompt",
    },
    autocmd = {
        render = {
            "BufWinEnter",
            "TabEnter",
            "TermEnter",
            "WinEnter",
            "CmdwinLeave",
            "TextChanged",
            "VimResized",
            "WinScrolled",
        },
    },
    handlers = {
        diagnostic = true,
        search = true,
    },
}
