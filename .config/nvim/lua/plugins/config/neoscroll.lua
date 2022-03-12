require("neoscroll").setup {
    easing_function = "quadratic", -- Default easing function
    -- Set any other options as needed
}

local t = {}
-- Use the "circular" easing function
t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "500", [['circular']] } }
t["<C-m>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "500", [['circular']] } }

require("neoscroll.config").set_mappings(t)
