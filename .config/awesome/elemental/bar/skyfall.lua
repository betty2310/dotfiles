local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"

local keys = require "keys"
local helpers = require "helpers"

-- Helper function that updates a taglist item
local update_taglist = function(item, tag, index)
    if tag.selected then
        item.markup = helpers.colorize_text(
            beautiful.taglist_text_focused[index],
            beautiful.taglist_text_color_focused[index]
        )
    elseif tag.urgent then
        item.markup = helpers.colorize_text(
            beautiful.taglist_text_urgent[index],
            beautiful.taglist_text_color_urgent[index]
        )
    elseif #tag:clients() > 0 then
        item.markup = helpers.colorize_text(
            beautiful.taglist_text_occupied[index],
            beautiful.taglist_text_color_occupied[index]
        )
    else
        item.markup = helpers.colorize_text(
            beautiful.taglist_text_empty[index],
            beautiful.taglist_text_color_empty[index]
        )
    end
end

mytextclock = wibox.widget.textclock()
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        layout = wibox.layout.fixed.horizontal,
        widget_template = {
            widget = wibox.widget.textbox,
            create_callback = function(self, tag, index, _)
                -- self.align = "center"
                -- self.valign = "center"
                self.forced_width = dpi(22)
                self.font = beautiful.taglist_text_font

                update_taglist(self, tag, index)
            end,
            update_callback = function(self, tag, index, _)
                update_taglist(self, tag, index)
            end,
        },
        buttons = keys.taglist_buttons,
    }
    s.mypromptbox = awful.widget.prompt()
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function()
            awful.layout.inc(1)
        end),
        awful.button({}, 3, function()
            awful.layout.inc(-1)
        end),
        awful.button({}, 4, function()
            awful.layout.inc(1)
        end),
        awful.button({}, 5, function()
            awful.layout.inc(-1)
        end)
    ))
    -- Create a system tray widget
    s.systray = wibox.widget.systray()

    -- Create a wibox that will only show the tray
    -- Hidden by default. Can be toggled with a keybind.
    s.traybox = wibox { visible = false, ontop = true, shape = helpers.rrect(beautiful.border_radius), type = "dock" }
    s.traybox.width = dpi(120)
    s.traybox.height = dpi(30) --beautiful.wibar_height - beautiful.screen_margin * 4
    s.traybox.x = dpi(1410) --s.geometry.width - beautiful.screen_margin * 2 - s.traybox.width
    s.traybox.y = dpi(25) --s.geometry.height - s.traybox.height - beautiful.screen_margin * 2
    -- s.traybox.y = s.geometry.height - s.traybox.height - s.traybox.height / 2
    s.traybox.bg = beautiful.bg_systray
    s.traybox:setup {
        s.systray,
        left = dpi(6),
        right = dpi(6),
        widget = wibox.container.margin,
    }
    s.traybox:buttons(gears.table.join(
        -- Middle click - Hide traybox
        awful.button({}, 2, function()
            s.traybox.visible = false
        end)
    ))
    -- Hide traybox when mouse leaves
    s.traybox:connect_signal("mouse::leave", function()
        s.traybox.visible = false
    end)

    -- Create a window control widget
    local close_button = wibox.widget.textbox()
    close_button.font = "JetBrainsMono Nerd Font 8"
    close_button.markup = helpers.colorize_text("  ", x.color1)
    close_button:buttons(gears.table.join(awful.button({}, 1, function()
        if client.focus then
            client.focus:kill()
        end
    end)))
    local maximize_button = wibox.widget.textbox()
    maximize_button:buttons(gears.table.join(awful.button({}, 1, function()
        if client.focus then
            client.focus.maximized = not client.focus.maximized
        end
    end)))
    maximize_button.font = "JetBrainsMono Nerd Font 8"
    maximize_button.markup = helpers.colorize_text(" ", x.color11)
    local minimize_button = wibox.widget.textbox()
    minimize_button:buttons(gears.table.join(awful.button({}, 1, function()
        if client.focus then
            client.focus.minimized = true
        end
    end)))
    minimize_button.font = "JetBrainsMono Nerd Font 8"
    minimize_button.markup = helpers.colorize_text(" ", x.color2)

    local window_buttons = wibox.widget {
        close_button,
        maximize_button,
        minimize_button,
        { -- Padding
            spacing = dpi(6),
            layout = wibox.layout.fixed.horizontal,
        },
        spacing = dpi(6),
        layout = wibox.layout.fixed.horizontal,
    }
    window_buttons:buttons(gears.table.join(
        awful.button({}, 2, function()
            awful.spawn.with_shell "rofi -matching fuzzy -show windowcd"
        end),
        awful.button({}, 4, function()
            awful.client.focus.byidx(-1)
        end),
        awful.button({}, 5, function()
            awful.client.focus.byidx(1)
        end)
    ))

    -- Create the wibox
    s.mywibox = awful.wibar {
        position = beautiful.wibar_position,
        screen = s,
        width = beautiful.wibar_width,
        height = beautiful.wibar_height,
        shape = helpers.rrect(beautiful.wibar_border_radius),
    }
    -- Wibar items
    -- Add or remove widgets here
    s.mywibox:setup {
        {
            { -- Some padding
                layout = wibox.layout.fixed.horizontal,
            },
            window_buttons,
            spacing = dpi(12),
            layout = wibox.layout.fixed.horizontal,
        },
        s.mytaglist,
        s.mylayoutbox,
        mytextclock,
        expand = "none",
        layout = wibox.layout.align.horizontal,
    }
end)

local s = mouse.screen
-- Show traybox when the mouse touches the rightmost edge of the wibar
traybox_activator = wibox {
    x = s.geometry.width - 1,
    y = s.geometry.height - beautiful.wibar_height,
    height = beautiful.wibar_height,
    width = 10,
    opacity = 0,
    visible = true,
    bg = beautiful.wibar_bg,
}
traybox_activator:connect_signal("mouse::enter", function()
    -- awful.screen.focused().traybox.visible = true
    s.traybox.visible = true
end)

-- Every bar theme should provide these fuctions
function wibars_toggle()
    local s = awful.screen.focused()
    s.mywibox.visible = not s.mywibox.visible
end
function tray_toggle()
    local s = awful.screen.focused()
    s.traybox.visible = not s.traybox.visible
end
