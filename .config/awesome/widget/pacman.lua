local awful = require "awful"
local naughty = require "naughty"
local beautiful = require "beautiful"
local wibox = require "wibox"
local gears = require "gears"
local xresources = require "beautiful.xresources"
local helpers = require "helpers"

local function create_boxed_widget(widget_to_be_boxed, width, height, bg_color)
    local box_container = wibox.container.background()
    box_container.bg = bg_color
    box_container.forced_height = height
    box_container.forced_width = width
    box_container.shape = helpers.rrect(box_radius)
    -- box_container.shape = helpers.prrect(20, true, true, true, true)
    -- box_container.shape = helpers.prrect(30, true, true, false, true)

    local boxed_widget = wibox.widget {
        -- Add margins
        {
            -- Add background color
            {
                -- Center widget_to_be_boxed horizontally
                nil,
                {
                    -- Center widget_to_be_boxed vertically
                    nil,
                    -- The actual widget goes here
                    widget_to_be_boxed,
                    layout = wibox.layout.align.vertical,
                    expand = "none",
                },
                layout = wibox.layout.align.horizontal,
                expand = "none",
            },
            widget = box_container,
        },
        margins = box_gap,
        color = "#FF000000",
        widget = wibox.container.margin,
    }

    return boxed_widget
end

local go1 = require "widget.cpu_graph"
local go0 = wibox.widget {
    font = "JetBrainsMono Nerd Font 13",
    align = "right",
    markup = helpers.colorize_text(" ", "#B48EAD"),
    widget = wibox.widget.textbox,
}
local go2 = require "widget.github.github"
local go3 = require "widget.docker.docker"
local go4 = wibox.widget {
    font = "Material Design Icons  13",
    markup = helpers.colorize_text("󰮯", x.color3),
    widget = wibox.widget.textbox,
}

local ghost = wibox.widget {
    nil,
    {
        go4,
        {
            go0,
            go1,
            go2,
            go3,
            spacing = dpi(0),
            layout = wibox.layout.fixed.horizontal,
        },
        spacing = dpi(50),
        layout = wibox.layout.fixed.horizontal,
    },
    expand = "none",
    layout = wibox.layout.align.horizontal,
}
helpers.add_hover_cursor(go2, "hand1")
helpers.add_hover_cursor(go3, "hand1")
helpers.add_hover_cursor(go4, "hand1")
return ghost
