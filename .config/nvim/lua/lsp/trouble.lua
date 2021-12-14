local ok, trouble = pcall(require, "trouble")

if ok then
    trouble.setup {
        use_diagnostic_signs = true,
    }
end
