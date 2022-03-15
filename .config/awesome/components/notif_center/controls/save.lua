local awful = require "awful"
local beautiful = require "beautiful"
local gears = require "gears"
local wibox = require "wibox"
local apps = require "apps"
local helpers = require "helpers"
local naughty = require "naughty"
local icons = require "icons"

local wifi = wibox.widget {
    {
        {
            widget = wibox.widget.textbox,
            markup = helpers.colorize_text("", x.background),
            font = "Font Awesome 6 Pro Solid 14",
            align = "center",
            valign = "center",
        },
        widget = wibox.container.margin,
        margins = 10,
    },
    widget = wibox.container.background,
    shape = helpers.rrect(dpi(6)),
    bg = x.color11,
}

helpers.add_hover_cursor(wifi, "hand1")

wifi:buttons {
    awful.button({}, 1, function()
        apps.screenshot "full"
    end),
    awful.button({}, 3, function()
        naughty.notify {
            title = "Say cheese!",
            text = "Taking shot in 5 seconds",
            timeout = 4,
            icon = icons.image.screenshot,
        }
        apps.screenshot("full", 5)
    end),
}

return wifi
