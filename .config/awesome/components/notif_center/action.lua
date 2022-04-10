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

local disk_arc = wibox.widget {
    start_angle = 3 * math.pi / 2,
    min_value = 0,
    max_value = 100,
    value = 50,
    border_width = 0,
    thickness = dpi(8),
    forced_width = dpi(90),
    forced_height = dpi(90),
    rounded_edge = true,
    bg = x.color8 .. "55",
    colors = { "#5E81AC" },
    widget = wibox.container.arcchart,
}

local disk_hover_text_value = wibox.widget {
    align = "center",
    valign = "center",
    font = "sans medium 10",
    widget = wibox.widget.textbox(),
}
local disk_hover_text = wibox.widget {
    disk_hover_text_value,
    {
        align = "center",
        valign = "center",
        font = "sans medium 10",
        widget = wibox.widget.textbox "free",
    },
    spacing = dpi(2),
    visible = false,
    layout = wibox.layout.fixed.vertical,
}

awesome.connect_signal("signal::disk", function(used, total)
    disk_arc.value = used * 100 / total
    disk_hover_text_value.markup = helpers.colorize_text(tostring(helpers.round(total - used, 1)) .. "G", x.color4)
end)

local disk_icon = wibox.widget {
    align = "center",
    valign = "center",
    font = "icomoon 22",
    markup = helpers.colorize_text("", x.color3),
    widget = wibox.widget.textbox(),
}

local disk = wibox.widget {
    {
        nil,
        disk_hover_text,
        expand = "none",
        layout = wibox.layout.align.vertical,
    },
    disk_icon,
    disk_arc,
    top_only = false,
    layout = wibox.layout.stack,
}

local disk_box = create_boxed_widget(disk, dpi(50), dpi(100), x.background)

disk_box:connect_signal("mouse::enter", function()
    disk_icon.visible = false
    disk_hover_text.visible = true
end)
disk_box:connect_signal("mouse::leave", function()
    disk_icon.visible = true
    disk_hover_text.visible = false
end)

-- Calendar
local calendar = require "widget.calendar"
-- Update calendar whenever dashboard is shown
dashboard:connect_signal("property::visible", function()
    if dashboard.visible then
        calendar.date = os.date "*t"
    end
end)

local calendar_box = create_boxed_widget(calendar, dpi(150), dpi(250), "#313744")

local kanji_box = require "widget.kanji"

F.action = {}

local notifs = require "components.notif_center.notif"

local function create_buttons(icon, color)
    local button = wibox.widget {
        id = "icon",
        markup = helpers.colorize_text(icon, color),
        font = beautiful.icon_font_name .. "Round 15",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox,
    }

    local button_container = wibox.widget {
        {
            {
                button,
                margins = dpi(5),
                forced_height = dpi(55),
                forced_width = dpi(55),
                widget = wibox.container.margin,
            },
            widget = require "widget.click",
        },
        bg = x.color0,
        shape = gears.shape.circle,
        widget = wibox.container.background,
    }

    return button_container
end
-- user profile
local format_item = function(widget)
    return wibox.widget {
        {
            {
                layout = wibox.layout.align.vertical,
                expand = "none",
                nil,
                widget,
                nil,
            },
            margins = dpi(8),
            widget = wibox.container.margin,
        },
        forced_height = dpi(80),
        forced_width = dpi(100),
        bg = x.background,
        shape = helpers.rrect(dpi(8)),
        widget = wibox.container.background,
    }
end
local user_profile = wibox.widget {
    format_item(require "widget.user"()),
    direction = "west",
    widget = wibox.container.rotate,
}
local end_sec = wibox.widget {
    align = "center",
    valign = "center",
    font = beautiful.icon_font_name .. 18,
    markup = helpers.colorize_text("", x.color1),
    widget = wibox.widget.textbox(),
}

local end_button = create_boxed_widget(end_sec, dpi(40), dpi(50), "#313744")

helpers.add_hover_cursor(end_button, "hand1")
local action = awful.popup {
    widget = {
        widget = wibox.container.margin,
        margins = 30,
        forced_width = 500,
        {
            notifs,
            {
                kanji_box,
                disk_box,
                layout = wibox.layout.align.horizontal,
            },
            {
                {
                    nil,
                    user_profile,
                    end_button,
                    layout = wibox.layout.align.vertical,
                },
                calendar_box,
                nil,
                layout = wibox.layout.align.horizontal,
            },
            layout = wibox.layout.fixed.vertical,
        },
    },
    ontop = true,
    visible = false,
    bg = x.background,
    border_color = x.foreground,
    border_width = 0,
}

awful.placement.top_right(action)
awful.placement.maximize_vertically(
    action,
    { honor_workarea = true, margins = { top = beautiful.useless_gap * 2, bottom = beautiful.useless_gap * 0 } }
)

local slide = rubato.timed {
    pos = 1920,
    rate = 60,
    intro = 0.2,
    duration = 0.5,
    easing = rubato.quadratic,
    awestore_compat = true,
    subscribed = function(pos)
        action.x = pos
    end,
}

local action_status = false

slide.ended:subscribe(function()
    if action_status then
        action.visible = false
    end
end)

local function action_show()
    action.visible = true
    slide:set(1420)
    action_status = false
end

local function action_hide()
    slide:set(1920)
    action_status = true
end

end_button:buttons(gears.table.join(awful.button({}, 1, nil, function()
    action_hide()
    exit_screen_show()
end)))

F.action.toggle = function()
    if action.visible then
        action_hide()
    else
        action_show()
    end
end
action:buttons(gears.table.join(awful.button({}, 3, nil, function()
    action_hide()
end)))
