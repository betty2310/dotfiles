if vim.g.vscode then
  vim.opt.clipboard:append("unnamedplus")
  return
end

require("vim._core.ui2").enable({
  enable = true,
})

require("config.lazy")
