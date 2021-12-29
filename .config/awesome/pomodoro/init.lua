-- Author: François de Metz

local awful = require "awful"
local naughty = require "naughty"
local beautiful = require "beautiful"
local wibox = require "wibox"
local gears = require "gears"
local xresources = require "beautiful.xresources"
local helpers = require "helpers"
local stroke = x.background
-- local stroke = "#000000"
local transparent = "#00000000"
local happy_color = x.color2
local sad_color = x.color1
local ok_color = x.color3
local charging_color = x.color6
-- 25 min
local pomodoro_time = 60 * 25

local pomodoro_image_path = beautiful.pomodoro_icon or awful.util.getdir "config" .. "/pomodoro/pomo.png"

-- setup widget
-- local pomodoro = wibox.widget {
--     image = pomodoro_image_path,
--     forced_height = 20,
--     forced_width = 10,
--     widget = wibox.widget.imagebox,
-- }
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
    color = x.color2,
    background_color = x.color2,
    widget = wibox.widget.progressbar,
}
local charging_icon = wibox.widget {
    font = "icomoon 13",
    align = "right",
    markup = helpers.colorize_text("", stroke .. "90"),
    widget = wibox.widget.textbox(),
}

local eye_size = dpi(5)
local mouth_size = dpi(10)

local mouth_shape = function()
    return function(cr, width, height)
        gears.shape.pie(cr, width, height, 0, math.pi)
    end
end

local mouth_widget = wibox.widget {
    forced_width = mouth_size,
    forced_height = mouth_size,
    shape = mouth_shape(),
    -- shape = gears.shape.pie,
    bg = stroke,
    widget = wibox.container.background(),
}

local frown = wibox.widget {
    {
        mouth_widget,
        direction = "north",
        widget = wibox.container.rotate(),
    },
    top = dpi(8),
    widget = wibox.container.margin(),
}

local smile = wibox.widget {
    mouth_widget,
    direction = "west",
    widget = wibox.container.rotate(),
}

local ok = wibox.widget {
    {
        bg = stroke,
        shape = helpers.rrect(dpi(2)),
        widget = wibox.container.background,
    },
    top = dpi(5),
    bottom = dpi(1),
    widget = wibox.container.margin(),
}

local mouth = wibox.widget {
    frown,
    ok,
    smile,
    top_only = true,
    widget = wibox.layout.stack(),
}

local eye = wibox.widget {
    forced_width = eye_size,
    forced_height = eye_size,
    shape = gears.shape.circle,
    bg = stroke,
    widget = wibox.container.background(),
}

-- 2 eyes 1 semicircle (smile or frown)
local face = wibox.widget {
    eye,
    mouth,
    eye,
    spacing = dpi(4),
    layout = wibox.layout.fixed.horizontal,
}

local pomodoro = wibox.widget {
    {
        battery_bar,
        shape = helpers.rrect(dpi(16)),
        border_color = stroke,
        border_width = dpi(2),
        forced_height = 60,
        forced_width = 30,
        widget = wibox.container.background,
    },
    -- {
    --     charging_icon,
    --     right = dpi(101),
    --     widget = wibox.container.margin(),
    -- },
    --
    {
        nil,
        {
            nil,
            face,
            layout = wibox.layout.align.vertical,
            expand = "none",
        },
        layout = wibox.layout.align.horizontal,
        expand = "none",
    },
    {
        charging_icon,
        right = dpi(15),
        widget = wibox.container.margin(),
    },

    top_only = false,
    layout = wibox.layout.stack,
}
-- setup timers
local pomodoro_timer = gears.timer { timeout = pomodoro_time }
local pomodoro_tooltip_timer = gears.timer { timeout = 1 }
local pomodoro_nbsec = 0

local function pomodoro_start()
    pomodoro_timer:start()
    pomodoro_tooltip_timer:start()
    pomodoro.bg = beautiful.bg_normal
end

local function pomodoro_stop()
    pomodoro_timer:stop(pomodoro_timer)
    pomodoro_tooltip_timer:stop(pomodoro_tooltip_timer)
    pomodoro_nbsec = 0
end

local function pomodoro_end()
    pomodoro_stop()
    pomodoro.bg = beautiful.bg_urgent
end

local function pomodoro_notify(text)
    naughty.notify {
        title = "Pomodoro",
        text = text,
        timeout = 10,
        icon = pomodoro_image_path,
        icon_size = 64,
        width = 200,
    }
end

pomodoro_timer:connect_signal("timeout", function(c)
    pomodoro_end()
    pomodoro_notify "Ended"
end)

pomodoro_tooltip_timer:connect_signal("timeout", function(c)
    pomodoro_nbsec = pomodoro_nbsec + 1
end)

pomodoro_tooltip = awful.tooltip {
    objects = { pomodoro },
    timer_function = function()
        if pomodoro_timer.started then
            r = (pomodoro_time - pomodoro_nbsec) % 60
            return "End in " .. math.floor((pomodoro_time - pomodoro_nbsec) / 60) .. " min " .. r
        else
            return "pomodoro not started"
        end
    end,
}

local function pomodoro_start_timer()
    if not pomodoro_timer.started then
        pomodoro_start()
        pomodoro_notify "Started"
    else
        pomodoro_stop()
        pomodoro_notify "Canceled"
    end
end

pomodoro:buttons(awful.util.table.join(awful.button({}, 1, pomodoro_start_timer)))

return pomodoro
