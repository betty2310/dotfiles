local awful = require "awful"
local wibox = require "wibox"
local gears = require "gears"
local theme_name = "amarena"
local theme_assets = require "beautiful.theme_assets"
local xresources = require "beautiful.xresources"
local dpi = xresources.apply_dpi
local gfs = require "gears.filesystem"
local themes_path = gfs.get_themes_dir()
local layout_icon_path = os.getenv "HOME" .. "/.config/awesome/themes//layout/"
local titlebar_icon_path = os.getenv "HOME" .. "/.config/awesome/themes/titlebar/"
local taglist_icon_path = os.getenv "HOME" .. "/.config/awesome/themes/taglist/"

local tip = titlebar_icon_path --alias to save time/space
local xrdb = xresources.get_current_theme()
local theme = {}

theme.xbackground = xrdb.background
theme.xforeground = xrdb.foreground
theme.xcolor0 = xrdb.color0
theme.xcolor1 = xrdb.color1
theme.xcolor2 = xrdb.color2
theme.xcolor3 = xrdb.color3
theme.xcolor4 = xrdb.color4
theme.xcolor5 = xrdb.color5
theme.xcolor6 = xrdb.color6
theme.xcolor7 = xrdb.color7
theme.xcolor8 = xrdb.foreground
theme.xcolor9 = xrdb.color9
theme.xcolor10 = xrdb.color10
theme.xcolor11 = xrdb.color11
theme.xcolor12 = xrdb.color12
theme.xcolor13 = xrdb.color13
theme.xcolor14 = xrdb.color14
theme.xcolor15 = xrdb.color15
theme.darker = "#232731"

theme.dash_box_bg = "#313744"

theme.transparent = "#00000000"
theme.wallpaper = os.getenv "HOME" .. "/Pictures/bg.jpg"
theme.font = "monospace medium 8"
theme.font_name = "SF Pro Display "
theme.icon_font_name = "Material Icons "

theme.bg_dark = x.background
theme.bg_normal = x.background
theme.bg_focus = "#262b33"
theme.bg_urgent = x.color8
theme.bg_minimize = x.color8
theme.bg_systray = x.background
theme.fg_normal = x.foreground
theme.fg_focus = x.color2
theme.fg_urgent = x.color9
theme.fg_minimize = x.color8
-- Tooltip
theme.tooltip_height = dpi(490)
theme.tooltip_width = dpi(310)
theme.tooltip_bg = theme.xbackground
theme.tooltip_box_bg = theme.bg_secondary
theme.tooltip_fg = x.foreground
theme.tooltip_box_fg = theme.xcolor8
theme.tooltip_margin = dpi(15)
theme.tooltip_box_margin = dpi(10)
theme.tooltip_gap = dpi(10)
theme.tooltip_border_radius = dpi(6)
theme.tooltip_box_border_radius = dpi(5)
theme.tooltip_border_width = dpi(0)
theme.tooltip_border_color = theme.xcolor0

-- Gaps
theme.useless_gap = dpi(5)
theme.screen_margin = dpi(5)

theme.border_width = dpi(0)
theme.border_normal = x.background
theme.border_focus = x.background
theme.border_radius = dpi(6)
theme.border_radius_tray = dpi(6)

-- Titlebars
theme.titlebars_enabled = true
theme.titlebar_size = dpi(30)
theme.titlebar_title_enabled = false
theme.titlebar_font = "monospace bold 9"
-- Window title alignment: left, right, center
theme.titlebar_title_align = "center"
-- Titlebar position: top, bottom, left, right
theme.titlebar_position = "top"
theme.titlebar_bg = x.background
-- theme.titlebar_bg_focus = x.color12
-- theme.titlebar_bg_normal = x.color8
theme.titlebar_fg_focus = x.foreground
theme.titlebar_fg_normal = x.color8
--theme.titlebar_fg = x.color7

-- Notifications
theme.notification_icon = gears.surface.load_uncached(gfs.get_configuration_dir() .. "icons/cat2.png")
theme.notification_position = "top_right"
theme.notification_border_width = dpi(0)
theme.notification_border_radius = theme.border_radius
theme.notification_border_color = x.color10
theme.notification_bg = x.background
-- theme.notification_bg = x.color8
theme.notification_fg = x.foreground
theme.notification_crit_bg = x.background
theme.notification_crit_fg = x.color1
theme.notification_icon_size = dpi(60)
theme.notification_height = dpi(80)
theme.notification_width = dpi(150)
theme.notification_margin = dpi(16)
theme.notification_opacity = 1
theme.notification_font = "sans 11"
theme.notification_padding = theme.screen_margin * 2
theme.notification_spacing = theme.screen_margin * 4

