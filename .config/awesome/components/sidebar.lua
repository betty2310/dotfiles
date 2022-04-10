local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"
local apps = require "apps"

local helpers = require "helpers"
local bling = require "lib.bling"
local rubato = require "lib.rubato"

local watch = require "awful.widget.watch"

local spawn = require "awful.spawn"
local HOME_DIR = os.getenv "HOME"
local WIDGET_DIR = HOME_DIR .. "/.config/awesome/widget/docker"
local ICONS_DIR = WIDGET_DIR .. "/icons/"

local LIST_CONTAINERS_CMD = [[bash -c "docker container ls -a -s -n %s]]
    .. [[ --format '{{.Names}}::{{.ID}}::{{.Image}}::{{.Status}}::{{.Size}}'"]]

-- Helper function that changes the appearance of progress bars and their icons
local function format_progress_bar(bar)
    -- Since we will rotate the bars 90 degrees, width and height are reversed
    bar.forced_width = dpi(70)
    bar.forced_height = dpi(30)
    bar.shape = gears.shape.rounded_bar
    bar.bar_shape = gears.shape.rectangle
    local w = wibox.widget {
        bar,
        direction = "east",
        layout = wibox.container.rotate,
    }
    return w
end

local weather_widget = require "widget.text_weather"
local weather_widget_icon = weather_widget:get_all_children()[1]
weather_widget_icon.font = "icomoon 29"
weather_widget_icon.align = "center"
weather_widget_icon.valign = "center"
local weather_widget_description = weather_widget:get_all_children()[2]
weather_widget_description.font = "sans medium 12"
local weather_widget_temperature = weather_widget:get_all_children()[3]
weather_widget_temperature.font = "sans medium 10"

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
local weather = wibox.widget {
    {
        weather_widget_icon,
        helpers.horizontal_pad(dpi(15)),
        {
            weather_widget_description,
            weather_widget_temperature,
            layout = wibox.layout.fixed.vertical,
        },
        layout = wibox.layout.align.horizontal,
    },
    left = dpi(30),
    right = dpi(30),
    widget = wibox.container.margin,
}
local weather_popup = require "widget.weather-widget.weather"
local weather_box = create_boxed_widget(weather, dpi(50), dpi(40), x.background)
weather_box:buttons(gears.table.join(awful.button({}, 1, function()
    if weather_popup.visible then
        weather_popup.visible = not weather_popup.visible
    else
        weather_popup:move_next_to(mouse.current_widget_geometry)
    end
end)))
helpers.add_hover_cursor(weather_box, "hand1")

local temperature_bar = require "widget.temperature_bar"
local temperature = format_progress_bar(temperature_bar)
temperature:buttons(gears.table.join(awful.button({}, 1, apps.temperature_monitor)))

local cpu_bar = require "widget.cpu_bar"
local cpu = format_progress_bar(cpu_bar)

cpu:buttons(gears.table.join(awful.button({}, 1, apps.process_monitor), awful.button({}, 3, apps.process_monitor_gui)))

local ram_bar = require "widget.ram_bar"
local ram = format_progress_bar(ram_bar)

--- Widget which is shown when user clicks on the ram widget
local popup = awful.popup {
    ontop = true,
    visible = false,
    widget = {
        widget = wibox.widget.piechart,
        forced_height = 200,
        forced_width = 400,
        colors = {
            x.color6,
            x.color3,
            x.color1,
        },
    },
    shape = gears.shape.rounded_rect,
    border_width = 0,
    offset = { x = -40, y = 0 },
}
local total, used, free, shared, buff_cache, available, total_swap, used_swap, free_swap

local function getPercentage(value)
    return math.floor(value / (total + total_swap) * 100 + 0.5) .. "%"
end

watch('bash -c "LANGUAGE=en_US.UTF-8 free | grep -z Mem.*Swap.*"', timeout, function(widget, stdout)
    total, used, free, shared, buff_cache, available, total_swap, used_swap, free_swap =
        stdout:match "(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*Swap:%s*(%d+)%s*(%d+)%s*(%d+)"

    if widget_show_buf then
        widget.data = { used, free, buff_cache }
    else
        widget.data = { used, total - used }
    end

    if popup.visible then
        popup:get_widget().data_list = {
            { "used " .. getPercentage(used + used_swap), used + used_swap },
            { "free " .. getPercentage(free + free_swap), free + free_swap },
            { "buff_cache " .. getPercentage(buff_cache), buff_cache },
        }
    end
end, ram)

ram:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        popup:get_widget().data_list = {
            { "used " .. getPercentage(used + used_swap), used + used_swap },
            { "free " .. getPercentage(free + free_swap), free + free_swap },
            { "buff_cache " .. getPercentage(buff_cache), buff_cache },
        }

        if popup.visible then
            popup.visible = not popup.visible
        else
            popup:move_next_to(mouse.current_widget_geometry)
        end
    end),
    awful.button({}, 3, apps.process_monitor)
))

local brightness_bar = require "widget.brightness_bar"
local brightness = format_progress_bar(brightness_bar)

brightness:buttons(gears.table.join(
    -- Left click - Toggle redshift
    awful.button({}, 1, apps.night_mode),
    -- Right click - Reset brightness (Set to max)
    awful.button({}, 3, function()
        awful.spawn.with_shell "light -S 100"
    end),
    -- Scroll up - Increase brightness
    awful.button({}, 4, function()
        awful.spawn.with_shell "light -A 1"
    end),
    -- Scroll down - Decrease brightness
    awful.button({}, 5, function()
        awful.spawn.with_shell "light -U 1"
    end)
))

local hours = wibox.widget.textclock "%H"
local minutes = wibox.widget.textclock "%M"

local make_little_dot = function(color)
    return wibox.widget {
        bg = color,
        forced_width = dpi(10),
        forced_height = dpi(10),
        shape = helpers.rrect(dpi(2)),
        widget = wibox.container.background,
    }
end

local time = {
    {
        font = "biotif extra bold 44",
        align = "right",
        valign = "top",
        widget = hours,
    },
    {
        nil,
        {
            make_little_dot(x.color1),
            make_little_dot(x.color2),
            make_little_dot(x.color4),
            spacing = dpi(10),
            widget = wibox.layout.fixed.vertical,
        },
        expand = "none",
        widget = wibox.layout.align.vertical,
    },
    {
        font = "biotif extra bold 44",
        align = "left",
        valign = "top",
        widget = minutes,
    },
    spacing = dpi(20),
    layout = wibox.layout.fixed.horizontal,
}

-- Day of the week (dotw)
local dotw = require "widget.day_of_the_week"
local day_of_the_week = wibox.widget {
    nil,
    dotw,
    expand = "none",
    layout = wibox.layout.align.horizontal,
}

-- Mpd
local mpd_buttons = require "widget.mpd_buttons"
local mpd_song = require "widget.mpd_song"
local mpd_widget_children = mpd_song:get_all_children()
local mpd_title = mpd_widget_children[1]
local mpd_artist = mpd_widget_children[2]
mpd_title.font = "sans medium 14"
mpd_artist.font = "sans medium 10"

-- Set forced height in order to limit the widgets to one line.
-- Might need to be adjusted depending on the font.
mpd_title.forced_height = dpi(22)
mpd_artist.forced_height = dpi(16)

mpd_song:buttons(gears.table.join(
    awful.button({}, 1, function()
        awful.spawn.with_shell "mpc -q toggle"
    end),
    awful.button({}, 3, apps.music),
    awful.button({}, 4, function()
        awful.spawn.with_shell "mpc -q prev"
    end),
    awful.button({}, 5, function()
        awful.spawn.with_shell "mpc -q next"
    end)
))

local volume_bar = require "widget.volume_bar"
local volume = format_progress_bar(volume_bar)

volume:buttons(gears.table.join(
    -- Left click - Mute / Unmute
    awful.button({}, 1, function()
        helpers.volume_control(0)
    end),
    -- Right click - Run or raise pavucontrol
    awful.button({}, 3, apps.volume),
    -- Scroll - Increase / Decrease volume
    awful.button({}, 4, function()
        helpers.volume_control(1)
    end),
    awful.button({}, 5, function()
        helpers.volume_control(-1)
    end)
))

-- Battery
local cute_battery_face = require "widget.cute_battery_face"
cute_battery_face:buttons(gears.table.join(awful.button({}, 1, apps.battery_monitor)))

-- Create tooltip widget
-- It should change depending on what the user is hovering over
local adaptive_tooltip = wibox.widget {
    visible = false,
    top_only = true,
    layout = wibox.layout.stack,
}

-- Create tooltip for widget w
local tooltip_counter = 0
local create_tooltip = function(w)
    local tooltip = wibox.widget {
        font = "sans medium 10",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox,
    }

    tooltip_counter = tooltip_counter + 1
    local index = tooltip_counter

    adaptive_tooltip:insert(index, tooltip)

    w:connect_signal("mouse::enter", function()
        -- Raise tooltip to the top of the stack
        adaptive_tooltip:set(1, tooltip)
        adaptive_tooltip.visible = true
    end)
    w:connect_signal("mouse::leave", function()
        adaptive_tooltip.visible = false
    end)

    return tooltip
end
local brightness_tooltip = create_tooltip(brightness_bar)
awesome.connect_signal("signal::brightness", function(value)
    brightness_tooltip.markup = "Your screen is <span foreground='"
        .. beautiful.brightness_bar_active_color
        .. "'><b>"
        .. tostring(value)
        .. "%</b></span> bright"
end)

local dot = wibox.widget {
    markup = "",
    font = beautiful.font_name,
    widget = wibox.widget.textbox,
}
local date_tooltip = create_tooltip(dot)
awesome.connect_signal("signal::date", function(value)
    date_tooltip.markup = "<span foreground='"
        .. beautiful.brightness_bar_active_color
        .. "'><b>"
        .. value
        .. "%</b></span>"
end)

local cpu_tooltip = create_tooltip(cpu_bar)
awesome.connect_signal("signal::cpu", function(value)
    cpu_tooltip.markup = "You are using <span foreground='"
        .. beautiful.cpu_bar_active_color
        .. "'><b>"
        .. tostring(value)
        .. "%</b></span> of CPU"
end)

local ram_tooltip = create_tooltip(ram_bar)
awesome.connect_signal("signal::ram", function(value, _)
    ram_tooltip.markup = "You are using <span foreground='"
        .. beautiful.ram_bar_active_color
        .. "'><b>"
        .. string.format("%.1f", value / 1000)
        .. "G</b></span> of memory"
end)

local volume_tooltip = create_tooltip(volume_bar)
awesome.connect_signal("signal::volume", function(value, muted)
    volume_tooltip.markup = "The volume is at <span foreground='"
        .. beautiful.volume_bar_active_color
        .. "'><b>"
        .. tostring(value)
        .. "%</b></span>"
    if muted then
        volume_tooltip.markup = volume_tooltip.markup
            .. " and <span foreground='"
            .. beautiful.volume_bar_active_color
            .. "'><b>muted</b></span>"
    end
end)

local temperature_tooltip = create_tooltip(temperature_bar)
awesome.connect_signal("signal::temperature", function(value)
    temperature_tooltip.markup = "Your CPU temperature is at <span foreground='"
        .. beautiful.temperature_bar_active_color
        .. "'><b>"
        .. tostring(value)
        .. "°C</b></span>"
end)

local battery_tooltip = create_tooltip(cute_battery_face)
awesome.connect_signal("signal::battery", function(value)
    battery_tooltip.markup = "Your battery is at <span foreground='"
        .. beautiful.battery_bar_active_color
        .. "'><b>"
        .. tostring(value)
        .. "%</b></span>"
end)

-- Add clickable mouse effects on some widgets
helpers.add_hover_cursor(cpu, "hand1")
helpers.add_hover_cursor(ram, "hand1")
helpers.add_hover_cursor(temperature, "hand1")
helpers.add_hover_cursor(volume, "hand1")
helpers.add_hover_cursor(brightness, "hand1")
helpers.add_hover_cursor(mpd_song, "hand1")
helpers.add_hover_cursor(cute_battery_face, "hand1")

--- Utility function to show warning messages
local function show_warning(message)
    naughty.notify {
        preset = naughty.config.presets.critical,
        title = "Docker Widget",
        text = message,
    }
end

local docker_popup = awful.popup {
    ontop = true,
    visible = false,
    shape = helpers.prrect(dpi(0), true, true, true, true),
    border_width = 4,
    border_color = x.color4,
    maximum_width = 600,
    offset = { x = -70, y = 50 },
    widget = {},
    type = "dock",
}

local docker_widget = wibox.widget {
    {
        {
            id = "icon",
            widget = wibox.widget.imagebox,
        },
        margins = 4,
        layout = wibox.container.margin,
    },
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 4)
    end,
    widget = wibox.container.background,
    set_icon = function(self, new_icon)
        self:get_children_by_id("icon")[1].image = new_icon
    end,
}

