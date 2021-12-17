local ok, comment = pcall(require, "Comment")

if ok then
    comment.setup {
        padding = true,
        sticky = true,
        ignore = nil,
        toggler = {
            line = "gcc",
            block = "gbc",
        },
        opleader = {
            line = "gc",
            block = "gb",
        },
        mappings = {
            basic = true,
            extra = true,
            extended = false,
        },
        pre_hook = nil,
        post_hook = nil,
    }
end
