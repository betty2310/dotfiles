local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local apps = require("apps")

local helpers = require("helpers")
local bling = require("lib.bling")
local rubato = require("lib.rubato")

-- Helper function that changes the appearance of progress bars and their icons
local function format_progress_bar(bar)
    -- Since we will rotate the bars 90 degrees, width and height are reversed
    bar.forced_width = dpi(70)
    bar.forced_height = dpi(30)
    bar.shape = gears.shape.rounded_bar
    bar.bar_shape = gears.shape.rectangle
    local w = wibox.widget({
        bar,
        direction = "east",
        layout = wibox.container.rotate,
    })
    return w
end

local weather_widget = require("widget.text_weather")
local weather_widget_icon = weather_widget:get_all_children()[1]
weather_widget_icon.font = "icomoon 16"
weather_widget_icon.align = "center"
weather_widget_icon.valign = "center"
local weather_widget_description = weather_widget:get_all_children()[2]
weather_widget_description.font = "sans medium 14"
local weather_widget_temperature = weather_widget:get_all_children()[3]
weather_widget_temperature.font = "sans medium 14"

local weather = wibox.widget({
    {
        nil,
        weather_widget_description,
        expand = "none",
        layout = wibox.layout.align.horizontal,
    },
    {
        nil,
        {
            weather_widget_icon,
            weather_widget_temperature,
            spacing = dpi(5),
            layout = wibox.layout.fixed.horizontal,
        },
        expand = "none",
        layout = wibox.layout.align.horizontal,
    },
    spacing = dpi(5),
    layout = wibox.layout.fixed.vertical,
    -- nil,
    -- weather_widget,
    -- layout = wibox.layout.align.horizontal,
    -- expand = "none"
})

local temperature_bar = require("widget.temperature_bar")
local temperature = format_progress_bar(temperature_bar)
temperature:buttons(gears.table.join(awful.button({}, 1, apps.temperature_monitor)))

local cpu_bar = require("widget.cpu_bar")
local cpu = format_progress_bar(cpu_bar)

cpu:buttons(gears.table.join(awful.button({}, 1, apps.process_monitor), awful.button({}, 3, apps.process_monitor_gui)))

local ram_bar = require("widget.ram_bar")
local ram = format_progress_bar(ram_bar)

ram:buttons(gears.table.join(awful.button({}, 1, apps.process_monitor), awful.button({}, 3, apps.process_monitor_gui)))

local brightness_bar = require("widget.brightness_bar")
local brightness = format_progress_bar(brightness_bar)

brightness:buttons(gears.table.join(
    -- Left click - Toggle redshift
    awful.button({}, 1, apps.night_mode),
    -- Right click - Reset brightness (Set to max)
    awful.button({}, 3, function()
        awful.spawn.with_shell("light -S 100")
    end),
    -- Scroll up - Increase brightness
    awful.button({}, 4, function()
        awful.spawn.with_shell("light -A 10")
    end),
    -- Scroll down - Decrease brightness
    awful.button({}, 5, function()
        awful.spawn.with_shell("light -U 10")
    end)
))

local hours = wibox.widget.textclock("%H")
local minutes = wibox.widget.textclock("%M")

local make_little_dot = function(color)
    return wibox.widget({
        bg = color,
        forced_width = dpi(10),
        forced_height = dpi(10),
        shape = helpers.rrect(dpi(2)),
        widget = wibox.container.background,
    })
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
local dotw = require("widget.day_of_the_week")
local day_of_the_week = wibox.widget({
    nil,
    dotw,
    expand = "none",
    layout = wibox.layout.align.horizontal,
})

-- pomo
--local pomodoro = require "pomodoro"
-- spotify
--local spotify = require "widget.spotify"

local pacman = require("widget.pacman")
pacman:buttons(gears.table.join(awful.button({}, 1, apps.tree)))

