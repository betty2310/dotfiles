vim.g.dashboard_disable_at_vimenter = 0
vim.g.dashboard_disable_statusline = 0
vim.g.dashboard_default_executive = "telescope"

vim.g.dashboard_custom_header = {
    "                                                       ",
    "                                                       ",
    "                                                       ",
    "                                                       ",
    " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
    " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
    " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
    " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
    " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
    " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
    "                                                       ",
    "                                                       ",
    "                                                       ",
    "                                                       ",
}

vim.g.dashboard_custom_section = {
    a = { description = { "  Find File                 הּ f f" }, command = "Telescope find_files" },
    b = { description = { "  Recents                   הּ f o" }, command = "Telescope oldfiles" },
    c = { description = { "  Find Word                 הּ f g" }, command = "Telescope live_grep" },
    d = { description = { "洛 New File                  הּ f n" }, command = "DashboardNewFile" },
}
vim.g.dashboard_custom_footer = {
    "Dev as Life!!",
    "      ~Betty",
}
