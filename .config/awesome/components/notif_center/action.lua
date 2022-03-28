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
-- Uptime
local uptime_text = wibox.widget.textbox()
awful.widget.watch("sh -c 'uptime -p | sed 's/^...//''", 60, function(_, stdout)
    -- Remove trailing whitespaces
    local out = stdout:gsub("^%s*(.-)%s*$", "%1")
    uptime_text.text = out
end)
local uptime = wibox.widget {
    {
        align = "center",
        valign = "center",
        font = "Material Design Icons  16",
        markup = helpers.colorize_text("󰮯", x.color3),
        widget = wibox.widget.textbox(),
    },
    {
        align = "center",
        valign = "center",
        font = "CartographCF Medium Italic 10",
        widget = uptime_text,
    },
    spacing = dpi(10),
    layout = wibox.layout.fixed.horizontal,
}

local uptime_box = create_boxed_widget(uptime, dpi(200), dpi(20), x.background)

uptime_box:buttons(gears.table.join(awful.button({}, 1, function()
    exit_screen_show()
    gears.timer.delayed_call(function()
        dashboard_hide()
    end)
end)))
helpers.add_hover_cursor(uptime_box, "hand1")

local notification_state = wibox.widget {
    align = "center",
    valign = "center",
    font = "icomoon 20",
    widget = wibox.widget.textbox "",
}
local function update_notification_state_icon()
    if naughty.suspended then
        notification_state.markup = helpers.colorize_text(notification_state.text, x.color8)
    else
        notification_state.markup = helpers.colorize_text(notification_state.text, x.color3)
    end
end
update_notification_state_icon()
local notification_state_box = create_boxed_widget(notification_state, dpi(65), dpi(50), x.background)
notification_state_box:buttons(gears.table.join(
    -- Left click - Toggle notification state
    awful.button({}, 1, function()
        naughty.suspended = not naughty.suspended
        update_notification_state_icon()
    end)
))

helpers.add_hover_cursor(notification_state_box, "hand1")

local nightlight = wibox.widget {
    align = "center",
    valign = "center",
    font = "Font Awesome 6 Pro Solid 18",
    markup = helpers.colorize_text("", x.color4),
    widget = wibox.widget.textbox(),
}

local nightlight_box = create_boxed_widget(nightlight, dpi(65), dpi(50), x.background)
nightlight_box:buttons(gears.table.join(awful.button({}, 1, function()
    apps.night_mode()
end)))

helpers.add_hover_cursor(nightlight_box, "hand1")
local screenshot = wibox.widget {
    align = "center",
    valign = "center",
    font = "icomoon 20",
    markup = helpers.colorize_text("", x.color2),
    widget = wibox.widget.textbox(),
}
local screenshot_box = create_boxed_widget(screenshot, dpi(65), dpi(50), x.background)
screenshot_box:buttons(gears.table.join(
    -- Left click - Take screenshot
    awful.button({}, 1, function()
        apps.screenshot "full"
    end),
    -- Right click - Take screenshot in 5 seconds
    awful.button({}, 3, function()
        naughty.notify {
            title = "Say cheese!",
            text = "Taking shot in 5 seconds",
            timeout = 4,
            icon = icons.image.screenshot,
        }
        apps.screenshot("full", 5)
    end)
))

helpers.add_hover_cursor(screenshot_box, "hand1")
local screenrec = wibox.widget {
    align = "center",
    valign = "center",
    font = "Font Awesome 6 Pro Solid 18",
    markup = helpers.colorize_text("", x.color5),
    widget = wibox.widget.textbox(),
}
local screenrec_box = create_boxed_widget(screenrec, dpi(65), dpi(50), x.background)
screenrec_box:buttons(gears.table.join(
    -- Left click - Take screenshot
    awful.button({}, 1, function()
        apps.record()
    end),
    -- Right click - Take screenshot in 5 seconds
    awful.button({}, 3, function()
        naughty.notify {
            title = "Open Screen apps!",
            text = "What r u doing?",
            timeout = 1,
            icon = icons.image.screenshot,
        }
        awful.spawn.with_shell "simplescreenrecorder"
    end)
))
helpers.add_hover_cursor(screenrec_box, "hand1")

F.action = {}

local notifs = require "components.notif_center.notif"

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
                    {
                        notification_state_box,
                        screenshot_box,
                        screenrec_box,
                        nightlight_box,
                        layout = wibox.layout.flex.vertical,
                    },
                    calendar_box,
                    layout = wibox.layout.align.horizontal,
                },
                layout = wibox.layout.fixed.vertical,
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

F.action.toggle = function()
    if action.visible then
        action_hide()
    else
        action_show()
    end
end
