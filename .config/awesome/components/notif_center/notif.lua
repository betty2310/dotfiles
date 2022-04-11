local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"
local naughty = require "naughty"
local icons = require "icons"
local helpers = require "helpers"
local apps = require "apps"

local notifs_text = wibox.widget {
    font = beautiful.font_name .. " Bold 14",
    markup = "<span foreground='" .. x.foreground .. "'>Notification Center</span>",
    halign = "center",
    widget = wibox.widget.textbox,
}

local notifs_clear = wibox.widget {
    markup = "<span foreground='" .. x.foreground .. "'></span>",
    font = "Font Awesome 6 Pro Solid 10",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox,
}

notifs_clear:buttons(gears.table.join(awful.button({}, 1, function()
    _G.notif_center_reset_notifs_container()
end)))

helpers.add_hover_cursor(notifs_clear, "hand1")

local notifs_empty = wibox.widget {
    {
        nil,
        {
            nil,
            helpers.vertical_pad(dpi(30)),
            {
                widget = wibox.widget.imagebox,
                image = gears.color.recolor_image(
                    os.getenv "HOME" .. "/.config/awesome/icons/no-notifs.png",
                    "#4C566A"
                ),
                forced_height = 120,
                forced_width = 120,
                valign = "center",
                halign = "center",
            },
            layout = wibox.layout.fixed.vertical,
        },
        layout = wibox.layout.align.horizontal,
    },
    -- forced_height = 200,
    widget = wibox.container.background,
}

local notifs_container = wibox.widget {
    spacing = 10,
    spacing_widget = {
        {
            shape = gears.shape.rounded_rect,
            widget = wibox.container.background,
        },
        top = 2,
        bottom = 2,
        left = 6,
        right = 6,
        widget = wibox.container.margin,
    },
    forced_height = 490,
    layout = wibox.layout.fixed.vertical,
}

local remove_notifs_empty = true

notif_center_reset_notifs_container = function()
    notifs_container:reset(notifs_container)
    notifs_container:insert(1, notifs_empty)
    remove_notifs_empty = true
end

notif_center_remove_notif = function(box)
    notifs_container:remove_widgets(box)

    if #notifs_container.children == 0 then
        notifs_container:insert(1, notifs_empty)
        remove_notifs_empty = true
    end
end

local create_notif = function(icon, n, width)
    local time = os.date "%H:%M"
    local box = {}

    box = wibox.widget {
        {
            {
                {
                    {
                        image = icon,
                        resize = true,
                        clip_shape = function(cr, width, height)
                            gears.shape.rounded_rect(cr, width, height, 2)
                        end,
                        halign = "center",
                        valign = "center",
                        widget = wibox.widget.imagebox,
                    },
                    strategy = "exact",
                    height = 50,
                    width = 50,
                    widget = wibox.container.constraint,
                },
                {
                    {
                        nil,
                        {
                            {
                                {
                                    step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
                                    speed = 50,
                                    {
                                        markup = n.title,
                                        font = beautiful.font_name .. " Bold 9",
                                        align = "left",
                                        widget = wibox.widget.textbox,
                                    },
                                    forced_width = 100,
                                    widget = wibox.container.scroll.horizontal,
                                },
                                nil,
                                {
                                    markup = "<span foreground='" .. x.foreground .. "'>" .. time .. "</span>",
                                    align = "right",
                                    valign = "bottom",
                                    font = "sans medium 7",
                                    widget = wibox.widget.textbox,
                                },
                                expand = "none",
                                layout = wibox.layout.align.horizontal,
                            },
                            {

                                step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
                                speed = 50,
                                {
                                    markup = n.message,
                                    font = "sans 8",
                                    align = "left",
                                    widget = wibox.widget.textbox,
                                },
                                forced_width = 100,
                                widget = wibox.container.scroll.horizontal,
                            },
                            spacing = 5,
                            layout = wibox.layout.fixed.vertical,
                        },
                        expand = "none",
                        layout = wibox.layout.align.vertical,
                    },
                    left = 10,
                    widget = wibox.container.margin,
                },
                layout = wibox.layout.align.horizontal,
            },
            margins = 15,
            widget = wibox.container.margin,
        },
        forced_height = 85,
        shape = helpers.rrect(dpi(14)),
        bg = "#313744",
        widget = wibox.container.background,
    }

    box:buttons(gears.table.join(awful.button({}, 1, function()
        _G.notif_center_remove_notif(box)
    end)))

    return box
end

notifs_container:buttons(gears.table.join(
    awful.button({}, 4, nil, function()
        if #notifs_container.children == 1 then
            return
        end
        notifs_container:insert(1, notifs_container.children[#notifs_container.children])
        notifs_container:remove(#notifs_container.children)
    end),

    awful.button({}, 5, nil, function()
        if #notifs_container.children == 1 then
            return
        end
        notifs_container:insert(#notifs_container.children + 1, notifs_container.children[1])
        notifs_container:remove(1)
    end)
))

notifs_container:insert(1, notifs_empty)

naughty.connect_signal("request::display", function(n)
    if #notifs_container.children == 1 and remove_notifs_empty then
        notifs_container:reset(notifs_container)
        remove_notifs_empty = false
    end

    local appicon = n.icon or n.app_icon
    if not appicon then
        appicon = beautiful.notification_icon
    end

    notifs_container:insert(1, create_notif(appicon, n, width))
end)

local notifs = wibox.widget {
    {
        {
            notifs_text,
            nil,
            notifs_clear,
            expand = "none",
            layout = wibox.layout.align.horizontal,
        },
        left = dpi(10),
        right = dpi(10),
        layout = wibox.container.margin,
    },
    notifs_container,
    spacing = 20,
    layout = wibox.layout.fixed.vertical,
}
return notifs
