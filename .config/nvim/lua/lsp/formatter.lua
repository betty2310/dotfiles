local ok, formatter = pcall(require, "formatter")

if ok then
    local F = {
        prettierd = {
            function()
                return {
                    exe = "prettierd",
                    args = { vim.api.nvim_buf_get_name(0) },
                    stdin = true,
                }
            end,
        },
        prettier = {
            -- prettier
            function()
                return {
                    exe = "prettier",
                    args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
                    stdin = true,
                }
            end,
        },
        rustfmt = {
            function()
                return {
                    exe = "rustfmt",
                    args = { "--emit=stdout" },
                    stdin = true,
                }
            end,
        },
        shfmt = {
            function()
                return {
                    exe = "shfmt",
                    args = { "-i", 2 },
                    stdin = true,
                }
            end,
        },
        stylua = {
            function()
                return {
                    exe = "stylua",
                    args = {
                        "--config-path " .. "~/.stylua.toml",
                        "-",
                    },
                    stdin = true,
                }
            end,
        },
        clangd_format = {
            function()
                return {
                    exe = "clang-format",
                    args = { "--assume-filename", vim.api.nvim_buf_get_name(0) },
                    stdin = true,
                    cwd = vim.fn.expand "%:p:h", -- Run clang-format in cwd of the file.
                }
            end,
        },
        autopep8 = {
            function()
                return {
                    exe = "python3 -m autopep8",
                    args = {
                        "--in-place --aggressive --aggressive",
                        vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
                    },
                    stdin = false,
                }
            end,
        },
        gofmt = {
            function()
                return {
                    exe = "gofmt",
                    args = { vim.api.nvim_buf_get_name(0) },
                    stdin = true,
                }
            end,
        },
        dockfmt = {
            function()
                return {
                    exe = "dockfmt",
                    args = { "fmt", "--write", vim.api.nvim_buf_get_name(0) },
                    stdin = false,
                }
            end,
        },
    }

    formatter.setup {
        filetype = {
            rust = F.rustfmt,
            sh = F.shfmt,
            zsh = F.shfmt,
            cpp = F.clangd_format,
            c = F.clangd_format,
            dockerfile = F.dockfmt,
            go = F.gofmt,
            python = F.autopep8,
            html = F.prettierd,
            javascript = F.prettierd,
            javascriptreact = F.prettierd,
            typescript = F.prettierd,
            typescriptreact = F.prettierd,
            json = F.prettierd,
            css = F.prettierd,
            scss = F.prettierd,
            less = F.prettierd,
            graphql = F.prettierd,
            yaml = F.prettierd,
            xml = F.prettierd,
            markdown = F.prettierd,
            lua = F.stylua,
        },
    }

    -- Auto format on save
    vim.api.nvim_exec(
        [[
        augroup FormatAutogroup
        autocmd!
        autocmd BufWritePost * FormatWrite
        augroup END
        ]],
        true
    )
end