local parse_container = function(line)
    local name, id, image, status, how_long, size = line:match "(.*)::(.*)::(.*)::(%w*) (.*)::(.*)"
    local actual_status
    if status == "Up" and how_long:find "Paused" then
        actual_status = "Paused"
    else
        actual_status = status
    end

    how_long = how_long:gsub("%s?%(.*%)%s?", "")

    local container = {
        name = name,
        id = id,
        image = image,
        status = actual_status,
        how_long = how_long,
        size = size,
        is_up = function()
            return status == "Up"
        end,
        is_paused = function()
            return actual_status:find "Paused"
        end,
        is_exited = function()
            return status == "Exited"
        end,
    }
    return container
end

local status_to_icon_name = {
    Up = ICONS_DIR .. "play.svg",
    Exited = ICONS_DIR .. "square.svg",
    Paused = ICONS_DIR .. "pause.svg",
}

local args = {}

local icon = args.icon or ICONS_DIR .. "docker.svg"
local number_of_containers = args.number_of_containers or -1

docker_widget:set_icon(icon)

local rows = {
    { widget = wibox.widget.textbox },
    layout = wibox.layout.fixed.vertical,
}

local function rebuild_widget(containers, errors, _, _)
    if errors ~= "" then
        show_warning(errors)
        return
    end

    for i = 0, #rows do
        rows[i] = nil
    end

    for line in containers:gmatch "[^\r\n]+" do
        local container = parse_container(line)

        local status_icon = wibox.widget {
            image = status_to_icon_name[container["status"]],
            resize = false,
            widget = wibox.widget.imagebox,
        }

        local start_stop_button
        if container.is_up() or container.is_exited() then
            start_stop_button = wibox.widget {
                {
                    {
                        id = "icon",
                        image = ICONS_DIR .. (container:is_up() and "stop-btn.svg" or "play-btn.svg"),
                        opacity = 0.4,
                        resize = false,
                        widget = wibox.widget.imagebox,
                    },
                    left = 2,
                    right = 2,
                    layout = wibox.container.margin,
                },
                shape = gears.shape.circle,
                bg = "#00000000",
                widget = wibox.container.background,
            }
            local old_cursor, old_wibox
            start_stop_button:connect_signal("mouse::enter", function(c)
                c:set_bg "#3B4252"

                local wb = mouse.current_wibox
                old_cursor, old_wibox = wb.cursor, wb
                wb.cursor = "hand1"
                c:get_children_by_id("icon")[1]:set_opacity(1)
                c:get_children_by_id("icon")[1]:emit_signal "widget::redraw_needed"
            end)
            start_stop_button:connect_signal("mouse::leave", function(c)
                c:set_bg "#00000000"
                if old_wibox then
                    old_wibox.cursor = old_cursor
                    old_wibox = nil
                end
                c:get_children_by_id("icon")[1]:set_opacity(0.4)
                c:get_children_by_id("icon")[1]:emit_signal "widget::redraw_needed"
            end)

            start_stop_button:buttons(gears.table.join(awful.button({}, 1, function()
                local command
                if container:is_up() then
                    command = "stop"
                else
                    command = "start"
                end

                status_icon:set_opacity(0.2)
                status_icon:emit_signal "widget::redraw_needed"

                spawn.easy_async("docker " .. command .. " " .. container["name"], function()
                    if errors ~= "" then
                        show_warning(errors)
                    end
                    spawn.easy_async(string.format(LIST_CONTAINERS_CMD, number_of_containers), function(stdout, stderr)
                        rebuild_widget(stdout, stderr)
                    end)
                end)
            end)))
        else
            start_stop_button = nil
        end

        local pause_unpause_button
        if container.is_up() then
            pause_unpause_button = wibox.widget {
                {
                    {
                        id = "icon",
                        image = ICONS_DIR .. (container:is_paused() and "unpause-btn.svg" or "pause-btn.svg"),
                        opacity = 0.4,
                        resize = false,
                        widget = wibox.widget.imagebox,
                    },
                    left = 2,
                    right = 2,
                    layout = wibox.container.margin,
                },
                shape = gears.shape.circle,
                bg = "#00000000",
                widget = wibox.container.background,
            }
            local old_cursor, old_wibox
            pause_unpause_button:connect_signal("mouse::enter", function(c)
                c:set_bg "#3B4252"
                local wb = mouse.current_wibox
                old_cursor, old_wibox = wb.cursor, wb
                wb.cursor = "hand1"
                c:get_children_by_id("icon")[1]:set_opacity(1)
                c:get_children_by_id("icon")[1]:emit_signal "widget::redraw_needed"
            end)
            pause_unpause_button:connect_signal("mouse::leave", function(c)
                c:set_bg "#00000000"
                if old_wibox then
                    old_wibox.cursor = old_cursor
                    old_wibox = nil
                end
                c:get_children_by_id("icon")[1]:set_opacity(0.4)
                c:get_children_by_id("icon")[1]:emit_signal "widget::redraw_needed"
            end)

            pause_unpause_button:buttons(gears.table.join(awful.button({}, 1, function()
                local command
                if container:is_paused() then
                    command = "unpause"
                else
                    command = "pause"
                end

                status_icon:set_opacity(0.2)
                status_icon:emit_signal "widget::redraw_needed"

                awful.spawn.easy_async("docker " .. command .. " " .. container["name"], function(_, stderr)
                    if stderr ~= "" then
                        show_warning(stderr)
                    end
                    spawn.easy_async(
                        string.format(LIST_CONTAINERS_CMD, number_of_containers),
                        function(stdout, container_errors)
                            rebuild_widget(stdout, container_errors)
                        end
                    )
                end)
            end)))
        else
            pause_unpause_button = nil
        end

        local delete_button
        if not container.is_up() then
            delete_button = wibox.widget {
                {
                    {
                        id = "icon",
                        image = ICONS_DIR .. "trash-btn.svg",
                        opacity = 0.4,
                        resize = false,
                        widget = wibox.widget.imagebox,
                    },
                    margins = 4,
                    layout = wibox.container.margin,
                },
                shape = gears.shape.circle,
                bg = "#00000000",
                widget = wibox.container.background,
            }
            delete_button:buttons(gears.table.join(awful.button({}, 1, function()
                awful.spawn.easy_async("docker rm " .. container["name"], function(_, rm_stderr)
                    if rm_stderr ~= "" then
                        show_warning(rm_stderr)
                    end
                    spawn.easy_async(
                        string.format(LIST_CONTAINERS_CMD, number_of_containers),
                        function(lc_stdout, lc_stderr)
                            rebuild_widget(lc_stdout, lc_stderr)
                        end
                    )
                end)
            end)))

            local old_cursor, old_wibox
            delete_button:connect_signal("mouse::enter", function(c)
                c:set_bg "#3B4252"
                local wb = mouse.current_wibox
                old_cursor, old_wibox = wb.cursor, wb
                wb.cursor = "hand1"
                c:get_children_by_id("icon")[1]:set_opacity(1)
                c:get_children_by_id("icon")[1]:emit_signal "widget::redraw_needed"
            end)
            delete_button:connect_signal("mouse::leave", function(c)
                c:set_bg "#00000000"
                if old_wibox then
                    old_wibox.cursor = old_cursor
                    old_wibox = nil
                end
                c:get_children_by_id("icon")[1]:set_opacity(0.4)
                c:get_children_by_id("icon")[1]:emit_signal "widget::redraw_needed"
            end)
        else
            delete_button = nil
        end

        local row = wibox.widget {
            {
                {
                    {
                        {
                            status_icon,
                            margins = 12,
                            layout = wibox.container.margin,
                        },
                        valign = "center",
                        layout = wibox.container.place,
                    },
                    {
                        {
                            {
                                markup = "<b>" .. container["name"] .. "</b>",
                                widget = wibox.widget.textbox,
                            },
                            {
                                text = container["size"],
                                widget = wibox.widget.textbox,
                            },
                            {
                                text = container["how_long"],
                                widget = wibox.widget.textbox,
                            },
                            forced_width = 180,
                            layout = wibox.layout.fixed.vertical,
                        },
                        valign = "center",
                        layout = wibox.container.place,
                    },
                    {
                        {
                            start_stop_button,
                            pause_unpause_button,
                            delete_button,
                            layout = wibox.layout.align.horizontal,
                        },
                        forced_width = 90,
                        valign = "center",
                        haligh = "center",
                        layout = wibox.container.place,
                    },
                    spacing = 10,
                    layout = wibox.layout.align.horizontal,
                },
                margins = 8,
                layout = wibox.container.margin,
            },
            bg = beautiful.bg_normal,
            widget = wibox.container.background,
        }

        row:connect_signal("mouse::enter", function(c)
            c:set_bg(beautiful.bg_focus)
        end)
        row:connect_signal("mouse::leave", function(c)
            c:set_bg(beautiful.bg_normal)
        end)

        table.insert(rows, row)
    end

    docker_popup:setup(rows)
