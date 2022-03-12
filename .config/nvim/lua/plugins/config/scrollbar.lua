require("scrollbar").setup {
    show = true,
    handle = {
        text = " ",
        color = "#3B4252",
        hide_if_all_visible = true, -- Hides handle if all lines are visible
    },
    handlers = {
        diagnostic = false,
        search = false,
    },
}
