local awful = require "awful"
local beautiful = require "beautiful"
local gears = require "gears"
local naughty = require "naughty"
local rubato = require "lib.rubato"
local helpers = require "helpers"
local wibox = require "wibox"
local icons = require "icons"
local apps = require "apps"
local keygrabber = require "awful.keygrabber"

local box_gap = dpi(6)

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

local command = "kanji"
local update_interval = 60
local kanji_text = wibox.widget {
    font = "sans 30",
    text = "loading your Kanji now ...",
    widget = wibox.widget.textbox,
}

local han_text = wibox.widget {
    font = "sans bold 13",
    text = "...",
    widget = wibox.widget.textbox,
}
local viet_text = wibox.widget {
    font = "sans 10",
    text = "...",
    widget = wibox.widget.textbox,
}
local update_kanji = function()
    awful.spawn.easy_async_with_shell(command, function(stdout)
        -- Remove trailing whitespaces
        -- kanji = out:gsub("^%s*(.-)%s*$", "%1")
        kanji = stdout:match "^KANJI@(.*)@HAN"
        han = stdout:match "@HAN@(.*)@VIET"
        viet = stdout:match "@VIET@(.*)@END"
        kanji_text.markup = helpers.colorize_text(kanji, x.color4)
        han_text.markup = helpers.colorize_text(han, x.color2)
        viet_text.markup = helpers.colorize_text(viet, x.foreground)
    end)
end

gears.timer {
    autostart = true,
    timeout = update_interval,
    single_shot = false,
    call_now = true,
    callback = update_kanji,
}

local kanji_widget = wibox.widget {
    {
        kanji_text,
        helpers.horizontal_pad(dpi(20)),
        {
            han_text,
            helpers.vertical_pad(dpi(10)),
            {
                step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
                speed = 50,
                viet_text,
                forced_width = 110,
                widget = wibox.container.scroll.horizontal,
            },
            layout = wibox.layout.align.vertical,
        },
        layout = wibox.layout.align.horizontal,
    },
    margins = box_gap * 4,
    color = "#00000000",
    widget = wibox.container.margin,
}

local kanji_box = create_boxed_widget(kanji_widget, dpi(230), dpi(100), "#313744")
kanji_box:buttons(gears.table.join(
    -- Left click - New fortune
    awful.button({}, 1, update_kanji)
))
helpers.add_hover_cursor(kanji_box, "hand1")
return kanji_box