end

local go3 = wibox.widget {
    font = "JetBrainsMono Nerd Font 13",
    markup = helpers.colorize_text(" ", x.color4),
    widget = wibox.widget.textbox,
}

go3:buttons(gears.table.join(awful.button({}, 1, function()
    if docker_popup.visible then
        docker_widget:set_bg "#00000000"
        docker_popup.visible = not docker_popup.visible
    else
        docker_widget:set_bg(beautiful.bg_focus)
        spawn.easy_async(string.format(LIST_CONTAINERS_CMD, number_of_containers), function(stdout, stderr)
            rebuild_widget(stdout, stderr)
            docker_popup:move_next_to(mouse.current_widget_geometry)
        end)
    end
end)))
-- Create the sidebar
sidebar = wibox { visible = false, ontop = true, type = "dock", screen = screen.primary }
sidebar.bg = "#00000000" -- For anti aliasing
sidebar.fg = beautiful.sidebar_fg or beautiful.wibar_fg or "#FFFFFF"
sidebar.opacity = beautiful.sidebar_opacity or 1
sidebar.height = screen.primary.geometry.height
sidebar.width = beautiful.sidebar_width or dpi(300)
sidebar.y = beautiful.sidebar_y or 0
local radius = beautiful.sidebar_border_radius or 0
if beautiful.sidebar_position == "right" then
    awful.placement.top_right(sidebar)