-- Edge snap
theme.snap_shape = gears.shape.rectangle
theme.snap_bg = x.foreground
theme.snap_border_width = dpi(3)

-- Tag names
theme.tagnames = {
    "DEV",
    "WEB",
    "TERM",
    "DOCS",
    "CHAT",
    "SYS",
    "#",
}

-- Widget separator
theme.separator_text = "|"
--theme.separator_text = " :: "
--theme.separator_text = " • "
-- theme.separator_text = " •• "
theme.separator_fg = x.color8

-- Wibar(s)
-- Keep in mind that these settings could be ignored by the bar theme
theme.wibar_position = "top"
theme.wibar_height = dpi(17)
theme.wibar_bg = "#00000000"
theme.wibar_fg = "#00000000"
theme.wibar_opacity = 0.8
theme.wibar_border_color = x.color0
theme.wibar_border_width = dpi(0)
theme.wibar_border_radius = dpi(10)
theme.wibar_width = dpi(10)

theme.prefix_fg = x.color8

--There are other variable sets
--overriding the default one when
--defined, the sets are:
--taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
--tasklist_[bg|fg]_[focus|urgent]
--titlebar_[bg|fg]_[normal|focus]
--tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
--mouse_finder_[color|timeout|animate_timeout|radius|factor]
--prompt_[fg|bg|fg_cursor|bg_cursor|font]
--hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
--Example:
--theme.taglist_bg_focus = "#ff0000"

theme.hotkeys_description_font = "sans 8"

--Tasklist
theme.tasklist_font = "sans medium 8"
theme.tasklist_disable_icon = true
theme.tasklist_plain_task_name = true
theme.tasklist_bg_focus = x.color4
theme.tasklist_fg_focus = x.background
theme.tasklist_bg_normal = "#00000000"
theme.tasklist_fg_normal = x.foreground .. "77"
theme.tasklist_bg_minimize = "#00000000"
theme.tasklist_fg_minimize = x.color8
-- theme.tasklist_font_minimized = "sans italic 8"
theme.tasklist_bg_urgent = x.background
theme.tasklist_fg_urgent = x.color3
theme.tasklist_spacing = dpi(0)
theme.tasklist_align = "center"

-- Sidebar
-- (Sidebar items can be customized in sidebar.lua)
theme.sidebar_bg = x.background
theme.sidebar_fg = x.color7
theme.sidebar_opacity = 1
theme.sidebar_position = "left" -- left or right
theme.sidebar_width = dpi(320)
theme.sidebar_x = 0
theme.sidebar_y = 0
theme.sidebar_border_radius = dpi(10)
-- theme.sidebar_border_radius = theme.border_radius

-- Dashboard
theme.dashboard_bg = x.color0 .. "CC"
theme.dashboard_fg = x.color7

-- Exit screen
theme.exit_screen_bg = x.color0 .. "CC"
theme.exit_screen_fg = x.color7
theme.exit_screen_font = "sans 20"
theme.exit_screen_icon_size = dpi(180)

-- Lock screen
theme.lock_screen_bg = x.color0 .. "CC"
theme.lock_screen_fg = x.color7

-- Icon taglist
local ntags = 10
theme.taglist_icons_empty = {}
theme.taglist_icons_occupied = {}
theme.taglist_icons_focused = {}
theme.taglist_icons_urgent = {}
-- table.insert(tag_icons, tag)
for i = 1, ntags do
    theme.taglist_icons_empty[i] = taglist_icon_path .. tostring(i) .. "_empty.png"
    theme.taglist_icons_occupied[i] = taglist_icon_path .. tostring(i) .. "_occupied.png"
    theme.taglist_icons_focused[i] = taglist_icon_path .. tostring(i) .. "_focused.png"
    theme.taglist_icons_urgent[i] = taglist_icon_path .. tostring(i) .. "_urgent.png"
end

