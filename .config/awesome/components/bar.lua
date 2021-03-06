local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"
local bling = require "lib.bling"
local rubato = require "lib.rubato"

local helpers = require "helpers"
local keys = require "keys"

local dock_autohide_delay = 0.5 -- seconds

local dock = require "widget.dock"
local dock_placement = function(w)
    return awful.placement.bottom(w)
end

-- Battery
-------------

local charge_icon = wibox.widget {
    bg = x.color8,
    widget = wibox.container.background,
    visible = false,
}

local batt = wibox.widget {
    charge_icon,
    max_value = 100,
    value = 50,
    thickness = dpi(2),
    padding = dpi(1),
    start_angle = math.pi * 3 / 2,
    color = { x.color2 },
    bg = x.color2 .. "55",
    widget = wibox.container.arcchart,
}

local batt_last_value = 100
local batt_low_value = 40
local batt_critical_value = 20
awesome.connect_signal("signal::battery", function(value)
    batt.value = value
    batt_last_value = value
    local color

    if charge_icon.visible then
        color = x.color6
    elseif value <= batt_critical_value then
        color = x.color1
    elseif value <= batt_low_value then
        color = x.color3
    else
        color = x.color2
    end

    batt.colors = { color }
    batt.bg = color .. "44"
end)

local wrap_widget = function(widget)
    return {
        widget,
        margins = dpi(6),
        widget = wibox.container.margin,
    }
end

awesome.connect_signal("signal::charger", function(state)
    local color
    if state then
        charge_icon.visible = true
        color = x.color6
    elseif batt_last_value <= batt_critical_value then
        charge_icon.visible = false
        color = x.color1
    elseif batt_last_value <= batt_low_value then
        charge_icon.visible = false
        color = x.color3
    else
        charge_icon.visible = false
        color = x.color2
    end

    batt.colors = { color }
    batt.bg = color .. "44"
end)

local hour = wibox.widget {
    font = "Iosevka Medium 12",
    format = "%H",
    align = "center",
    valign = "center",
    widget = wibox.widget.textclock,
}

local min = wibox.widget {
    font = "Iosevka Medium 11",
    format = "%M",
    align = "center",
    valign = "center",
    widget = wibox.widget.textclock,
}

local space = wibox.widget {
    font = "Iosevka Medium 11",
    format = ":",
    align = "center",
    valign = "center",
    widget = wibox.widget.textclock,
}
local clock = wibox.widget {
    {
        {
            hour,
            space,
            min,
            spacing = dpi(2),
            layout = wibox.layout.fixed.horizontal,
        },
        top = dpi(5),
        bottom = dpi(5),
        left = dpi(5),
        right = dpi(5),
        widget = wibox.container.margin,
    },
    bg = x.color0,
    shape = helpers.rrect(dpi(8)),
    widget = wibox.container.background,
}

local stats = wibox.widget {
    {
        clock,
        wrap_widget(batt),
        spacing = dpi(5),
        layout = wibox.layout.fixed.horizontal,
    },
    bg = "#434C5E",
    shape = helpers.rrect(dpi(8)),
    widget = wibox.container.background,
}
local tag_colors_empty = {
    "#00000000",
    "#00000000",
    "#00000000",
    "#00000000",
    "#00000000",
    "#00000000",
    "#00000000",
}

local tag_colors_urgent = {
    "#00000000",
    "#00000000",
    "#00000000",
    "#00000000",
    "#00000000",
    "#00000000",
    "#00000000",
}

local tag_colors_focused = {
    x.color1,
    x.color5,
    x.color4,
    x.color6,
    x.color2,
    x.color3,
    x.color1,
}

local tag_colors_occupied = {
    x.color1 .. "45",
    x.color5 .. "45",
    x.color4 .. "45",
    x.color6 .. "45",
    x.color2 .. "45",
    x.color3 .. "45",
    x.color1 .. "45",
}

local update_taglist = function(item, tag, index)
    if tag.selected then
        item.bg = beautiful.taglist_text_color_focused[index]
    elseif tag.urgent then
        item.bg = beautiful.taglist_text_color_urgent[index]
    elseif #tag:clients() > 0 then
        item.bg = beautiful.taglist_text_color_occupied[index]
    else
        item.bg = beautiful.taglist_text_color_empty[index]
    end
end

local ll = awful.widget.layoutlist {
    base_layout = wibox.widget {
        spacing = 5,
        forced_num_cols = 2,
        layout = wibox.layout.grid.vertical,
    },
    widget_template = {
        {
            {
                id = "icon_role",
                forced_height = 30,
                forced_width = 30,
                widget = wibox.widget.imagebox,
            },
            margins = 6,
            widget = wibox.container.margin,
        },
        id = "background_role",
        forced_width = 40,
        forced_height = 40,
        shape = helpers.rrect(beautiful.border_radius_tray),
        widget = wibox.container.background,
    },
}
helpers.add_hover_cursor(ll, "hand1")