else
    awful.placement.top_left(sidebar)
end
awful.placement.maximize_vertically(
    sidebar,
    { honor_workarea = true, margins = { top = beautiful.useless_gap * 2, bottom = beautiful.useless_gap * 0 } }
)

sidebar:buttons(gears.table.join(
    -- Middle click - Hide sidebar
    awful.button({}, 2, function()
        sidebar_hide()
    end)
))

-- local slide = rubato.timed({
--     pos = dpi(-400),
--     rate = 60,
--     intro = 0.2,
--     duration = 0.4,
--     easing = rubato.quadratic,
--     awestore_compat = true,
--     subscribed = function(pos)
--         sidebar.x = pos
--     end,
-- })
-- local sidebar_status = false
--
-- slide.ended:subscribe(function()
--     if sidebar_status then
--         sidebar.visible = false
--     end
-- end)
--
-- local function sidebar_show()
--     sidebar.visible = true
--     slide:set(0)
--     sidebar_status = false
-- end
--
-- local function sidebar_hide()
--     slide:set(-400)
--     sidebar_status = true
-- end
--
-- sidebar_toggle = function()
--     if sidebar.visible then
--         sidebar_hide()
--     else
--         sidebar_show()
--     end
-- end

sidebar_show = function()
    sidebar.visible = true
