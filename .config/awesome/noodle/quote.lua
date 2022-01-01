local awful = require "awful"
local naughty = require "naughty"
local math = require "math"
local string = require "string"
local gears = require "gears"
local xresources = require "beautiful.xresources"
local helpers = require "helpers"
local wibox = require "wibox"
local beautiful = require "beautiful"
local apps = require "apps"

local helpers = require "helpers"
local quote1 = wibox.widget {
    text = "Stay focused,    ",
    font = "Cartograph CF Regular Italic 11",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox,
}
local quote2 = wibox.widget {
    text = "         Be present.",
    font = "Cartograph CF Regular Italic 11",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox,
}
local icon2 = wibox.widget {
    font = "Font Awesome 6 Pro Solid 11",
    align = "center",
    markup = helpers.colorize_text("", x.color2),
    widget = wibox.widget.textbox(),
}
local icon1 = wibox.widget {
    font = "Font Awesome 6 Pro Solid 11",
    align = "right",
    markup = helpers.colorize_text("", x.color2),
    widget = wibox.widget.textbox(),
}

local p1 = wibox.widget {
    nil,
    {
        icon1,
        quote1,
        spacing = dpi(8),
        layout = wibox.layout.fixed.horizontal,
    },
    expand = "none",
    layout = wibox.layout.align.horizontal,
}

local p2 = wibox.widget {
    nil,
    {
        quote2,
        icon2,
        spacing = dpi(5),
        layout = wibox.layout.fixed.horizontal,
    },
    expand = "none",
    layout = wibox.layout.align.horizontal,
}
local quote = wibox.widget {
    p1,
    p2,
    spacing = dpi(5),
    layout = wibox.layout.fixed.vertical,
}
return quote
