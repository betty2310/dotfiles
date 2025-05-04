local function init()
    local opts = mp.get_property_native("options/script-opts")
    if opts and opts["http-ytproxy"] == "no" then
        return
    end

    local url = mp.get_property("stream-open-filename")
    -- check for youtube link
    if url:find("^https:") == nil or (url:find("youtu") == nil and url:find("yewtu") == nil) then
        return
    end

    local proxy = mp.get_property("http-proxy")
    local ytdl_raw_options = mp.get_property("ytdl-raw-options")
    if (proxy and proxy ~= "" and proxy ~= "http://127.0.0.1:12081") or
       (ytdl_raw_options and ytdl_raw_options:match("proxy=([^ ]+)")) then
        return
    end

    -- launch mitm proxy
    local args = {
        mp.get_script_directory() .. "/http-ytproxy",
        "-c", mp.get_script_directory() .. "/cert.pem",
        "-k", mp.get_script_directory() .. "/key.pem",
        "-r", "10485760", -- range modification
        "-p", "12081" -- proxy port
    }
    mp.command_native_async({
        name = "subprocess",
        capture_stdout = false,
        playback_only = false,
        args = args,
    });

    mp.set_property("http-proxy", "http://127.0.0.1:12081")
    mp.set_property("tls-verify", "no")
    -- this is not really needed
    --mp.set_property("tls-verify", "yes")
    --mp.set_property("tls-ca-file", mp.get_script_directory() .. "/cert.pem")
end

mp.register_event("start-file", init)
