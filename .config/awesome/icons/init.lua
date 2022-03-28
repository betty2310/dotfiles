local gears = require "gears"

local function file_exists(path)
    -- Try to open it
    local f = io.open(path)
    if f then
        f:close()
        return true
    end
    return false
end

local icons = {}
icons.image = {}
icons.text = {}

-- TODO Set up weather text icons here instead of in ../widget/text_weather.lua
-- icons.text.weather = {}

-- Set up text symbols and accent colors to be used in tasklists or docks
-- instead of awful.widget.clienticon
-- Based on the client's `class` property
-- TODO Ability to match using rules instead of just class
icons.text.by_class = {
    -- Terminals
    ["kitty"] = { symbol = "", color = x.color5 },
    ["Alacritty"] = { symbol = "", color = x.color5 },
    ["Termite"] = { symbol = "", color = x.color5 },
    ["URxvt"] = { symbol = "", color = x.color5 },
    ["St"] = { symbol = "", color = x.color5 },
    ["St-256color"] = { symbol = "", color = x.color5 },
    ["float"] = { symbol = "", color = x.color5 },

    -- Image viewers
    ["feh"] = { symbol = "", color = x.color6 },
    ["Sxiv"] = { symbol = "", color = x.color5 },

    -- General
    ["TelegramDesktop"] = { symbol = "", color = x.color4 },
    ["Firefox"] = { symbol = "", color = x.foreground .. "99" },
    ["firefox"] = { symbol = "", color = x.foreground },
    ["notion-app-enhanced"] = { symbol = "", color = x.foreground },
    ["Nightly"] = { symbol = "", color = x.color4 },
    ["Google-chrome"] = { symbol = "", color = x.color1 },
    ["Steam"] = { symbol = "", color = x.color6 },
    ["Lutris"] = { symbol = "", color = x.color6 },
    ["editor"] = { symbol = "V", color = x.color2 },
    ["Emacs"] = { symbol = "", color = x.color2 },
    ["email"] = { symbol = "", color = x.color3 },
    ["music"] = { symbol = "", color = x.color2 },
    ["mpv"] = { symbol = "", color = x.color9 },
    ["vlc"] = { symbol = "", color = x.color9 },
    ["battop"] = { symbol = "", color = x.color3 },
    ["wisdom-tree"] = { symbol = "", color = x.color2 },

    ["Anki"] = { symbol = "", color = x.color6 },
    ["KeePassXC"] = { symbol = "", color = x.color1 },
    ["Gucharmap"] = { symbol = "", color = x.color6 },
    ["Pavucontrol"] = { symbol = "", color = x.color2 },
    ["htop"] = { symbol = "", color = x.color1 },
    ["Screenruler"] = { symbol = "", color = x.color3 },
    ["Galculator"] = { symbol = "", color = x.color2 },
    ["Zathura"] = { symbol = "", color = x.color9 },
    ["Qemu-system-x86_64"] = { symbol = "", color = x.color3 },
    ["Wine"] = { symbol = "", color = x.color1 },
    ["markdown_input"] = { symbol = "", color = x.color2 },
    ["scratchpad"] = { symbol = "", color = x.color11 },
    ["weechat"] = { symbol = "", color = x.foreground },
    ["discord"] = { symbol = "", color = x.color4 },
    ["6cord"] = { symbol = "", color = x.color3 },
    ["libreoffice-writer"] = { symbol = "", color = x.color4 },
    ["libreoffice-calc"] = { symbol = "", color = x.color2 },
    ["libreoffice-impress"] = { symbol = "", color = x.color1 },
    ["Godot"] = { symbol = "", color = x.color4 },
    ["Spotify"] = { symbol = "", color = x.color2 },
    ["Code"] = { symbol = "", color = x.color4 },
    ["Microsoft-edge"] = { symbol = "", color = x.color3 },
    ["pdf"] = { symbol = "", color = x.color9 },
    ["Microsoft Teams - Preview"] = { symbol = "", color = x.color1 },
    ["Font-manager"] = { symbol = "", color = x.color9 },
    ["Solaar"] = { symbol = "", color = x.color9 },
    ["Pamac-manager"] = { symbol = "", color = x.color2 },
    ["Baobab"] = { symbol = "", color = x.foreground .. "99" },
    ["qBittorrent"] = { symbol = "", color = x.color1 },
    ["WebTorrent"] = { symbol = "", color = x.color1 },
    ["Blueman-manager"] = { symbol = "", color = x.color6 },
    ["Visualizer"] = { symbol = "", color = x.color2 },
    ["Typora"] = { symbol = "", color = x.color3 },
    -- File managers
    ["Thunar"] = { symbol = "", color = x.color3 },
    ["Org.gnome.Nautilus"] = { symbol = "", color = x.color3 },
    ["Nemo"] = { symbol = "", color = x.color3 },
    ["files"] = { symbol = "", color = x.color3 },

    ["Gimp-2.10"] = { symbol = "", color = x.color3 },
    ["Inkscape"] = { symbol = "", color = x.color2 },
    ["Gpick"] = { symbol = "", color = x.color6 },
    ["sensors"] = { symbol = "", color = x.color1 },
    ["et"] = { symbol = "", color = x.color2 },
    ["copyq"] = { symbol = "", color = x.color2 },
    ["obsidian"] = { symbol = "", color = x.color13 },
    ["Mars"] = { symbol = "", color = x.color11 },

    -- Default
    ["_"] = { symbol = "", color = x.color4 },
}

-- Available icons
local image_icon_names = {
    "playerctl_toggle",
    "playerctl_prev",
    "playerctl_next",
    "stats",
    "search",
    "volume",
    "muted",
    "pop",
    "firefox",
    "youtube",
    "reddit",
    "discord",
    "telegram",
    "steam",
    "games",
    "files",
    "manual",
    "nightmode",
    "keyboard",
    "appearance",
    "editor",
    "redshift",
    "gimp",
    "terminal",
    "mail",
    "music",
    "cat4",
    "temperature",
    "battery",
    "battery_charging",
    "cpu",
    "compositor",
    "start",
    "ram",
    "screenshot",
    "home",
    "alarm",
    "alarm_off",
    "alert",
    "submenu",
    -- Weather icons
    "cloud",
    "dcloud",
    "ncloud",
    "sun",
    "star",
    "rain",
    "snow",
    "mist",
    "storm",
    "whatever",
    -- Exit screen icons
    "exit",
    "poweroff",
    "reboot",
    "suspend",
    "lock",
    "medium",
    "high",
    "max",
    "low",
}

-- Path to icons
local p

-- Assumes all the icon files end in .png
-- TODO maybe automatically detect icons in icon theme directory
local function set_image_icon(icon_name)
    local i = p .. icon_name .. ".png"
    icons.image[icon_name] = i
end

-- Set all the icon variables
function icons.init()
    p = gears.filesystem.get_configuration_dir() .. "icons/"

    for i = 1, #image_icon_names do
        set_image_icon(image_icon_names[i])
    end

    -- Set symbols and accent colors for text icons
end

return icons