-- widget Text Taglist
theme.taglist_text_font = "Material Design Icons 10"
-- theme.taglist_text_font = "sans bold 15"
theme.taglist_text_empty = { "", "", "", "", "", "", "", "", "", "" }
theme.taglist_text_occupied = { "", "", "", "", "", "", "", "", "", "" }
theme.taglist_text_focused = { "󰮯", "󰮯", "󰮯", "󰮯", "󰮯", "󰮯", "󰮯", "󰮯", "󰮯", "󰮯" }
-- theme.taglist_text_focused  = {"","","","","","","","","",""}
theme.taglist_text_urgent = { "+", "+", "+", "+", "+", "+", "+", "+", "+", "+" }
-- theme.taglist_text_urgent   = {"","","","","","","","","",""}
-- theme.taglist_text_urgent   = {"","","","","","","","","",""}

theme.taglist_text_color_empty = {
    "#00000000",
    "#00000000",
    "#00000000",
    "#00000000",
    "#00000000",
    "#00000000",
    "#00000000",
}
-- theme.taglist_text_color_occupied  = { x.foreground.."F0", x.foreground.."F0", x.foreground.."F0", x.foreground.."F0", x.foreground.."F0", x.foreground.."F0", x.foreground.."F0", x.foreground.."F0", x.foreground.."F0", x.foreground.."F0" }
-- theme.taglist_text_color_focused  = { x.foreground.."F0", x.foreground.."F0", x.foreground.."F0", x.foreground.."F0", x.foreground.."F0", x.foreground.."F0", x.foreground.."F0", x.foreground.."F0", x.foreground.."F0", x.foreground.."F0" }
-- theme.taglist_text_color_urgent  = { x.foreground, x.foreground, x.foreground, x.foreground, x.foreground, x.foreground, x.foreground, x.foreground, x.foreground, x.foreground }

theme.taglist_text_color_occupied = {
    x.color2 .. "49",
    x.color11 .. "49",
    x.color12 .. "49",
    x.color13 .. "99",
    x.color6 .. "49",
    x.color14 .. "49",
    x.color9 .. "49",
}
theme.taglist_text_color_focused = {
    x.color2,
    x.color11,
    x.color12,
    x.color13,
    x.color6,
    x.color14,
    x.color9,
}
theme.taglist_text_color_urgent = {
    x.foreground,
    x.foreground,
    x.foreground,
    x.foreground,
    x.foreground,
    x.foreground,
    x.foreground,
}
-- theme.taglist_text_color_urgent   = { x.color9, x.color10, x.color11, x.color12, x.color13, x.color14, x.color9, x.color10, x.color11, x.color12 }

-- Prompt
theme.prompt_fg = x.color12

-- Text Taglist (default)
theme.taglist_font = "monospace bold 8"
theme.taglist_bg_focus = "000000"
theme.taglist_fg_focus = x.color2
theme.taglist_bg_occupied = "000000"
theme.taglist_fg_occupied = x.color15
theme.taglist_bg_empty = "000000"
theme.taglist_fg_empty = x.color8
theme.taglist_bg_urgent = "000000"
theme.taglist_fg_urgent = x.color11
theme.taglist_disable_icon = true
theme.taglist_spacing = dpi(0)
-- Generate taglist squares:
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_focus)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

