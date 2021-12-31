local awful = require "awful"
local naughty = require "naughty"
local beautiful = require "beautiful"
local wibox = require "wibox"
local gears = require "gears"
local xresources = require "beautiful.xresources"
local helpers = require "helpers"
local stroke = x.color2
local bg = "#333946"

local bar_shape = function()
    return function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, 9)
    end
end
local battery_bar = wibox.widget {
    max_value = 50,
    value = 50,
    forced_height = dpi(50),
    forced_width = 30,
    bar_shape = gears.shape.rectangle,
    color = bg,
    background_color = bg,
    widget = wibox.widget.progressbar,
}
local go1 = wibox.widget {
    font = "Liga SFMono Nerd Font 13",
    align = "right",
    markup = helpers.colorize_text(" ", x.color1),
    widget = wibox.widget.textbox(),
}
local go2 = wibox.widget {
    font = "Liga SFMono Nerd Font 13",
    align = "right",
    markup = helpers.colorize_text(" ", x.color2),
    widget = wibox.widget.textbox(),
}
local go3 = wibox.widget {
    font = "Liga SFMono Nerd Font 13",
    align = "right",
    markup = helpers.colorize_text(" ", x.color4),
    widget = wibox.widget.textbox(),
}
local go4 = wibox.widget {
    font = "Material Design Icons  13",
    align = "center",
    markup = helpers.colorize_text("󰮯 ", x.color3),
    widget = wibox.widget.textbox(),
}

local pomodoro = wibox.widget {
    {
        battery_bar,
        shape = helpers.rrect(dpi(16)),
        border_color = bg,
        border_width = dpi(2),
        forced_height = 60,
        forced_width = 30,
        widget = wibox.container.background,
    },

    {
        go1,
        right = dpi(150),
        widget = wibox.container.margin(),
    },
    {
        go2,
        right = dpi(130),
        widget = wibox.container.margin(),
    },
    {
        go3,
        right = dpi(110),
        widget = wibox.container.margin(),
    },
    {
        go4,
        right = dpi(70),
        widget = wibox.container.margin(),
    },

    top_only = false,
    layout = wibox.layout.stack,
}
return pomodoro
