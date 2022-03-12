local awful = require "awful"
local beautiful = require "beautiful"
local gears = require "gears"
local wibox = require "wibox"
local helpers = require "helpers"

local wifi = wibox.widget {
    {
        {
            widget = wibox.widget.textbox,
            markup = helpers.colorize_text("", x.background),
            font = "Font Awesome 6 Pro Solid 14",
            align = "center",
            valign = "center",
        },
        widget = wibox.container.margin,
        margins = 10,
    },
    widget = wibox.container.background,
    shape = helpers.rrect(dpi(6)),
    bg = x.color2,
}

helpers.add_hover_cursor(wifi, "hand1")

wifi:buttons {
    awful.button({}, 1, function()
        awful.spawn.with_shell "copyq show"
    end),
}

return wifi