-- Variables set for theming the menu:
theme.menu_height = dpi(35)
theme.menu_width = dpi(180)
theme.menu_bg_normal = x.color0
theme.menu_fg_normal = x.color7
theme.menu_bg_focus = x.color8 .. "55"
theme.menu_fg_focus = x.color7
theme.menu_border_width = dpi(0)
theme.menu_border_color = x.color0

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Titlebar buttons
-- Define the images to load
theme.titlebar_close_button_normal = tip .. "close_normal.svg"
theme.titlebar_close_button_focus = tip .. "close_focus.svg"
theme.titlebar_minimize_button_normal = tip .. "minimize_normal.svg"
theme.titlebar_minimize_button_focus = tip .. "minimize_focus.svg"
theme.titlebar_ontop_button_normal_inactive = tip .. "ontop_normal_inactive.svg"
theme.titlebar_ontop_button_focus_inactive = tip .. "ontop_focus_inactive.svg"
theme.titlebar_ontop_button_normal_active = tip .. "ontop_normal_active.svg"
theme.titlebar_ontop_button_focus_active = tip .. "ontop_focus_active.svg"
theme.titlebar_sticky_button_normal_inactive = tip .. "sticky_normal_inactive.svg"
theme.titlebar_sticky_button_focus_inactive = tip .. "sticky_focus_inactive.svg"
theme.titlebar_sticky_button_normal_active = tip .. "sticky_normal_active.svg"
theme.titlebar_sticky_button_focus_active = tip .. "sticky_focus_active.svg"
theme.titlebar_floating_button_normal_inactive = tip .. "floating_normal_inactive.svg"
theme.titlebar_floating_button_focus_inactive = tip .. "floating_focus_inactive.svg"
theme.titlebar_floating_button_normal_active = tip .. "floating_normal_active.svg"
theme.titlebar_floating_button_focus_active = tip .. "floating_focus_active.svg"
theme.titlebar_maximized_button_normal_inactive = tip .. "maximized_normal_inactive.svg"
theme.titlebar_maximized_button_focus_inactive = tip .. "maximized_focus_inactive.svg"
theme.titlebar_maximized_button_normal_active = tip .. "maximized_normal_active.svg"
theme.titlebar_maximized_button_focus_active = tip .. "maximized_focus_active.svg"
-- (hover)
theme.titlebar_close_button_normal_hover = tip .. "close_normal_hover.svg"
theme.titlebar_close_button_focus_hover = tip .. "close_focus_hover.svg"
theme.titlebar_minimize_button_normal_hover = tip .. "minimize_normal_hover.svg"
theme.titlebar_minimize_button_focus_hover = tip .. "minimize_focus_hover.svg"
theme.titlebar_ontop_button_normal_inactive_hover = tip .. "ontop_normal_inactive_hover.svg"
theme.titlebar_ontop_button_focus_inactive_hover = tip .. "ontop_focus_inactive_hover.svg"
theme.titlebar_ontop_button_normal_active_hover = tip .. "ontop_normal_active_hover.svg"
theme.titlebar_ontop_button_focus_active_hover = tip .. "ontop_focus_active_hover.svg"
theme.titlebar_sticky_button_normal_inactive_hover = tip .. "sticky_normal_inactive_hover.svg"
theme.titlebar_sticky_button_focus_inactive_hover = tip .. "sticky_focus_inactive_hover.svg"
theme.titlebar_sticky_button_normal_active_hover = tip .. "sticky_normal_active_hover.svg"
theme.titlebar_sticky_button_focus_active_hover = tip .. "sticky_focus_active_hover.svg"
theme.titlebar_floating_button_normal_inactive_hover = tip .. "floating_normal_inactive_hover.svg"
theme.titlebar_floating_button_focus_inactive_hover = tip .. "floating_focus_inactive_hover.svg"
theme.titlebar_floating_button_normal_active_hover = tip .. "floating_normal_active_hover.svg"
theme.titlebar_floating_button_focus_active_hover = tip .. "floating_focus_active_hover.svg"
theme.titlebar_maximized_button_normal_inactive_hover = tip .. "maximized_normal_inactive_hover.svg"
theme.titlebar_maximized_button_focus_inactive_hover = tip .. "maximized_focus_inactive_hover.svg"
theme.titlebar_maximized_button_normal_active_hover = tip .. "maximized_normal_active_hover.svg"
theme.titlebar_maximized_button_focus_active_hover = tip .. "maximized_focus_active_hover.svg"

-- You can use your own layout icons like this:
theme.layout_fairh = layout_icon_path .. "fairh.png"
theme.layout_fairv = layout_icon_path .. "fairv.png"
theme.layout_floating = layout_icon_path .. "floating.png"
theme.layout_magnifier = layout_icon_path .. "magnifier.png"
theme.layout_max = layout_icon_path .. "max.png"
theme.layout_fullscreen = layout_icon_path .. "fullscreen.png"
theme.layout_tilebottom = layout_icon_path .. "tilebottom.png"
theme.layout_tileleft = layout_icon_path .. "tileleft.png"
theme.layout_tile = layout_icon_path .. "tile.png"
theme.layout_tiletop = layout_icon_path .. "tiletop.png"
theme.layout_spiral = layout_icon_path .. "spiral.png"
theme.layout_dwindle = layout_icon_path .. "dwindle.png"
theme.layout_cornernw = layout_icon_path .. "cornernw.png"
theme.layout_cornerne = layout_icon_path .. "cornerne.png"
theme.layout_cornersw = layout_icon_path .. "cornersw.png"
theme.layout_cornerse = layout_icon_path .. "cornerse.png"

