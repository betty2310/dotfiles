local wibox = require "wibox"
local awful = require "awful"
local naughty = require "naughty"

-- Declare widgets
local spotify_artist = wibox.widget.textbox()
local spotify_title = wibox.widget.textbox()

-- Main widget that includes all others
local spotify_widget = wibox.widget {
    -- Title widget
    {
        align = "center",
        text = "Noting playing ....",
        font = "sans 12",
        widget = spotify_title,
    },
    -- Artist widget
    {
        align = "center",
        text = "Betty :v",
        font = "sans 10",
        widget = spotify_artist,
    },
    spacing = 4,
    layout = wibox.layout.fixed.vertical,
}

-- Subcribe to spotify updates
awesome.connect_signal("signal::spotify", function(artist, title, status)
    -- Do whatever you want with artist, title, status
    -- ...
    spotify_artist.text = artist
    spotify_title.text = title

    -- Example notification (might not be needed if spotify already sends one)
    if status == "playing" then
        --naughty.notify { title = "Now Playing", message = title .. " by " .. artist }
    end
end)

return spotify_widget
