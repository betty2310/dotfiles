local ok, treesitter = pcall(require, "nvim-treesitter.configs")

if ok then
    treesitter.setup {
        ensure_installed = "all",
        highlight = {
            enable = true,
        },
    }
end
