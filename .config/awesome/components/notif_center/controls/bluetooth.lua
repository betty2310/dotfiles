local awful = require "awful"
local beautiful = require "beautiful"
local gears = require "gears"
local wibox = require "wibox"
local helpers = require "helpers"

local bluetooth = wibox.widget {
    {
        {
            widget = wibox.widget.textbox,
            markup = helpers.colorize_text("", x.background),
            font = "Font Awesome 6 Pro Solid 13",
            align = "center",
            valign = "center",
        },
        widget = wibox.container.margin,
        margins = 10,
    },
    widget = wibox.container.background,
    shape = helpers.rrect(dpi(6)),
    bg = "#81A1C1",
}

helpers.add_hover_cursor(bluetooth, "hand1")

-- thanks to nes
local on = "#81A1C1"
local off = "#313744"
local s = true
bluetooth:buttons {
    awful.button({}, 1, function()
        awful.spawn.with_shell "blueman-manager"
    end),
}

return bluetooth