-- Mpd
local mpd_buttons = require("widget.mpd_buttons")
local mpd_song = require("widget.mpd_song")
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
        awful.spawn.with_shell("mpc -q toggle")
    end),
    awful.button({}, 3, apps.music),
    awful.button({}, 4, function()
        awful.spawn.with_shell("mpc -q prev")
    end),
    awful.button({}, 5, function()
        awful.spawn.with_shell("mpc -q next")
    end)
))

local search_icon = wibox.widget({
    font = "icomoon bold 10",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox(),
})

local reset_search_icon = function()
    search_icon.markup = helpers.colorize_text("", x.color3)
end
reset_search_icon()

local search_text = wibox.widget({
    -- markup = helpers.colorize_text("Search", x.color8),
    align = "center",
    valign = "center",
    font = "sans 9",
    widget = wibox.widget.textbox(),
})

local search_bar = wibox.widget({
    shape = gears.shape.rounded_bar,
    bg = x.color0,
    widget = wibox.container.background(),
})

local search = wibox.widget({
    -- search_bar,
    {
        {
            search_icon,
            {
                search_text,
                bottom = dpi(2),
                widget = wibox.container.margin,
            },
            layout = wibox.layout.fixed.horizontal,
        },
        left = dpi(15),
        widget = wibox.container.margin,
    },
    forced_height = dpi(35),
    forced_width = dpi(200),
    shape = gears.shape.rounded_bar,
    bg = x.color0,
    widget = wibox.container.background(),
    -- layout = wibox.layout.stack
})

local function generate_prompt_icon(icon, color)
    return "<span font='icomoon 10' foreground='" .. color .. "'>" .. icon .. "</span> "
end

function sidebar_activate_prompt(action)
    sidebar.visible = true
    search_icon.visible = false
    local prompt
    if action == "run" then
        prompt = generate_prompt_icon("", x.color2)
    elseif action == "web_search" then
        prompt = generate_prompt_icon("", x.color4)
    end
    helpers.prompt(action, search_text, prompt, function()
        search_icon.visible = true
        if mouse.current_wibox ~= sidebar then
            sidebar.visible = false
        end
    end)
end

local prompt_is_active = function()
    -- The search icon is hidden and replaced by other icons
    -- when the prompt is running
    return not search_icon.visible
end

search:buttons(gears.table.join(
    awful.button({}, 1, function()
        sidebar_activate_prompt("run")
    end),
    awful.button({}, 3, function()
        sidebar_activate_prompt("web_search")
    end)
))

local volume_bar = require("widget.volume_bar")
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
        helpers.volume_control(2)
    end),
    awful.button({}, 5, function()
        helpers.volume_control(-2)
    end)
))

-- Battery
local cute_battery_face = require("widget.cute_battery_face")
cute_battery_face:buttons(gears.table.join(awful.button({}, 1, apps.battery_monitor)))

-- Create tooltip widget
-- It should change depending on what the user is hovering over
local adaptive_tooltip = wibox.widget({
    visible = false,
    top_only = true,
    layout = wibox.layout.stack,
})

-- Create tooltip for widget w
local tooltip_counter = 0
local create_tooltip = function(w)
    local tooltip = wibox.widget({
        font = "sans medium 10",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox,
    })

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

local dot = wibox.widget({
    markup = "",
    font = beautiful.font_name,
    widget = wibox.widget.textbox,
})
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
local awmodoro = require("widget.awmodoro")
local pomodoro = awmodoro.new({
    minutes = 25,
    do_notify = true,
    active_bg_color = x.color0,
    paused_bg_color = x.color0,
    fg_color = x.color1,
    width = dpi(90),
    height = dpi(20),
})
pomodoro:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        pomodoro:toggle()
    end),
    awful.button({}, 2, function()
        pomodoro:finish()
    end),
    awful.button({}, 3, function()
        pomodoro:reset()
    end)
))
local charging_icon = wibox.widget({
    font = "Font Awesome 6 Pro Solid 11",
    align = "right",
    markup = helpers.colorize_text(" ", x.color1 .. "90"),
    widget = wibox.widget.textbox(),
})
local pomo = wibox.widget({
    {
        pomodoro,
        shape = helpers.rrect(dpi(16)),
        border_color = "#333946",
        border_width = dpi(1),
        bg = x.color4,
        widget = wibox.container.background,
    },
    -- {
    --     charging_icon,
    --     right = dpi(10),
    --     widget = wibox.container.margin(),
    -- },
    top_only = false,
    layout = wibox.layout.stack,
})

