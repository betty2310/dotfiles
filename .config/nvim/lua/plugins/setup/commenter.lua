local ok, nvim_comment = pcall(require, "nvim_comment")
if ok then
    nvim_comment.setup {
        comment_empty = false,
    }
end
