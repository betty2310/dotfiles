local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local rubato = require("lib.rubato")
local helpers = require("helpers")
local wibox = require("wibox")

F.action = {}

local notifs = require("components.notif_center.notif")
local actions = wibox.widget({
    {
        {
            {
                { widget = require("components.notif_center.controls.clip") },
                { widget = require("components.notif_center.controls.shot") },
                { widget = require("components.notif_center.controls.rec") },
                { widget = require("components.notif_center.controls.save") },
                layout = wibox.layout.flex.horizontal,
                spacing = 30,
            },

            {
                { widget = require("components.notif_center.controls.wifi") },
                { widget = require("components.notif_center.controls.bluetooth") },
                { widget = require("components.notif_center.controls.dnd") },
                { widget = require("components.notif_center.controls.night_light") },
                layout = wibox.layout.flex.horizontal,
                spacing = 30,
            },
            {
                {
                    widget = require("components.notif_center.controls.vol_slider"),
                },
                {
                    widget = require("components.notif_center.controls.bri_slider"),
                },
                layout = wibox.layout.flex.vertical,
                spacing = 30,
            },
            layout = wibox.layout.flex.vertical,
            spacing = 30,
        },
        widget = wibox.container.margin,
        top = 35,
        bottom = 35,
        left = 35,
        right = 35,
    },
    shape = helpers.rrect(dpi(5)),
    widget = wibox.container.background,
    bg = "#2b313c",
})

local action = awful.popup({
    widget = {
        widget = wibox.container.margin,
        margins = 30,
        forced_width = 500,
        {
            layout = wibox.layout.fixed.vertical,
            notifs,
            actions,
        },
    },
    placement = function(c)
        (awful.placement.right + awful.placement.maximize_vertically)(c)
    end,
    ontop = true,
    visible = false,
    bg = x.background,
    border_color = x.foreground,
    border_width = 0,
})

local slide = rubato.timed({
    pos = 1420,
    rate = 60,
    intro = 0.3,
    duration = 0.8,
    easing = rubato.quadratic,
    awestore_compat = true,
    subscribed = function(pos)
        action.x = pos
    end,
})

local action_status = false

slide.ended:subscribe(function()
    if action_status then
        action.visible = false
    end
end)

local function action_show()
    action.visible = true
    slide:set(1420)
    action_status = false
end

local function action_hide()
    slide:set(1920)
    action_status = true
end

F.action.toggle = function()
    if action.visible then
        action_hide()
    else
        action_show()
    end
end
