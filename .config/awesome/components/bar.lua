local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"
local bling = require "lib.bling"

local helpers = require "helpers"
local keys = require "keys"

local dock_autohide_delay = 0.5 -- seconds

bling.widget.tag_preview.enable {
    show_client_content = true, -- Whether or not to show the client content
    x = 10, -- The x-coord of the popup
    y = 10, -- The y-coord of the popup
    scale = 0.25, -- The scale of the previews compared to the screen
    honor_padding = false, -- Honor padding when creating widget size
    honor_workarea = false, -- Honor work area when creating widget size
    placement_fn = function(c) -- Place the widget using awful.placement (this overrides x & y)
        awful.placement.top_left(c, {
            margins = {
                top = 30,
                left = 30,
            },
        })
    end,
    background_widget = wibox.widget { -- Set a background image (like a wallpaper) for the widget
        image = beautiful.wallpaper,
        horizontal_fit_policy = "fit",
        vertical_fit_policy = "fit",
        widget = wibox.widget.imagebox,
    },
}

local dock = require "widget.dock"
local dock_placement = function(w)
    return awful.placement.bottom(w)
end

local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t)
        t:view_only()
    end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t)
        awful.tag.viewnext(t.screen)
    end),
    awful.button({}, 5, function(t)
        awful.tag.viewprev(t.screen)
    end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", { raise = true })
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list { theme = { width = 250 } }
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end)
)
mymainmenu = awful.menu {
    items = {
        { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "open terminal", terminal },
    },
}

mytextclock = wibox.widget.textclock()
mylauncher = awful.widget.launcher { image = beautiful.awesome_icon, menu = mymainmenu }
awful.screen.connect_for_each_screen(function(s)
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
    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        -- style = {
        --     shape = gears.shape.powerline,
        -- },
        layout = {
            spacing = 2,
            spacing_widget = {
                color = "#dddddd",
                shape = gears.shape.powerline,
                widget = wibox.widget.separator,
            },
            layout = wibox.layout.fixed.horizontal,
        },
        widget_template = {
            {
                {
                    layout = wibox.layout.fixed.vertical,
                    {
                        {
                            id = "text_role",
                            widget = wibox.widget.textbox,
                        },
                        left = 2,
                        right = 2,
                        top = 1,
                        widget = wibox.container.margin,
                    },
                    {
                        {
                            left = 10,
                            right = 10,
                            top = 3,
                            widget = wibox.container.margin,
                        },
                        id = "overline",
                        bg = "#ffffff",
                        shape = gears.shape.rectangle,
                        widget = wibox.container.background,
                    },
                },
                left = 5,
                right = 5,
                widget = wibox.container.margin,
            },
            id = "background_role",
            widget = wibox.container.background,
            -- Add support for hover colors and an index label
            create_callback = function(self, c3, index, objects) --luacheck: no unused args
                self:connect_signal("mouse::enter", function()
                    if #c3:clients() > 0 then
                        -- BLING: Update the widget with the new tag
                        awesome.emit_signal("bling::tag_preview::update", c3)
                        -- BLING: Show the widget
                        awesome.emit_signal("bling::tag_preview::visibility", s, true)
                    end

                    if self.bg ~= x.color1 then
                        self.backup = self.bg
                        self.has_backup = true
                    end
                    self.bg = x.color1
                end)
                self:connect_signal("mouse::leave", function()
                    -- BLING: Turn the widget off
                    awesome.emit_signal("bling::tag_preview::visibility", s, false)

                    if self.has_backup then
                        self.bg = self.backup
                    end
                end)
                local focused = false
                for _, x in pairs(awful.screen.focused().selected_tags) do
                    if x.index == index then
                        focused = true
                        break
                    end
                end
                if focused then
                    self:get_children_by_id("overline")[1].bg = x.color2 -- focused color
                else
                    self:get_children_by_id("overline")[1].bg = "#00000000" -- unfocused color
                end
            end,
            update_callback = function(self, c3, index, objects) --luacheck: no unused args
                local focused = false
                for _, x in pairs(awful.screen.focused().selected_tags) do
                    if x.index == index then
                        focused = true
                        break
                    end
                end
                if focused then
                    self:get_children_by_id("overline")[1].bg = x.color2
                else
                    self:get_children_by_id("overline")[1].bg = "#00000000"
                end
            end,
        },
        buttons = taglist_buttons,
    }
    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        layout = {
            spacing = 10,
            spacing_widget = {
                valign = "center",
                halign = "center",
                widget = wibox.container.place,
            },
            layout = wibox.layout.flex.horizontal,
        },
        widget_template = {
            {
                {
                    {
                        {
                            id = "icon_role",
                            widget = wibox.widget.imagebox,
                        },
                        margins = 2,
                        widget = wibox.container.margin,
                    },
                    {
                        id = "text_role",
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left = 10,
                right = 10,
                widget = wibox.container.margin,
            },
            id = "background_role",
            widget = wibox.container.background,
        },
    }
    s.mywibox = awful.wibar {
        position = beautiful.wibar_position,
        screen = s,
        bg = "#00000000",
        -- height = beautiful.wibar_height,
        -- width = beautiful.wibar_width,
        shape = helpers.rrect(beautiful.wibar_border_radius),
    }

    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            {
                text = " ",
                widget = wibox.widget.textbox,
            },

            s.mylayoutbox,
            {
                text = " ",
                widget = wibox.widget.textbox,
            },
            s.mytaglist,
            {
                text = " ",
                widget = wibox.widget.textbox,
            },
        },
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

    -- Create a system tray widget
    s.systray = wibox.widget.systray()
    -- Create the tray box
    s.traybox = wibox {
        screen = s,
        width = dpi(150),
        height = dpi(50),
        bg = "#00000000",
        visible = false,
        ontop = true,
    }
    s.traybox:setup {
        {
            {
                nil,
                s.systray,
                expand = "none",
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
