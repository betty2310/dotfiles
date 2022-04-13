-- Standard awesome library
local gears = require "gears"
local awful = require "awful"
local icons = require "icons"

-- Theme handling library
local beautiful = require "beautiful"

-- Widget library
local wibox = require "wibox"

-- Helpers
local helpers = require "helpers"

-- Pop Up Notification
------------

local pop_icon = wibox.widget {
    {
        id = "icon",
        resize = true,
        widget = wibox.widget.imagebox,
    },
    forced_height = dpi(120),
    top = dpi(23),
    widget = wibox.container.margin,
}

local pop_bar = wibox.widget {
    max_value = 100,
    value = 0,
    background_color = x.color0,
    color = beautiful.bg_accent,
    shape = gears.shape.rounded_bar,
    bar_shape = gears.shape.rounded_bar,
    widget = wibox.widget.progressbar,
}

local pop = wibox {
    type = "dock",
    screen = screen.focused,
    height = beautiful.pop_size,
    width = beautiful.pop_size,
    shape = helpers.rrect(dpi(10)),
    bg = beautiful.transparent,
    ontop = true,
    visible = false,
}

pop:setup {
    {
        {
            {
                layout = wibox.layout.align.horizontal,
                expand = "none",
                nil,
                pop_icon,
                nil,
            },
            layout = wibox.layout.fixed.vertical,
        },
        {
            pop_bar,
            margins = dpi(24),
            widget = wibox.container.margin,
        },
        layout = wibox.layout.align.vertical,
    },
    bg = "#2b313c",
    shape = helpers.rrect(dpi(10)),
    widget = wibox.container.background,
}
awful.placement.bottom(pop, { margins = { bottom = dpi(100) } })

local pop_timeout = gears.timer {
    timeout = 2,
    autostart = true,
    callback = function()
        pop.visible = false
    end,
}

local function toggle_pop()
    if pop.visible then
        pop_timeout:again()
    else
        pop.visible = true
        pop_timeout:start()
    end
end

local vol_first_time = true
awesome.connect_signal("signal::volume", function(value, muted)
    local icon = beautiful.volume_icon

    if vol_first_time then
        vol_first_time = false
    else
        if muted then
            local muted_icon = beautiful.volume_muted_icon
            icon = muted_icon
            pop_bar.color = "#4c566a"
        else
            if value == 0 then
                icon = icons.image.muted
            end
            if value > 0 and value <= 30 then
                icon = icons.image.low
            end
            if value > 30 and value <= 65 then
                icon = icons.image.medium
            end
            if value > 65 and value <= 90 then
                icon = icons.image.high
            end
            if value > 90 then
                icon = icons.image.max
            end
            pop_bar.color = "#c1b494"
        end

        pop_bar.value = value
        pop_icon.icon.image = icon
        toggle_pop()
    end
end)

awesome.connect_signal("signal::brightness", function(value)
    local icon_ = beautiful.brightness_icon

    if value ~= 0 then
        local bri_icon = gears.color.recolor_image(icon_, x.color3)
        icon = bri_icon

        pop_bar.color = x.color3
    else
        icon = icon_
    end

    pop_bar.value = value
    pop_icon.icon.image = icon_
    toggle_pop()
end)

-- Layout list
-----------------

local layout_list = awful.widget.layoutlist {
    source = awful.widget.layoutlist.source.default_layouts, -- DOC_HIDE
    spacing = dpi(20),
    base_layout = wibox.widget {
        spacing = dpi(20),
        forced_num_cols = 4,
        layout = wibox.layout.grid.vertical,
    },
    widget_template = {
        {
            {
                id = "icon_role",
                forced_height = dpi(68),
                forced_width = dpi(68),
                widget = wibox.widget.imagebox,
            },
            margins = dpi(20),
            widget = wibox.container.margin,
        },
        id = "background_role",
        forced_width = dpi(68),
        forced_height = dpi(68),
        widget = wibox.container.background,
    },
}

local layout_popup = awful.popup {
    widget = wibox.widget {
        { layout_list, margins = dpi(20), widget = wibox.container.margin },
        bg = "#2b313c",
        shape = helpers.rrect(beautiful.border_radius),
        border_color = beautiful.widget_border_color,
        border_width = beautiful.widget_border_width,
        widget = wibox.container.background,
    },
    placement = awful.placement.centered,
    ontop = true,
    visible = false,
    bg = x.background,
}

function gears.table.iterate_value(t, value, step_size, filter, start_at)
    local k = gears.table.hasitem(t, value, true, start_at)
    if not k then
        return
    end

    step_size = step_size or 1
    local new_key = gears.math.cycle(#t, k + step_size)

    if filter and not filter(t[new_key]) then
        for i = 1, #t do
            local k2 = gears.math.cycle(#t, new_key + i)
            if filter(t[k2]) then
                return t[k2], k2
            end
        end
        return
    end

    return t[new_key], new_key
end

local window_switcher_grabber
function layout_popup_show(s)
    local keybinds = {
        ["Tab"] = function()
            awful.layout.set(gears.table.iterate_value(layout_list.layouts, layout_list.current_layout, 1), nil)
        end,
        ["n"] = function()
            awful.layout.set(gears.table.iterate_value(layout_list.layouts, layout_list.current_layout, 1), nil)
        end,
        ["N"] = function()
            awful.layout.set(gears.table.iterate_value(layout_list.layouts, layout_list.current_layout, -1), nil)
        end,
    }

    window_switcher_grabber = awful.keygrabber.run(function(_, key, event)
        if event == "release" then
            -- Hide if the modifier was released
            -- We try to match Super or Alt or Control since we do not know which keybind is
            -- used to activate the window switcher (the keybind is set by the user in keys.lua)
            if key:match "Super" or key:match "Esc" or key:match "Control" then
                layout_popup.visible = false
                awful.keygrabber.stop(window_switcher_grabber)
            end
            -- Do nothing
            return
        end
        layout_popup.visible = true
        -- Run function attached to key, if it exists
        if keybinds[key] then
            keybinds[key]()
        end
    end)
end
