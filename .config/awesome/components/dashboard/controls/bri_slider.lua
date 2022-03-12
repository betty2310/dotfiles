local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"
local helpers = require "helpers"

local slider = wibox.widget {
    bar_shape = require("helpers").rrect(9),
    bar_height = 6,
    bar_color = x.background,
    bar_active_color = x.color6,
    handle_shape = gears.shape.circle,
    handle_color = x.foreground,
    handle_width = 12,
    value = 100,
    widget = wibox.widget.slider,
}

helpers.add_hover_cursor(slider, "hand1")

local bri_slider = wibox.widget {
    {
        widget = wibox.widget.imagebox,
        image = gears.filesystem.get_configuration_dir() .. "icons/sun.svg",
        stylesheet = " * { stroke: " .. x.foreground .. " }",
        forced_width = 19,
        valign = "center",
        halign = "center",
    },
    slider,
    layout = wibox.layout.fixed.horizontal,
    spacing = 15,
}

slider:connect_signal("property::value", function(_, value)
    awful.spawn.with_shell("brightnessctl s " .. value .. "%")
end)

return bri_slider
