local awful = require "awful"
local beautiful = require "beautiful"
local gears = require "gears"
local naughty = require "naughty"
local wibox = require "wibox"
local helpers = require "helpers"

local dnd = wibox.widget {
    {
        {
            widget = wibox.widget.textbox,
            markup = helpers.colorize_text("", x.background),
            font = "Font Awesome 6 Pro Solid 14",
            align = "center",
            valign = "center",
        },
        widget = wibox.container.margin,
        margins = 10,
    },
    widget = wibox.container.background,
    shape = helpers.rrect(dpi(6)),
    bg = "#88C0D0",
}

helpers.add_hover_cursor(dnd, "hand1")

local on = x.color3
local off = "#313744"
local s = true
dnd:buttons {
    awful.button({}, 1, function()
        s = not s
        if s then
            dnd.bg = off
            naughty.resume()
        else
            dnd.bg = on
            naughty.suspend()
        end
    end),
}

return dnd
