local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"

local calendar_themes = {
    nord = {
        bg = "#313744",
        fg = "#D8DEE9",
        focus_date_bg = x.color1,
        focus_date_fg = "#313744",
        weekend_day_bg = "#313744",
        weekday_fg = "#88C0D0",
        header_fg = "#E5E9F0",
        border = "#4C566A",
    },
    naughty = {
        bg = x.color0,
        fg = x.foreground,
        focus_date_bg = x.foreground,
        focus_date_fg = x.background,
        weekend_day_bg = x.background,
        weekday_fg = x.foreground,
        header_fg = x.foreground,
        border = x.background,
    },
}

local args = {
    theme = "nord",
    start_sunday = false,
    radius = 8,
}

if args.theme ~= nil and calendar_themes[args.theme] == nil then
    naughty.notify {
        preset = naughty.config.presets.critical,
        title = "Calendar Widget",
        text = 'Theme "' .. args.theme .. '" not found, fallback to default',
    }
    args.theme = "naughty"
end

local theme = args.theme or "naughty"
local placement = args.placement or "top"
local radius = args.radius or 8
local next_month_button = args.next_month_button or 4
local previous_month_button = args.previous_month_button or 5
local start_sunday = args.start_sunday or false

local styles = {}
local function rounded_shape(size)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, size)
    end
end

styles.month = {
    padding = 5,
    bg_color = calendar_themes[theme].bg,
    fg_color = x.color7,
    border_width = 0,
}

styles.normal = {
    markup = function(t)
        return t
    end,
    shape = gears.shape.circle,
}

styles.focus = {
    fg_color = calendar_themes[theme].focus_date_fg,
    bg_color = calendar_themes[theme].focus_date_bg,
    markup = function(t)
        return "<b>" .. t .. "</b>"
    end,
    -- shape = rounded_shape(4),
    shape = gears.shape.circle,
}

styles.header = {
    fg_color = x.color5,
    bg_color = calendar_themes[theme].bg,
    markup = function(t)
        return '<span font_desc="sans bold 14">' .. t .. "</span>"
    end,
}

styles.weekday = {
    fg_color = calendar_themes[theme].weekday_fg,
    bg_color = calendar_themes[theme].bg,
    markup = function(t)
        return "<b>" .. t .. "</b>"
    end,
}

local function decorate_cell(widget, flag, date)
    if flag == "monthheader" and not styles.monthheader then
        flag = "header"
    end

    -- highlight only today's day
    if flag == "focus" then
        local today = os.date "*t"
        if not (today.month == date.month and today.year == date.year) then
            flag = "normal"
        end
    end

    local props = styles[flag] or {}
    if props.markup and widget.get_text and widget.set_markup then
        widget:set_markup(props.markup(widget:get_text()))
    end
    -- Change bg color for weekends
    local d = { year = date.year, month = (date.month or 1), day = (date.day or 1) }
    local weekday = tonumber(os.date("%w", os.time(d)))
    local default_bg = (weekday == 0 or weekday == 6) and calendar_themes[theme].weekend_day_bg
        or calendar_themes[theme].bg
    local ret = wibox.widget {
        {
            {
                widget,
                halign = "center",
                widget = wibox.container.place,
            },
            margins = (props.padding or 2) + (props.border_width or 0),
            widget = wibox.container.margin,
        },
        shape = props.shape,
        shape_border_color = props.border_color or "#000000",
        shape_border_width = props.border_width or 0,
        fg = props.fg_color or calendar_themes[theme].fg,
        bg = props.bg_color or default_bg,
        widget = wibox.container.background,
    }

    return ret
end
calendar_widget = wibox.widget {
    date = os.date "*t",
    font = "sans medium 11",
    long_weekdays = true,
    spacing = dpi(6),
    fn_embed = decorate_cell,
    widget = wibox.widget.calendar.month,
}

local current_month = os.date("*t").month
calendar_widget:buttons(gears.table.join(
    -- Left Click - Reset date to current date
    awful.button({}, 1, function()
        calendar_widget.date = os.date "*t"
    end),
    -- Scroll - Move to previous or next month
    awful.button({}, 4, function()
        new_calendar_month = calendar_widget.date.month - 1
        if new_calendar_month == current_month then
            calendar_widget.date = os.date "*t"
        else
            calendar_widget.date = { month = new_calendar_month, year = calendar_widget.date.year }
        end
    end),
    awful.button({}, 5, function()
        new_calendar_month = calendar_widget.date.month + 1
        if new_calendar_month == current_month then
            calendar_widget.date = os.date "*t"
        else
            calendar_widget.date = { month = new_calendar_month, year = calendar_widget.date.year }
        end
    end)
))

return calendar_widget