local quote = require("widget.quote")

-- Add clickable mouse effects on some widgets
helpers.add_hover_cursor(cpu, "hand1")
helpers.add_hover_cursor(ram, "hand1")
helpers.add_hover_cursor(temperature, "hand1")
helpers.add_hover_cursor(volume, "hand1")
helpers.add_hover_cursor(brightness, "hand1")
helpers.add_hover_cursor(mpd_song, "hand1")
helpers.add_hover_cursor(cute_battery_face, "hand1")
helpers.add_hover_cursor(pacman, "hand1")
helpers.add_hover_cursor(dotw, "hand1")

-- Create the sidebar
sidebar = wibox({ visible = false, ontop = true, type = "dock", screen = screen.primary })
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
awful.placement.maximize_vertically(sidebar, { honor_workarea = true, margins = { top = beautiful.useless_gap * 2 } })

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
    -- Do not hide it if prompt is active
    if not prompt_is_active() then
        sidebar.visible = false
    end
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
        sidebar_hide()
    end)
end
-- Hide sidebar when mouse leaves
if user.sidebar.hide_on_mouse_leave then
    sidebar:connect_signal("mouse::leave", function()
        sidebar_hide()
    end)
end

-- Activate sidebar by moving the mouse at the edge of the screen
if user.sidebar.show_on_mouse_screen_edge then
    local sidebar_activator = wibox({
        y = sidebar.y,
        width = 1,
        visible = true,
        ontop = false,
        opacity = 0,
        below = true,
        screen = screen.primary,
    })
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
local function create_boxed_widget(widget_to_be_boxed, width, height, inner_pad)
    local box_container = wibox.container.background()
    box_container.bg = "#313744"
    box_container.forced_height = height
    box_container.forced_width = width
    box_container.shape = helpers.rrect(dpi(12))

    local inner = dpi(0)

    if inner_pad then
        inner = beautiful.tooltip_box_margin
    end

    local boxed_widget = wibox.widget({
        -- Add margins
        {
            -- Add background color
            {
                -- The actual widget goes here
                widget_to_be_boxed,
                margins = inner,
                widget = wibox.container.margin,
            },
            widget = box_container,
        },
        margins = beautiful.tooltip_gap / 2,
        color = "#FF000000",
        widget = wibox.container.margin,
    })

    return boxed_widget
end

-- Music
local music_text = wibox.widget({
    markup = helpers.colorize_text("Nothing Playing", beautiful.xcolor8),
    font = "sans medium 8",
    valign = "center",
    widget = wibox.widget.textbox,
})

local music_art = wibox.widget({
    image = gears.filesystem.get_configuration_dir() .. "icons/pngegg.png",
    resize = true,
    opacity = 0.2,
    halign = "center",
    valign = "center",
    widget = wibox.widget.imagebox,
})

local music_art_container = wibox.widget({
    music_art,
    forced_height = dpi(120),
    forced_width = dpi(120),
    widget = wibox.container.background,
})

local filter_color = {
    type = "linear",
    from = { 0, 0 },
    to = { 0, 250 },
    stops = { { 0, beautiful.dash_box_bg .. "11" }, { 1, beautiful.dash_box_bg } },
}

local music_art_filter = wibox.widget({
    {
        bg = filter_color,
        forced_height = dpi(120),
        forced_width = dpi(120),
        widget = wibox.container.background,
    },
    direction = "east",
    widget = wibox.container.rotate,
})

local music_title = wibox.widget({
    markup = "No Title",
    font = "sans medium 10",
    valign = "center",
    widget = wibox.widget.textbox,
})

