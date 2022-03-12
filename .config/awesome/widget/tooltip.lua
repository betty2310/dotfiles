local gears = require "gears"
local awful = require "awful"
local beautiful = require "beautiful"
local wibox = require "wibox"
local rubato = require "lib.rubato"
local helpers = require "helpers"

-- Get screen geometry
local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height

-- Tooltip
------------

local function create_boxed_widget(widget_to_be_boxed, width, height, inner_pad)
    local box_container = wibox.container.background()
    box_container.bg = x.background
    box_container.forced_height = height
    box_container.forced_width = width
    box_container.shape = helpers.rrect(beautiful.tooltip_box_border_radius)

    local inner = dpi(0)

    if inner_pad then
        inner = beautiful.tooltip_box_margin
    end

    local boxed_widget = wibox.widget {
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
    }

    return boxed_widget
end

---- Stats

-- Wifi
local wifi_text = wibox.widget {
    markup = helpers.colorize_text("WiFi", beautiful.xcolor8),
    font = beautiful.font_name .. "8",
    widget = wibox.widget.textbox,
}

local wifi_ssid = wibox.widget {
    markup = helpers.colorize_text("Off", beautiful.xcolor8),
    font = beautiful.font_name .. "bold 10",
    valign = "bottom",
    widget = wibox.widget.textbox,
}

local wifi = wibox.widget {
    wifi_text,
    nil,
    wifi_ssid,
    layout = wibox.layout.align.vertical,
}

awesome.connect_signal("signal::network", function(status, ssid)
    wifi_ssid.markup = ssid
end)

-- Battery
local batt_text = wibox.widget {
    markup = helpers.colorize_text("Battery", x.foreground),
    font = beautiful.font_name .. "8",
    valign = "center",
    widget = wibox.widget.textbox,
}

local batt_perc = wibox.widget {
    markup = "N/A",
    font = beautiful.font_name .. "bold 10",
    valign = "center",
    widget = wibox.widget.textbox,
}

local batt_bar = wibox.widget {
    max_value = 100,
    value = 20,
    background_color = beautiful.transparent,
    color = x.color0,
    widget = wibox.widget.progressbar,
}

local batt = wibox.widget {
    batt_bar,
    {
        {
            batt_text,
            nil,
            batt_perc,
            -- spacing = dpi(5),
            layout = wibox.layout.align.vertical,
        },
        margins = beautiful.tooltip_box_margin,
        widget = wibox.container.margin,
    },
    layout = wibox.layout.stack,
}

local batt_val = 0
local batt_charger

awesome.connect_signal("signal::battery", function(value)
    batt_val = value
    awesome.emit_signal "widget::battery"
end)

awesome.connect_signal("signal::charger", function(state)
    batt_charger = state
    awesome.emit_signal "widget::battery"
end)

awesome.connect_signal("widget::battery", function()
    local b = batt_val
    local fill_color = x.color2

    if batt_charger then
        fill_color = x.color4
    else
        if batt_val <= 15 then
            fill_color = x.color1
        end
    end

    batt_perc.markup = b .. "%"
    batt_bar.value = b
    batt_bar.color = fill_color
end)

-- Music
local music_text = wibox.widget {
    markup = helpers.colorize_text("Nothing Playing", beautiful.xcolor8),
    font = "sans medium 8",
    valign = "center",
    widget = wibox.widget.textbox,
}

local music_art = wibox.widget {
    image = gears.filesystem.get_configuration_dir() .. "icons/no_music.png",
    resize = true,
    opacity = 0.2,
    halign = "center",
    valign = "center",
    widget = wibox.widget.imagebox,
}

local music_title = wibox.widget {
    markup = "No Title",
    font = "sans medium 10",
    valign = "center",
    widget = wibox.widget.textbox,
}

local music_artist = wibox.widget {
    markup = helpers.colorize_text("No Artist", beautiful.xcolor8),
    font = "sans medium 8",
    valign = "center",
    widget = wibox.widget.textbox,
}

local music_status = wibox.widget {
    font = "Font Awesome 6 Pro Solid 11",
    markup = "",
    align = "right",
    valign = "bottom",
    widget = wibox.widget.textbox,
}

local music_volume_icon = wibox.widget {
    markup = "",
    font = beautiful.icon_font_name .. "Round 12",
    valign = "bottom",
    widget = wibox.widget.textbox,
}

local music_volume_perc = wibox.widget {
    markup = helpers.colorize_text("N/A", beautiful.xcolor8),
    font = beautiful.font_name .. "bold 10",
    valign = "bottom",
    widget = wibox.widget.textbox,
}

local music_volume = wibox.widget {
    music_volume_icon,
    music_volume_perc,
    spacing = dpi(2),
    layout = wibox.layout.fixed.horizontal,
}

local music = wibox.widget {
    music_art,
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
                music_volume,
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
}

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
        music_status:set_markup_silently " "
    else
        music_text:set_markup_silently(helpers.colorize_text("Music", beautiful.xcolor8))
        music_status:set_markup_silently ""
    end
end)

awesome.connect_signal("signal::volume", function(value, muted)
    local v = value or 0

    if muted then
        v = "Muted"
    end

    music_volume_perc.markup = v
end)

local wifi_boxed = create_boxed_widget(wifi, dpi(110), dpi(50), true)
local batt_boxed = create_boxed_widget(batt, dpi(110), dpi(50))
local music_boxed = create_boxed_widget(music, dpi(110), dpi(110))

-- Stats
stats_tooltip = wibox {
    type = "dock",
    screen = screen.primary,
    height = dpi(150),
    width = dpi(270),
    shape = helpers.rrect(beautiful.tooltip_border_radius - 1),
    bg = beautiful.transparent,
    ontop = true,
    visible = false,
}

awful.placement.bottom_right(
    stats_tooltip,
    { honor_workarea = true, margins = { right = beautiful.useless_gap * 2, bottom = dpi(70) } }
)

stats_tooltip_show = function()
    stats_tooltip.visible = true
end

stats_tooltip_hide = function()
    stats_tooltip.visible = false
end

stats_tooltip_toggle = function()
    if stats_tooltip.visible == false then
        stats_tooltip.visible = true
    else
        stats_tooltip.visible = false
    end
end
stats_tooltip:setup {
    {
        {
            {
                wifi_boxed,
                batt_boxed,
                layout = wibox.layout.fixed.vertical,
            },
            music_boxed,
            layout = wibox.layout.fixed.horizontal,
        },
        margins = beautiful.tooltip_margin,
        widget = wibox.container.margin,
    },
    shape = helpers.rrect(beautiful.tooltip_border_radius),
    bg = "#262b33",
    widget = wibox.container.background,
}
