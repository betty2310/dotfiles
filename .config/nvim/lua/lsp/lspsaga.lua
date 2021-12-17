local ok, saga = pcall(require, "lspsaga")

if ok then
    local signs = require("utils").signs

    saga.init_lsp_saga {
        debug = false,
        use_saga_diagnostic_sign = true,
        error_sign = signs.Error,
        warn_sign = signs.Warn,
        hint_sign = signs.Hint,
        infor_sign = signs.Info,
        border_style = "single",
        code_action_prompt = {
            enable = true,
            sign = false,
            sign_priority = 40,
            virtual_text = true,
        },
        rename_action_keys = {
            quit = "<Esc>",
            exec = "<CR>",
        },
    }
end