end

sidebar_hide = function()
    sidebar.visible = false
    weather_popup.visible = false
    popup.visible = false
    docker_popup.visible = false
end

sidebar_toggle = function()
    if sidebar.visible then
        sidebar_hide()
    else
        sidebar.visible = true
    end
end

-- Hide sidebar when mouse leaves
if user.sidebar.hide_on_mouse_leave then
    sidebar:connect_signal("mouse::leave", function()
        if docker_popup.visible == true then
            docker_popup:connect_signal("mouse::leave", function()
                -- if docker_popup.visible == true then
                --     sidebar_show()
                -- else
                --     sidebar_hide()
                -- end
                sidebar_hide()
            end)
        else
            sidebar_hide()
        end
    end)
end

-- Activate sidebar by moving the mouse at the edge of the screen
if user.sidebar.show_on_mouse_screen_edge then
    local sidebar_activator = wibox {
        y = sidebar.y,
        width = 1,
        visible = true,
        ontop = false,
        opacity = 0,
        below = true,
        screen = screen.primary,
    }
    sidebar_activator.height = sidebar.height
    sidebar_activator:connect_signal("mouse::enter", function()
        sidebar.visible = true
    end)

    if beautiful.sidebar_position == "right" then
        awful.placement.right(sidebar_activator)
    else
        awful.placement.left(sidebar_activator)
    end

    sidebar_activator:buttons(gears.table.join(
        awful.button({}, 4, function()
            awful.tag.viewprev()
        end),
        awful.button({}, 5, function()
            awful.tag.viewnext()
        end)
    ))
