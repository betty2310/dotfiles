return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          enabled = false,
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = {},
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      opts.sources = vim.tbl_filter(function(source)
        return source.name ~= "markdownlint_cli2"
      end, opts.sources or {})
    end,
  },
}
