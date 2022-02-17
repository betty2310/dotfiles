local ok, null_ls = pcall(require, "null-ls")

if ok then
    local diagnostics = null_ls.builtins.diagnostics

    null_ls.setup {
        sources = {
            diagnostics.eslint.with {
                only_local = "node_modules/.bin",
            },
            diagnostics.flake8,
            diagnostics.cppcheck,
            -- formatting.prettierd,
            -- formatting.stylua,
            -- formatting.clang_format,
            -- formatting.autopep8,
            -- formatting.gofmt,
            -- formatting.rustfmt,
            -- formatting.taplo,
            -- formatting.shfmt.with {
            --     filetypes = { "sh", "bash", "zsh", "fish" },
            -- },
            -- formatting.trim_whitespace,
        },

        -- on_attach = function(client)
        --     if client.resolved_capabilities.document_formatting then
        --         vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()"
        --     end
        -- end,
    }
end
