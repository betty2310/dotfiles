local awful = require "awful"
local beautiful = require "beautiful"
local gears = require "gears"
local wibox = require "wibox"
local helpers = require "helpers"
local app = require "apps"

local night_light = wibox.widget {
    {
        {
            widget = wibox.widget.textbox,
            markup = helpers.colorize_text("", x.background),
            font = "Font Awesome 6 Pro Solid 16",
            align = "center",
            valign = "center",
        },
        widget = wibox.container.margin,
        margins = 10,
    },
    widget = wibox.container.background,
    shape = helpers.rrect(dpi(6)),
    bg = "#8FBCBB",
}

helpers.add_hover_cursor(night_light, "hand1")

local on = x.color3
local off = "#8FBCBB"
local s = true
night_light:buttons {
    awful.button({}, 1, function()
        s = not s
        if s then
            night_light.bg = off
            awful.spawn.with_shell "nightmode"
        else
            night_light.bg = on
            awful.spawn.with_shell "nightmode"
        end
    end),
}

return night_light
