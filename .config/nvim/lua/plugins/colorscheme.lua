return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
    },
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    priority = 999,
    opts = {
      fallback = "dark",
      set_dark_mode = function()
        vim.o.background = "dark"
        vim.cmd.colorscheme("tokyonight-night")
      end,
      set_light_mode = function()
        vim.o.background = "light"
        vim.cmd.colorscheme("kanagawa-lotus")
      end,
    },
  },
}
