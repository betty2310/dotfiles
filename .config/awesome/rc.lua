user = {
    terminal = "st",
    floating_terminal = "st",
    browser = "google-chrome-stable",
    file_manager = "st -c files -e ranger",
    editor = "st -c editor -e nvim",
    email_client = "st -c email -e neomutt",
    music_client = "st -c music -e ncmpcpp",
    web_search_cmd = "https://www.google.com/search?q=",
    profile_picture = os.getenv("HOME") .. "/.config/awesome/profile.png",
    dirs = {
        downloads = os.getenv("XDG_DOWNLOAD_DIR") or "~/Downloads",
        documents = os.getenv("XDG_DOCUMENTS_DIR") or "~/Documents",
        music = os.getenv("XDG_MUSIC_DIR") or "~/Music",
        pictures = os.getenv("XDG_PICTURES_DIR") or "~/Pictures",
        videos = os.getenv("XDG_VIDEOS_DIR") or "~/Videos",
        screenshots = "~/Pictures/Screenshots",
    },
    sidebar = {
        hide_on_mouse_leave = true,
        show_on_mouse_screen_edge = true,
    },
    lock_screen_custom_password = "1",
    battery_threshold_low = 20,
    battery_threshold_critical = 5,
    openweathermap_key = "d823d048acbbb25d8ab24c2d16e6de9c",
    openweathermap_city_id = "1573517",
    weather_units = "metric",
    coronavirus_country = "vietnam",
}
local beautiful = require("beautiful")
local xrdb = beautiful.xresources.get_current_theme()
dpi = beautiful.xresources.apply_dpi
x = {
    background = xrdb.background,
    foreground = xrdb.foreground,
    color0 = xrdb.color0,
    color1 = xrdb.color1,
    color2 = xrdb.color2,
    color3 = xrdb.color3,
    color4 = xrdb.color4,
    color5 = xrdb.color5,
    color6 = xrdb.color6,
    color7 = xrdb.color7,
    color8 = xrdb.color8,
    color9 = xrdb.color9,
    color10 = xrdb.color10,
    color11 = xrdb.color11,
    color12 = xrdb.color12,
    color13 = xrdb.color13,
    color14 = xrdb.color14,
    color15 = xrdb.color15,
}

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local naughty = require("naughty")

local theme_dir = os.getenv("HOME") .. "/.config/awesome/themes/"
beautiful.init(theme_dir .. "theme.lua")

local bling = require("lib.bling")
local rubato = require("lib.rubato")
require("lib.better_resize")

bling.module.flash_focus.enable()

naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification({
        urgency = "critical",
        title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
        message = message,
    })
end)

local icons = require("icons")
icons.init()
local keys = require("keys")
local notifications = require("notifications")
notifications.init()
local decorations = require("components.titlebar")
decorations.init()
local helpers = require("helpers")

F = {}
require("components.bar")
require("components.exit")
require("components.sidebar")
require("components.dashboard")
require("components.notif_center.action")
local lock_screen = require("components.lock_screen")
lock_screen.init()
-- require "components.app_drawer"
require("components.microphone_overlay")
require("signal")

screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height

awful.layout.layouts = {
    bling.layout.mstab,
    bling.layout.deck,
    bling.layout.centered,
    bling.layout.equalarea,
    awful.layout.suit.max,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}

-- Tags
awful.screen.connect_for_each_screen(function(s)
    local l = awful.layout.suit
    local layouts = {
        bling.layout.equalarea,
        bling.layout.deck,
        l.max,
        l.spiral.dwindle,
        bling.layout.mstab,
        l.spiral.dwindle,
        l.max,
    }

    local tagnames = beautiful.tagnames
    awful.tag(tagnames, s, layouts)
end)

local floating_client_placement = function(c)
    if awful.layout.get(mouse.screen) ~= awful.layout.suit.floating or #mouse.screen.clients == 1 then
        return awful.placement.centered(c, { honor_padding = true, honor_workarea = true })
    end
    local p = awful.placement.no_overlap + awful.placement.no_offscreen
    return p(c, { honor_padding = true, honor_workarea = true, margins = beautiful.useless_gap * 2 })
end

local centered_client_placement = function(c)
    return gears.timer.delayed_call(function()
        awful.placement.centered(c, { honor_padding = true, honor_workarea = true })
    end)
end

-- Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = keys.clientkeys,
            buttons = keys.clientbuttons,
            screen = awful.screen.preferred,
            screen = awful.screen.focused,
            size_hints_honor = false,
            honor_workarea = true,
            honor_padding = true,
            maximized = false,
            -- titlebars_enabled = beautiful.titlebars_enabled,
            maximized_horizontal = false,
            maximized_vertical = false,
            placement = floating_client_placement,
        },
    },

    -- Floating clients
    {
        rule_any = {
            instance = {
                "DTA", -- Firefox addon DownThemAll.
                "floating_terminal",
                "riotclientux.exe",
                "leagueclientux.exe",
                "Devtools", -- Firefox devtools
            },
            class = {
                "Gpick",
                "Lxappearance",
                "Nm-connection-editor",
                "File-roller",
                "fst",
                "Font-manager",
                "Solaar",
                "Spotify",
                "Nvidia-settings",
            },
            name = {
                "Event Tester", -- xev
                "MetaMask Notification",
            },
            role = {
                "AlarmWindow",
                "pop-up",
                "GtkFileChooserDialog",
                "conversation",
            },
            type = {
                "dialog",
            },
        },
        properties = { floating = true, titlebars_enabled = false },
    },

    -- Fullscreen clients
    {
        rule_any = {
            class = {
                "lt-love",
                "portal2_linux",
                "csgo_linux64",
                "EtG.x86_64",
                "factorio",
                "dota2",
                "Terraria.bin.x86",
                "dontstarve_steam",
            },
            instance = {
                "synthetik.exe",
            },
        },
        properties = { fullscreen = true },
    },

    -- Centered clients
    {
        rule_any = {
            type = {
                "dialog",
            },
            class = {
                "Steam",
                "discord",
                "music",
                "markdown_input",
                "scratchpad",
                "copyq",
                "wisdom-tree",
            },
            instance = {
                "music",
                "markdown_input",
                "scratchpad",
                "wisdom-tree",
            },
            role = {
                "GtkFileChooserDialog",
                "conversation",
            },
        },
        properties = { placement = centered_client_placement },
    },

    -- Titlebars ON (explicitly)
    {
        rule_any = {
            type = {
                -- "dialog",
            },
            role = {
                -- "conversation",
            },
        },
        callback = function(c)
            decorations.show(c)
        end,
    },

    -- Fixed terminal geometry for floating terminals
    {
        rule_any = {
            class = {
                "Alacritty",
                "Termite",
                "mpvtube",
                "kitty",
                "st-256color",
                "st",
                "URxvt",
                "float",
            },
        },
        properties = { width = screen_width * 0.45, height = screen_height * 0.5, titlebars_enabled = false },
    },

    -- Visualizer
    {
        rule_any = { class = { "Visualizer" } },
        properties = {
            floating = true,
            maximized_horizontal = true,
            sticky = true,
            ontop = false,
            skip_taskbar = true,
            below = true,
            focusable = false,
            height = screen_height * 0.40,
            opacity = 0.6,
            titlebars_enabled = false,
        },
        callback = function(c)
            awful.placement.bottom(c)
        end,
    },

    -- File chooser dialog
    {
        rule_any = { role = { "GtkFileChooserDialog" } },
        properties = { floating = true, width = screen_width * 0.55, height = screen_height * 0.65 },
    },

    -- Pavucontrol
    {
        rule_any = { class = { "Pavucontrol" } },
        properties = { floating = true, width = screen_width * 0.45, height = screen_height * 0.8 },
    },
    -- Zathura
    -- {
    --     rule_any = { class = { "Zathura" } },
    --     properties = { floating = true, width = screen_width * 0.5, height = screen_height * 0.9 },
    -- },

    -- Galculator
    {
        rule_any = { class = { "Galculator" } },
        except_any = { type = { "dialog" } },
        properties = { floating = true, width = screen_width * 0.2, height = screen_height * 0.4 },
    },

    -- File managers
    {
        rule_any = {
            class = {
                "Nemo",
                "Thunar",
                "files",
                "Org.gnome.Nautilus",
            },
        },
        except_any = {
            type = { "dialog" },
        },
        properties = { floating = true, width = screen_width * 0.55, height = screen_height * 0.60 },
    },

    -- floating_terminal
    {
        rule_any = { class = { "float" } },
        properties = { floating = true, width = screen_width * 0.45, height = screen_height * 0.5 },
    },
    -- Scratchpad
    {
        rule_any = {
            instance = {
                "markdown_input",
            },
            class = {
                "markdown_input",
            },
        },
        properties = {
            skip_taskbar = false,
            floating = true,
            ontop = false,
            minimized = true,
            sticky = false,
            width = screen_width * 0.7,
            height = screen_height * 0.8,
        },
    },

    -- tree pomodoro
    {
        rule_any = {
            instance = {
                "copyq",
                "wisdom-tree",
            },
            class = {
                "copyq",
                "wisdom-tree",
            },
        },
        properties = {
            skip_taskbar = false,
            floating = true,
            ontop = false,
            minimized = true,
            sticky = false,
            width = screen_width * 0.4,
            height = screen_height * 0.5,
        },
    },

    -- Music clients (usually a terminal running ncmpcpp)
    {
        rule_any = {
            class = {
                "SimpleScreenRecorder",
                "music",
            },
            instance = {
                "music",
            },
        },
        properties = {
            floating = true,
            width = screen_width * 0.45,
            height = screen_height * 0.50,
        },
    },
    -- Microsoft Edge
    {
        rule_any = {
            class = {
                "Microsoft-edge",
            },
        },
        properties = {
            screen = 2,
            tag = awful.screen.focused().tags[4],
        },
    },

    -- Microsoft Teams
    {
        rule_any = {
            class = {
                "teams",
            },
            instance = {
                "teams",
            },
        },
        properties = {
            floating = true,
            width = screen_width * 0.7,
            height = screen_height * 0.8,
        },
    },

    -- Image viewers
    {
        rule_any = {
            class = {
                "feh",
                "Sxiv",
            },
        },
        properties = {
            floating = true,
            width = screen_width * 0.7,
            height = screen_height * 0.8,
        },
        callback = function(c)
            awful.placement.centered(c, { honor_padding = true, honor_workarea = true })
        end,
    },

    -- MPV
    {
        rule = { class = "mpv" },
        properties = {},
        callback = function(c)
            c.floating = true
            c.ontop = true
            c.width = screen_width * 0.30
            c.height = screen_height * 0.35
            awful.placement.top_right(c, {
                honor_padding = true,
                honor_workarea = true,
                margins = { top = beautiful.useless_gap * 2, right = beautiful.useless_gap * 2 },
            })
            c:connect_signal("property::fullscreen", function()
                if not c.fullscreen then
                    c.ontop = true
                end
            end)
        end,
    },

    -- Anki
    {
        rule = { class = "Anki" },
        properties = {},
        callback = function(c)
            c.opacity = 0.9
        end,
    },

    {
        rule_any = {
            instance = {
                "synthetik.exe",
            },
        },
        properties = {},
        callback = function(c)
            -- Unminimize automatically
            c:connect_signal("property::minimized", function()
                if c.minimized then
                    c.minimized = false
                end
            end)
        end,
    },

    -- League of Legends client QoL fixes
    {
        rule = { instance = "league of legends.exe" },
        properties = {},
        callback = function(c)
            local matcher = function(c)
                return awful.rules.match(c, { instance = "leagueclientux.exe" })
            end
            -- Minimize LoL client after game window opens
            for c in awful.client.iterate(matcher) do
                c.urgent = false
                c.minimized = true
            end

            -- Unminimize LoL client after game window closes
            c:connect_signal("unmanage", function()
                for c in awful.client.iterate(matcher) do
                    c.minimized = false
                end
            end)
        end,
    },

    ---------------------------------------------
    -- Start application on specific workspace --
    ---------------------------------------------
    --

    -- Code
    {
        rule_any = {
            class = {
                "Code",
                "scratchpad",
            },
        },
        except_any = {
            role = { "GtkFileChooserDialog" },
            instance = { "Toolkit" },
            type = { "dialog" },
        },
        properties = {
            screen = 1,
            --tag = awful.screen.focused().tags[3]
        },
    },
    -- Browsing
    {
        rule_any = {
            class = {
                "qutebrowser",
                "Google-chrome",
            },
        },
        except_any = {
            role = { "GtkFileChooserDialog" },
            instance = { "Toolkit" },
            type = { "dialog" },
        },
        properties = {
            screen = 1,
            -- tag = awful.screen.focused().tags[1]
        },
    },
    -- Google Picture-in-Picture
    {
        rule = { name = "Picture in picture" },
        properties = {},
        callback = function(c)
            -- Make it floating, sticky and move it out of the way if the current tag is maximized
            c.floating = true
            c.sticky = true
            c.width = screen_width * 0.30
            c.height = screen_height * 0.35
            awful.placement.bottom_right(c, {
                honor_padding = true,
                honor_workarea = true,
                margins = { bottom = beautiful.useless_gap * 2, right = beautiful.useless_gap * 2 },
            })
            c:connect_signal("property::fullscreen", function()
                if not c.fullscreen then
                    c.sticky = true
                end
            end)
        end,
    },

    -- Term
    {
        rule_any = {
            class = {
                "Anki",
                "wisdom-tree",
            },
            instance = {
                "leagueclient.exe",
                "glyphclientapp.exe",
                "wisdom-tree",
            },
        },
        properties = {
            screen = 1,
            tag = awful.screen.focused().tags[2],
        },
    },
    -- Docs
    {
        rule_any = {
            class = {
                "firefox",
                "Zathura",
                "gotop",
            },
            instance = {
                "btop",
            },
        },
        properties = {
            screen = 1,
            -- tag = awful.screen.focused().tags[4]
        },
    },

    -- Chatting
    {
        rule_any = {
            class = {
                "teams",
                "SimpleScreenRecorder",
                "discord",
                "TelegramDesktop",
                "Slack",
                "zoom",
            },
        },
        properties = { screen = 1, tag = awful.screen.focused().tags[5] },
    },
    -- System monitoring
    {
        rule_any = {
            class = {
                "btop",
                "battop",
                "gotop",
            },
            instance = {
                "btop",
            },
        },
        properties = { screen = 1, tag = awful.screen.focused().tags[6] },
    },

    -- Mail
    {
        rule_any = {
            class = {
                "email",
                "Thunderbird",
            },
            instance = {
                "email",
                "Thunderbird",
            },
        },
        properties = { screen = 1, tag = awful.screen.focused().tags[5] },
    },

    -- Game clients/launchers
    {
        rule_any = {
            class = {
                "Steam",
                "battle.net.exe",
                "Lutris",
            },
            name = {
                "Steam",
            },
        },
        properties = { screen = 1, tag = awful.screen.focused().tags[7] },
    },

    -- All clients that I want out of my way when they are running
    {
        rule_any = {
            class = {
                "torrent",
            },
            instance = {
                "torrent",
                "qemu",
            },
        },
        except_any = {
            type = { "dialog" },
        },
        properties = { screen = 2, tag = awful.screen.focused().tags[7] },
    },
}
-- (Rules end here) ..................................................

