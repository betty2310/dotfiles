local ok, lsp_signature = pcall(require, "lsp_signature")

if ok then
    lsp_signature.setup {
        hint_prefix = "🦊 ",
        use_lspsaga = true,
    }
end
