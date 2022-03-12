-- Provides:
-- signal::ram
--      used (integer - mega bytes)
--      total (integer - mega bytes)
local awful = require "awful"

local update_interval = 20
-- Returns the used amount of ram in percentage
-- TODO output of free is affected by system language. The following command
-- works for any language:
-- free -m | sed -n '2p' | awk '{printf "%d available out of %d\n", $7, $2}'
local ram_script = [[
  sh -c "
  date
  "]]

-- Periodically get ram info
awful.widget.watch(ram_script, update_interval, function(stdout)
    awesome.emit_signal("signal::date", date)
end)
