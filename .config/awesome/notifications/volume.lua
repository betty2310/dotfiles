local naughty = require "naughty"
local icons = require "icons"
local notifications = require "notifications"

local notif
local timeout = 5
local first_time = true
awesome.connect_signal("signal::volume", function(percentage, muted)
    if first_time then
        first_time = false
    else
        if (sidebar and sidebar.visible) or (client.focus and client.focus.class == "Pavucontrol") then
            -- Sidebar and Pavucontrol already show volume, so
            -- destroy notification if it exists
            if notif then
                notif:destroy()
            end
        else
            -- Send notification
            local message, icon
            if muted then
                message = "muted"
                icon = icons.image.muted
            else
                message = tostring(percentage)
                if percentage == 0 then
                    icon = icons.image.muted
                end
                if percentage > 0 and percentage <= 35 then
                    icon = icons.image.low
                end
                if percentage > 35 and percentage <= 65 then
                    icon = icons.image.medium
                end
                if percentage > 65 and percentage <= 85 then
                    icon = icons.image.high
                end
                if percentage > 85 then
                    icon = icons.image.max
                end
            end

            notif = notifications.notify_dwim(
                { title = "Volume", message = message, icon = icon, timeout = timeout, app_name = "volume" },
                notif
            )
        end
    end
end)
