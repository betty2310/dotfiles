-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader><leader>", function()
  require("fff").find_files()
end, { desc = "FFFind files" })

vim.keymap.set("n", "<leader>/", function()
  require("fff").live_grep()
end, { desc = "FFFind files" })

vim.keymap.set("n", "fw", function()
  require("fff").live_grep()
end, { desc = "FFFind files" })
