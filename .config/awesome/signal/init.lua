-- Monitoring
require("signal.cpu")
require("signal.ram")
require("signal.temperature")
require("signal.battery")
require("signal.disk")

-- User controlled
require("signal.volume")
require("signal.microphone")
require("signal.mpd")
require("signal.brightness")
require("signal.spotify")

-- Internet access required
-- Note: These daemons use a temp file to store the retrieved values in order
-- to check its modification time and decide if it is time to update or not.
-- No need to worry that you will be updating too often when restarting AwesomeWM :)
-- This is useful because some APIs have a limit on the number of calls per hour.
require("signal.coronavirus")
require("signal.weather")
require("signal.sub")
