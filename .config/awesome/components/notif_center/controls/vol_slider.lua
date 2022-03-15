local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"
local helpers = require "helpers"

local slider = wibox.widget {
    bar_shape = require("helpers").rrect(9),
    bar_height = 6,
    bar_color = x.background,
    bar_active_color = x.color14,
    handle_shape = gears.shape.circle,
    handle_color = x.foreground,
    handle_width = 12,
    value = 99,
    widget = wibox.widget.slider,
}

helpers.add_hover_cursor(slider, "hand1")

local vol_slider = wibox.widget {
    {
        widget = wibox.widget.imagebox,
        image = gears.filesystem.get_configuration_dir() .. "icons/volume.svg",
        stylesheet = " * { stroke: " .. x.foreground .. " }",
        forced_width = 20,
        valign = "center",
        halign = "center",
    },
    slider,
    layout = wibox.layout.fixed.horizontal,
    spacing = 15,
}

slider:connect_signal("property::value", function(_, value)
    awful.spawn.with_shell("amixer sset Master " .. value .. "%")
end)

return vol_slider
