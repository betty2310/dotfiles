local awful = require "awful"
local beautiful = require "beautiful"
local gears = require "gears"
local wibox = require "wibox"
local helpers = require "helpers"
local apps = require "apps"
local icons = require "icons"
local naughty = require "naughty"

local wifi = wibox.widget {
    {
        {
            widget = wibox.widget.textbox,
            markup = helpers.colorize_text("", x.background),
            font = "Font Awesome 6 Pro Solid 15",
            align = "center",
            valign = "center",
        },
        widget = wibox.container.margin,
        margins = 10,
    },
    widget = wibox.container.background,
    shape = helpers.rrect(dpi(6)),
    bg = x.color13,
}

helpers.add_hover_cursor(wifi, "hand1")

wifi:buttons {
    awful.button({}, 1, function()
        apps.screenshot "clipboard"
    end),
}

return wifi
