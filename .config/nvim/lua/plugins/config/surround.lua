local ok, surround = pcall(require, "surround")

if ok then
    surround.setup { mappings_style = "surround" }
end
