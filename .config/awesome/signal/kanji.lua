local awful = require "awful"

local function emit_info()
    awful.spawn.easy_async_with_shell("kanji | head -n1 | awk '{print $1;}'", function(stdout)
        local kanji = stdout:match "([^s]+)"
        local han = stdout:match ""
        local viet = stdout:match ""

        awesome.emit_signal("signal::kanji", kanji, han, viet)
    end)
end
