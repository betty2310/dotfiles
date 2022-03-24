local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"
local apps = require "apps"

local helpers = require "helpers"
local bling = require "lib.bling"
local rubato = require "lib.rubato"

local function create_boxed_widget(widget_to_be_boxed, width, height, inner_pad)
    local box_container = wibox.container.background()
    box_container.bg = "#2e3440"
    box_container.forced_height = height
    box_container.forced_width = width
    box_container.shape = helpers.rrect(dpi(12))

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

-- Music
local music_text = wibox.widget {
    markup = helpers.colorize_text("Nothing Playing", beautiful.xcolor8),
    font = "sans medium 8",
    valign = "center",
    widget = wibox.widget.textbox,
}

local music_art = wibox.widget {
    image = gears.color.recolor_image(os.getenv "HOME" .. "/.config/awesome/icons/no-notifs.png", x.foreground),

    resize = true,
    opacity = 0.2,
    halign = "center",
    valign = "center",
    widget = wibox.widget.imagebox,
}

local music_art_container = wibox.widget {
    music_art,
    forced_height = dpi(200),
    forced_width = dpi(200),
    widget = wibox.container.background,
}

local filter_color = {
    type = "linear",
    from = { 0, 0 },
    to = { 0, 300 },
    stops = { { 0, beautiful.dash_box_bg .. "10" }, { 1, beautiful.dash_box_bg } },
}

local music_art_filter = wibox.widget {
    {
        bg = filter_color,
        forced_height = dpi(200),
        forced_width = dpi(200),
        widget = wibox.container.background,
    },
    direction = "east",
    widget = wibox.container.rotate,
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
    markup = "",
    align = "right",
    valign = "bottom",
    widget = wibox.widget.textbox,
}

local playerctl = require("lib.bling").signal.playerctl.lib()

local music_pos = wibox.widget {
    font = "sans medium 9",
    markup = helpers.colorize_text("- / -", x.foreground),
    valign = "center",
    widget = wibox.widget.textbox,
}
local slider = wibox.widget {
    forced_height = dpi(3),
    bar_shape = helpers.rrect(beautiful.border_radius),
    shape = helpers.rrect(beautiful.border_radius),
    background_color = x.color0,
    color = x.color1,
    value = 50,
    max_value = 100,
    widget = wibox.widget.progressbar,
}

playerctl:connect_signal("position", function(pos, length, _)
    slider.value = (pos / length) * 100
end)

local music = wibox.widget {
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
                music_status,
                helpers.vertical_pad(dpi(15)),
                slider,
                layout = wibox.layout.align.vertical,
            },
            layout = wibox.layout.align.vertical,
        },
        margins = beautiful.tooltip_box_margin,
        widget = wibox.container.margin,
    },
    layout = wibox.layout.stack,
}

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
        music_text:set_markup_silently(helpers.colorize_text("Pause", beautiful.xcolor8))
        music_status:set_markup_silently ""
    end
end)

playerctl:connect_signal("position", function(pos, length, _)
    -- if player_name == "mpd" then
    local pos_now = tostring(os.date("!%M:%S", math.floor(pos)))
    local pos_length = tostring(os.date("!%M:%S", math.floor(length)))
    local pos_markup = helpers.colorize_text(pos_now .. " / " .. pos_length, x.color8)
    music_pos:set_markup_silently(pos_markup)
    -- end
end)

local music_boxed = create_boxed_widget(music, dpi(220), dpi(170))

local play_command = function()
    playerctl:play_pause()
end
music_status:buttons(gears.table.join(awful.button({}, 1, function()
    play_command()
end)))

helpers.add_hover_cursor(music_status, "hand1")
return music_boxed
