local awful = require "awful"
local beautiful = require "beautiful"
local gears = require "gears"
local wibox = require "wibox"
local helpers = require "helpers"

local wifi = wibox.widget {
    {
        {
            widget = wibox.widget.textbox,
            markup = helpers.colorize_text("", x.background),
            font = "Font Awesome 6 Pro Solid 14",
            align = "center",
            valign = "center",
        },
        widget = wibox.container.margin,
        margins = 10,
    },
    widget = wibox.container.background,
    shape = helpers.rrect(dpi(6)),
    bg = "#5E81AC",
}

helpers.add_hover_cursor(wifi, "hand1")

local on = "#5E81AC"
local off = "#313744"
local s = false -- off
wifi:buttons {
    awful.button({}, 1, function()
        s = not s
        if s then
            wifi.bg = off
            wifi.markup = helpers.colorize_text("", x.foreground)
            awful.spawn "nmcli radio wifi off"
        else
            wifi.bg = on
            wifi.markup = helpers.colorize_text("", x.background)
            awful.spawn "nmcli radio wifi on"
        end
    end),
}

return wifi