awful.screen.connect_for_each_screen(function(s)
    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = keys.taglist_buttons,
        layout = {
            spacing = 10,
            spacing_widget = {
                color = "#00000000",
                shape = gears.shape.circle,
                widget = wibox.widget.separator,
            },
            layout = wibox.layout.flex.horizontal,
        },
        widget_template = {
            widget = wibox.container.background,
            create_callback = function(self, tag, index, _)
                update_taglist(self, tag, index)
            end,
            update_callback = function(self, tag, index, _)
                update_taglist(self, tag, index)
            end,
        },
    }

    -- Create the taglist wibox
    s.taglist_box = awful.wibar {
        screen = s,
        visible = true,
        ontop = false,
        type = "dock",
        position = "top",
        height = dpi(7),
        -- position = "left",
        -- width = dpi(6),
        bg = "#00000000",
    }
    s.taglist_box:setup {
        widget = s.mytaglist,
    }
    -- Create the dock wibox
    s.dock = awful.popup {
        -- Size is dynamic, no need to set it here
        visible = false,
        bg = "#00000000",
        ontop = true,
        type = "dock",
        placement = dock_placement,
        widget = dock,
    }
    dock_placement(s.dock)

    local popup_timer
    local autohide = function()
        if popup_timer then
            popup_timer:stop()
            popup_timer = nil
        end
        popup_timer = gears.timer.start_new(dock_autohide_delay, function()
            popup_timer = nil
            s.dock.visible = false
        end)
    end

    -- Initialize wibox activator
    s.dock_activator = wibox { screen = s, height = 1, bg = "#00000000", visible = true, ontop = true }
    awful.placement.bottom(s.dock_activator)
    s.dock_activator:connect_signal("mouse::enter", function()
        s.dock.visible = true
        if popup_timer then
            popup_timer:stop()
            popup_timer = nil
        end
    end)

    -- We have set the dock_activator to be ontop, but we do not want it to be
    -- above fullscreen clients
    local function no_dock_activator_ontop(c)
        if c.fullscreen then
            s.dock_activator.ontop = false
        else
            s.dock_activator.ontop = true
        end
    end
    client.connect_signal("focus", no_dock_activator_ontop)
    client.connect_signal("unfocus", no_dock_activator_ontop)
    client.connect_signal("property::fullscreen", no_dock_activator_ontop)

    s:connect_signal("removed", function(s)
        client.disconnect_signal("focus", no_dock_activator_ontop)
        client.disconnect_signal("unfocus", no_dock_activator_ontop)
        client.disconnect_signal("property::fullscreen", no_dock_activator_ontop)
    end)

    s.dock_activator:buttons(gears.table.join(
        awful.button({}, 4, function()
            awful.tag.viewprev()
        end),
        awful.button({}, 5, function()
            awful.tag.viewnext()
        end)
    ))

    local function adjust_dock()
        -- Reset position every time the number of dock items changes
        dock_placement(s.dock)

        -- Adjust activator width every time the dock wibox width changes
        s.dock_activator.width = s.dock.width + dpi(250)
        -- And recenter
        awful.placement.bottom(s.dock_activator)
    end

    adjust_dock()
    s.dock:connect_signal("property::width", adjust_dock)

    s.dock:connect_signal("mouse::enter", function()
        if popup_timer then
            popup_timer:stop()
            popup_timer = nil
        end
    end)

    s.dock:connect_signal("mouse::leave", function()
        autohide()
    end)
    s.dock_activator:connect_signal("mouse::leave", function()
        autohide()
    end)

    local layoutbox_buttons = gears.table.join(
        -- Left click
        awful.button({}, 1, function(c)
            awful.layout.inc(1)
        end),

        -- Right click
        awful.button({}, 3, function(c)
            awful.layout.inc(-1)
        end),

        -- Scrolling
        awful.button({}, 4, function()
            awful.layout.inc(-1)
        end),
        awful.button({}, 5, function()
            awful.layout.inc(1)
        end)
    )

    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(layoutbox_buttons)

    local layoutbox = wibox.widget {
        s.mylayoutbox,
        margins = { left = dpi(8), right = dpi(8) },
        widget = wibox.container.margin,
    }

    helpers.add_hover_cursor(layoutbox, "hand1")
    -- Create a system tray widget
    s.systray = wibox.widget.systray()
    -- Create the tray box
    s.traybox = wibox {
        screen = s,
        width = dpi(300),
        height = dpi(50),
        bg = "#00000000",
        visible = false,
        ontop = true,
    }

    s.traybox:setup {
        {
            {
                {
                    layoutbox,
                    stats,
                    spacing = dpi(10),
                    layout = wibox.layout.align.horizontal,
                },
                nil,
                s.systray,
                spacing = dpi(10),
                layout = wibox.layout.align.horizontal,
            },
            margins = dpi(10),
            widget = wibox.container.margin,
        },
        bg = beautiful.bg_systray,
        shape = helpers.rrect(beautiful.border_radius_tray),
        widget = wibox.container.background,
    }
    awful.placement.bottom_right(s.traybox, { margins = beautiful.useless_gap * 2 })
    s.traybox:buttons(gears.table.join(awful.button({}, 2, function()
        s.traybox.visible = false
    end)))
end)

awesome.connect_signal("elemental::dismiss", function()
    local s = mouse.screen
    s.dock.visible = false
end)

-- Every bar theme should provide these fuctions
function wibars_toggle()
    local s = awful.screen.focused()
    s.dock.visible = not s.dock.visible
end
function tray_toggle()
    local s = awful.screen.focused()
    s.traybox.visible = not s.traybox.visible
end