end
-- Item placement

local music_boxed = require "widget.music"

local go1 = require "widget.cpu_graph"
local go0 = wibox.widget {
    font = "JetBrainsMono Nerd Font 13",
    align = "right",
    markup = helpers.colorize_text(" ", "#B48EAD"),
    widget = wibox.widget.textbox,
}
local go2 = require "widget.github.github"

local go4 = wibox.widget {
    font = "Material Design Icons  13",
    markup = helpers.colorize_text("󰮯", x.color3),
    widget = wibox.widget.textbox,
}

local pacman = wibox.widget {
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
helpers.add_hover_cursor(go1, "hand1")
helpers.add_hover_cursor(go2, "hand1")
helpers.add_hover_cursor(go3, "hand1")
helpers.add_hover_cursor(go4, "hand1")

sidebar:setup {
    {
        { ----------- TOP GROUP -----------
            {
                helpers.vertical_pad(dpi(30)),
                {
                    nil,
                    {
                        time,
                        spacing = dpi(12),
                        layout = wibox.layout.fixed.horizontal,
                    },
                    expand = "none",
                    layout = wibox.layout.align.horizontal,
                },
                helpers.vertical_pad(dpi(30)),
                day_of_the_week,
                helpers.vertical_pad(dpi(30)),
                {
                    nil,
                    cute_battery_face,
                    expand = "none",
                    layout = wibox.layout.align.horizontal,
                },

                helpers.vertical_pad(dpi(30)),
                layout = wibox.layout.fixed.vertical,
            },
            layout = wibox.layout.fixed.vertical,
        },
        { ----------- MIDDLE GROUP -----------
            {
                helpers.vertical_pad(dpi(25)),
                weather_box,
                helpers.vertical_pad(dpi(25)),
                {
                    {
                        mpd_buttons,
                        mpd_song,
                        spacing = dpi(5),
                        layout = wibox.layout.fixed.vertical,
                    },
                    bottom = dpi(35),
                    left = dpi(30),
                    right = dpi(30),
                    widget = wibox.container.margin,
                },

                {
                    nil,
                    {
                        volume,
                        cpu,
                        temperature,
                        ram,
                        brightness,
                        spacing = dpi(5),
                        -- layout = wibox.layout.fixed.vertical
                        layout = wibox.layout.fixed.horizontal,
                    },
                    expand = "none",
                    layout = wibox.layout.align.horizontal,
                },
                helpers.vertical_pad(dpi(30)),
                pacman,
                layout = wibox.layout.fixed.vertical,
            },
            shape = helpers.prrect(dpi(40), false, true, false, false),
            bg = x.background,
            widget = wibox.container.background,
        },
        { ----------- BOTTOM GROUP -----------
            {
                {

                    {
                        adaptive_tooltip,
                        expand = "none",
                        layout = wibox.layout.align.horizontal,
                    },

                    helpers.vertical_pad(dpi(20)),
                    {
                        music_boxed,
                        layout = wibox.layout.fixed.horizontal,
                    },

                    layout = wibox.layout.fixed.vertical,
                },
                left = dpi(40),
                right = dpi(20),
                bottom = dpi(20),
                widget = wibox.container.margin,
            },
            bg = x.background,
            widget = wibox.container.background,
        },
        layout = wibox.layout.align.vertical,
    },
    shape = helpers.prrect(dpi(40), false, true, false, false),
    bg = "#2b313c",
    widget = wibox.container.background,
}
