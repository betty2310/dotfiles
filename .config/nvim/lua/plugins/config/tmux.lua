local ok, tmux = pcall(require, "tmux")

if ok then
    tmux.setup {
        copy_sync = {
            enable = true,
        },
        navigation = {
            enable_default_keybindings = true,
        },
        resize = {
            enable_default_keybindings = true,
        },
    }
end
