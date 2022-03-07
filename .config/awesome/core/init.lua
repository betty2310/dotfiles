-- Monitoring
require "core.cpu"
require "core.ram"
require "core.temperature"
require "core.battery"
require "core.disk"

-- User controlled
require "core.volume"
require "core.microphone"
require "core.mpd"
require "core.brightness"
require "core.spotify"

-- Internet access required
-- Note: These daemons use a temp file to store the retrieved values in order
-- to check its modification time and decide if it is time to update or not.
-- No need to worry that you will be updating too often when restarting AwesomeWM :)
-- This is useful because some APIs have a limit on the number of calls per hour.
require "core.coronavirus"
require "core.weather"
require "core.sub"