-- Recolor layout icons
--theme = theme_assets.recolor_layout(theme, x.color1)

-- widget widgets customization --
-- Desktop mode widget variables
-- Symbols     
-- theme.desktop_mode_color_floating = x.color4
-- theme.desktop_mode_color_tile = x.color3
-- theme.desktop_mode_color_max = x.color1
-- theme.desktop_mode_text_floating = "f"
-- theme.desktop_mode_text_tile = "t"
-- theme.desktop_mode_text_max = "m"

-- Minimal tasklist widget variables
theme.minimal_tasklist_visible_clients_color = x.color4
theme.minimal_tasklist_visible_clients_text = ""
theme.minimal_tasklist_hidden_clients_color = x.color7
theme.minimal_tasklist_hidden_clients_text = ""

-- Mpd song
theme.mpd_song_title_color = x.color7
theme.mpd_song_artist_color = x.color7
theme.mpd_song_paused_color = x.color8

-- Volume bar
theme.volume_bar_active_color = x.color5
theme.volume_bar_active_background_color = x.color0
theme.volume_bar_muted_color = x.color8
theme.volume_bar_muted_background_color = x.color0

-- Temperature bar
theme.temperature_bar_active_color = x.color1
theme.temperature_bar_background_color = x.color0

-- Battery bar
theme.battery_bar_active_color = x.color6
theme.battery_bar_background_color = x.color0

-- CPU bar
theme.cpu_bar_active_color = x.color2
theme.cpu_bar_background_color = x.color0

-- RAM bar
theme.ram_bar_active_color = x.color4
theme.ram_bar_background_color = x.color0

-- Brightness bar
theme.brightness_bar_active_color = x.color3
theme.brightness_bar_background_color = x.color0

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
-- theme.icon_theme = "/usr/share/icons/Nordzy-dark"
theme.window_switcher_widget_bg = "#262b33" -- The bg color of the widget
theme.window_switcher_widget_border_width = 0 -- The border width of the widget
theme.window_switcher_widget_border_radius = 3 -- The border radius of the widget
theme.window_switcher_widget_border_color = "#ffffff" -- The border color of the widget
theme.window_switcher_clients_spacing = 20 -- The space between each client item
theme.window_switcher_client_icon_horizontal_spacing = 10 -- The space between client icon and text
theme.window_switcher_client_width = 200 -- The width of one client widget
theme.window_switcher_client_height = 250 -- The height of one client widget
theme.window_switcher_client_margins = 5 -- The margin between the content and the border of the widget
theme.window_switcher_thumbnail_margins = 5 -- The margin between one client thumbnail and the rest of the widget
theme.thumbnail_scale = true -- If set to true, the thumbnails fit policy will be set to "fit" instead of "auto"
theme.window_switcher_name_margins = 5 -- The margin of one clients title to the rest of the widget
theme.window_switcher_name_valign = "left" -- How to vertically align one clients title
theme.window_switcher_name_forced_width = 200 -- The width of one title
theme.window_switcher_name_font = "sans medium 10" -- The font of all titles
theme.window_switcher_name_normal_color = x.foreground .. "60"
theme.window_switcher_name_focus_color = x.foreground -- The color of one title if the client is focused
theme.window_switcher_icon_valign = "center" -- How to vertically align the one icon
theme.window_switcher_icon_width = dpi(0)

theme.layout_floating = gears.color.recolor_image(themes_path .. "default/layouts/floatingw.png", theme.fg_normal)
theme.layout_tile = gears.color.recolor_image(themes_path .. "default/layouts/tilew.png", theme.fg_normal)
theme.layout_max = gears.color.recolor_image(themes_path .. "default/layouts/maxw.png", theme.fg_normal)
theme.layout_tilebottom = gears.color.recolor_image(themes_path .. "default/layouts/tilebottomw.png", theme.fg_normal)
theme.layout_spiral = gears.color.recolor_image(themes_path .. "default/layouts/spiralw.png", theme.fg_normal)
theme.layout_dwindle = gears.color.recolor_image(themes_path .. "default/layouts/dwindle.png", theme.fg_normal)
return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
