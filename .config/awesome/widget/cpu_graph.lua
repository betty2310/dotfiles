-------------------------------------------------
-- CPU Widget for Awesome Window Manager
-- Shows the current CPU utilization
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/cpu-widget

-- @author Pavel Makhov
-- @copyright 2020 Pavel Makhov
-------------------------------------------------

local awful = require "awful"
local watch = require "awful.widget.watch"
local wibox = require "wibox"
local beautiful = require "beautiful"
local gears = require "gears"
local helpers = require "helpers"

local CMD = [[sh -c "grep '^cpu.' /proc/stat; ps -eo '%p|%c|%C|' -o "%mem" -o '|%a' --sort=-%cpu ]]
    .. [[| head -11 | tail -n +2"]]

-- A smaller command, less resource intensive, used when popup is not shown.
local CMD_slim = [[grep --max-count=1 '^cpu.' /proc/stat]]

local HOME_DIR = os.getenv "HOME"
local WIDGET_DIR = HOME_DIR .. "/.config/awesome/widget/"

local cpu_widget = {}
local is_update = true

local args = {}
local width = 200
local step_width = 3
local step_spacing = 0
local color = x.color0

local background_color = args.background_color or "#00000000"
local timeout = args.timeout or 1

local cpugraph_widget = wibox.widget {
    max_value = 100,
    background_color = background_color,
    forced_width = width,
    forced_height = 40,
    step_width = step_width,
    step_spacing = step_spacing,
    widget = wibox.widget.graph,
    color = "linear:0,0:0,20:0,#bf616a:0.4,#ebcb8b:0.8," .. color,
}

cpu_widget = wibox.widget {
    {
        cpugraph_widget,
        reflection = { horizontal = true },
        layout = wibox.container.mirror,
    },
    bottom = 3,
    color = background_color,
    widget = wibox.container.margin,
}

-- This part runs constantly, also when the popup is closed.
-- It updates the graph widget in the bar.
local maincpu = {}
watch(CMD_slim, timeout, function(widget, stdout)
    local _, user, nice, system, idle, iowait, irq, softirq, steal, _, _ =
        stdout:match "(%w+)%s+(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)"

    local total = user + nice + system + idle + iowait + irq + softirq + steal

    local diff_idle = idle - tonumber(maincpu["idle_prev"] == nil and 0 or maincpu["idle_prev"])
    local diff_total = total - tonumber(maincpu["total_prev"] == nil and 0 or maincpu["total_prev"])
    local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 20) / 10

    maincpu["total_prev"] = total
    maincpu["idle_prev"] = idle

    widget:add_value(diff_usage)
end, cpugraph_widget)

local popup = awful.popup {
    ontop = true,
    visible = false,
    shape = gears.shape.rounded_rect,
    border_width = 0,
    border_color = x.background,
    x = 170,
    y = 770,
    widget = cpu_widget,
}
local go = wibox.widget {
    font = "JetBrainsMono Nerd Font 13",
    markup = helpers.colorize_text(" ", x.color11),
    widget = wibox.widget.textbox,
}
go:buttons(gears.table.join(awful.button({}, 1, function()
    popup.visible = not popup.visible
end)))

return go
