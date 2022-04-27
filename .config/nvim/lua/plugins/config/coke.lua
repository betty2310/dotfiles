local present, cokeline = pcall(require, "cokeline")
if not present then
    return
end

local colors = require("utils").colors
cokeline.setup {
    -- rendering = {
    --     left_sidebar = {
    --         filetype = "NvimTree",
    --         components = {
    --             {
    --                 text = "  🌳 NvimTree  ",
    --                 hl = {
    --                     fg = colors.yellow,
    --                     bg = colors.bg,
    --                     style = "bold",
    --                 },
    --             },
    --         },
    --     },
    -- },
    show_if_buffers_are_at_least = 1,

    mappings = {
        cycle_prev_next = true,
    },

    -- default_hl = {
    --     focused = {
    --         fg = colors.magenta,
    --         bg = "NONE",
    --     },
    --     unfocused = {
    --         fg = colors.bg3,
    --         bg = "NONE",
    --     },
    -- },

    components = {
        {
            text = function(buffer)
                return buffer.index ~= 0 and "  "
            end,
        },
        {
            text = function(buffer)
                return buffer.index .. " "
            end,
        },
        {
            text = function(buffer)
                return buffer.devicon.icon
            end,
            hl = {
                fg = function(buffer)
                    return buffer.devicon.color
                end,
            },
        },
        {
            text = function(buffer)
                return buffer.unique_prefix
            end,
            hl = {
                fg = function(buffer)
                    return buffer.is_focused and colors.magenta or colors.bg3
                end,
                style = "italic",
            },
        },
        {
            text = function(buffer)
                return buffer.filename .. ""
            end,
        },
        {
            text = function(buffer)
                return buffer.is_modified and "  " or ""
            end,
            hl = {
                fg = function(buffer)
                    return buffer.is_modified and colors.green or nil
                end,
            },
            truncation = { priority = 1 },
        },
        {
            text = "  ",
            hl = {},
            delete_buffer_on_left_click = true,
        },
        {
            text = "  ",
        },
    },
}