local music_artist = wibox.widget({
    markup = helpers.colorize_text("No Artist", beautiful.xcolor8),
    font = "sans medium 8",
    valign = "center",
    widget = wibox.widget.textbox,
})

local music_status = wibox.widget({
    font = "Font Awesome 6 Pro Solid 11",
    markup = "",
    align = "right",
    valign = "bottom",
    widget = wibox.widget.textbox,
})

local music_pos = wibox.widget({
    font = "sans medium 9",
    markup = helpers.colorize_text("- / -", x.foreground),
    valign = "center",
    widget = wibox.widget.textbox,
})

local music = wibox.widget({
    {
        music_art_container,
        music_art_filter,
        layout = wibox.layout.stack,
    },
    {
        {
            {
                music_text,
                {
                    step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
                    speed = 50,
                    {
                        widget = music_title,
                    },
                    -- forced_width = dpi(110),
                    widget = wibox.container.scroll.horizontal,
                },
                {
                    step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
                    speed = 50,
                    {
                        widget = music_artist,
                    },
                    -- forced_width = dpi(110),
                    widget = wibox.container.scroll.horizontal,
                },
                layout = wibox.layout.fixed.vertical,
            },
            nil,
            {
                music_pos,
                nil,
                music_status,
                layout = wibox.layout.align.horizontal,
            },
            layout = wibox.layout.align.vertical,
        },
        margins = beautiful.tooltip_box_margin,
        widget = wibox.container.margin,
    },
    layout = wibox.layout.stack,
})

local playerctl = require("lib.bling").signal.playerctl.lib()
playerctl:connect_signal("metadata", function(_, title, artist, album_path, __, ___, ____)
    if title == "" then
        title = "No Title"
    end
    if artist == "" then
        artist = "No Artist"
    end
    if album_path == "" then
        album_path = gears.filesystem.get_configuration_dir() .. "icons/no_music.png"
    end

    music_art:set_image(gears.surface.load_uncached(album_path))
    music_title:set_markup_silently(title)
    music_artist:set_markup_silently(helpers.colorize_text(artist, beautiful.xcolor8))
end)

playerctl:connect_signal("playback_status", function(_, playing, __)
    if playing then
        music_text:set_markup_silently(helpers.colorize_text("Now Playing", beautiful.xcolor8))
        music_status:set_markup_silently(" ")
    else
        music_text:set_markup_silently(helpers.colorize_text("Music", beautiful.xcolor8))
        music_status:set_markup_silently("")
    end
end)

playerctl:connect_signal("position", function(pos, length)
    if player_name == "mpd" then
        local pos_now = tostring(os.date("!%M:%S", math.floor(interval_sec)))
        local pos_length = tostring(os.date("!%M:%S", math.floor(length_sec)))
        local pos_markup = pos_now .. helpers.colorize_text(" / " .. pos_length, beautiful.xcolor8)
        music_pos:set_markup_silently(pos_markup)
    end
end)

local music_boxed = create_boxed_widget(music, dpi(220), dpi(170))
-- Item placement

sidebar:setup({
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

                helpers.vertical_pad(dpi(20)),
                layout = wibox.layout.fixed.vertical,
            },
            layout = wibox.layout.fixed.vertical,
        },
        { ----------- MIDDLE GROUP -----------
            {
                helpers.vertical_pad(dpi(30)),
                weather,
                helpers.vertical_pad(dpi(30)),
                {
                    {
                        mpd_buttons,
                        mpd_song,
                        spacing = dpi(5),
                        layout = wibox.layout.fixed.vertical,
                    },
                    bottom = dpi(30),
                    left = dpi(20),
                    right = dpi(20),
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
                bottom = dpi(10),
                widget = wibox.container.margin,
            },
            bg = x.background,
            widget = wibox.container.background,
        },
        layout = wibox.layout.align.vertical,
    },
    shape = helpers.prrect(beautiful.sidebar_border_radius, false, true, false, false),
    bg = "#2b313c",
    widget = wibox.container.background,
})
