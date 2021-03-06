local gears = require "gears"
local awful = require "awful"
local wibox = require "wibox"
local beautiful = require "beautiful"
local helpers = require "helpers"
local keys = require "keys"
local decorations = require "components.decorations"

-- This decoration theme will round clients according to your theme's
-- border_radius value
-- Disable this if using `picom` to round your corners
-- decorations.enable_rounding()

-- Button configuration
local gen_button_size = dpi(12)
local gen_button_margin = dpi(5)
local gen_button_color_unfocused = x.color8
local gen_button_shape = gears.shape.circle

-- Add a titlebar
client.connect_signal("request::titlebars", function(c)
    awful.titlebar(c, {
        font = beautiful.titlebar_font,
        position = beautiful.titlebar_position,
        size = beautiful.titlebar_size,
    }):setup {
        {
            -- AwesomeWM native buttons (images loaded from theme)
            -- awful.titlebar.widget.minimizebutton(c),
            -- awful.titlebar.widget.maximizedbutton(c),
            -- awful.titlebar.widget.closebutton(c),

            -- Generated buttons
            helpers.horizontal_pad(dpi(10)),
            decorations.button(
                c,
                gen_button_shape,
                x.color1,
                gen_button_color_unfocused,
                x.color9,
                gen_button_size,
                gen_button_margin,
                "close"
            ),
            decorations.button(
                c,
                gen_button_shape,
                x.color2,
                gen_button_color_unfocused,
                x.color10,
                gen_button_size,
                gen_button_margin,
                "maximize"
            ),
            decorations.button(
                c,
                gen_button_shape,
                x.color3,
                gen_button_color_unfocused,
                x.color11,
                gen_button_size,
                gen_button_margin,
                "minimize"
            ),

            -- Create some extra padding at the edge
            helpers.horizontal_pad(gen_button_margin / 2),

            layout = wibox.layout.fixed.horizontal,
        },
        -- {
        --     {
        --         align = "center",
        --         font = "Cartograph CF Regular Italic",
        --         widget = awful.titlebar.widget.titlewidget(c),
        --     },
        --     layout = wibox.layout.flex.horizontal,
        -- },

        layout = wibox.layout.align.horizontal,
    }
end)