client.connect_signal("manage", function(c)
    if not awesome.startup then
        awful.client.setslave(c)
    end
end)

client.connect_signal("manage", function(c)
    if c.fullscreen then
        gears.timer.delayed_call(function()
            if c.valid then
                c:geometry(c.screen.geometry)
            end
        end)
    end
end)

if beautiful.border_width > 0 then
    client.connect_signal("focus", function(c)
        c.border_color = beautiful.border_focus
    end)
    client.connect_signal("unfocus", function(c)
        c.border_color = beautiful.border_normal
    end)
end

-- Set mouse resize mode (live or after)
awful.mouse.resize.set_mode("live")

tag.connect_signal("property::layout", function(t)
    for k, c in ipairs(t:clients()) do
        if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
            local cgeo = awful.client.property.get(c, "floating_geometry")
            if cgeo then
                c:geometry(awful.client.property.get(c, "floating_geometry"))
            end
        end
    end
end)

client.connect_signal("manage", function(c)
    if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
        awful.client.property.set(c, "floating_geometry", c:geometry())
    end
end)

client.connect_signal("property::geometry", function(c)
    if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
        awful.client.property.set(c, "floating_geometry", c:geometry())
    end
end)

awful.tag.attached_connect_signal(s, "property::selected", function()
    local urgent_clients = function(c)
        return awful.rules.match(c, { urgent = true })
    end
    for c in awful.client.iterate(urgent_clients) do
        if c.first_tag == mouse.screen.selected_tag then
            client.focus = c
        end
    end
end)

-- Raise focused clients automatically
client.connect_signal("focus", function(c)
    c:raise()
end)

client.connect_signal("property::floating", function(c)
    if c.floating then
        if c.restore_ontop then
            c.ontop = c.restore_ontop
        end
    else
        c.restore_ontop = c.ontop
        c.ontop = false
    end
end)

local dashboard_flag_path = "/tmp/awesomewm-show-dashboard"
awful.spawn.easy_async_with_shell("stat " .. dashboard_flag_path .. " >/dev/null 2>&1", function(_, __, ___, exitcode)
    if exitcode == 0 then
        if dashboard_show then
            dashboard_show()
        end
        awful.spawn.with_shell("rm " .. dashboard_flag_path)
    end
end)

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

-- focus by mouse hover
-- client.connect_signal("mouse::enter", function(c)
--     if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
--         client.focus = c
--     end
-- end)
