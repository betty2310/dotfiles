-- C/C++ (clangd) tweaks layered on top of the `lazyvim.plugins.extras.lang.clangd`
-- extra (enabled in lazyvim.json). That extra wires up clangd, inlay hints, and
-- clangd_extensions; here we only add two buffer-local toggles that apply *while
-- clangd is attached to a C/C++ buffer*.
--
-- Why this works as a plain `keys` table: LazyVim declares
--   opts_extend = { "servers.*.keys" }
-- on nvim-lspconfig, so the entries below are APPENDED to clangd's existing keys
-- (e.g. <leader>ch = Switch Source/Header) instead of overwriting them. LazyVim
-- resolves server `keys` through an LSP filter, making them buffer-local and only
-- active once the matching server attaches.

-- Snacks.toggle objects are built lazily on first keypress: `Snacks` isn't loaded
-- yet when this spec file is required at startup, but it is by the time a C/C++
-- buffer exists and a key is pressed. Memoized so each toggle is created once.
-- `bufnr = 0` always means "the current buffer" -- correct here because the keymaps
-- are buffer-local, so the current buffer is always the clangd buffer.
local inlay, diag

local function inlay_toggle()
  inlay = inlay
    or Snacks.toggle({
      name = "Inlay Hints (clangd)",
      get = function()
        return vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
      end,
      set = function(state)
        vim.lsp.inlay_hint.enable(state, { bufnr = 0 })
      end,
    })
  return inlay
end

local function diag_toggle()
  diag = diag
    or Snacks.toggle({
      name = "Diagnostics (clangd)",
      get = function()
        return vim.diagnostic.is_enabled({ bufnr = 0 })
      end,
      set = function(state)
        vim.diagnostic.enable(state, { bufnr = 0 })
      end,
    })
  return diag
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          keys = {
            -- Toggle clangd inlay hints for the current C/C++ buffer.
            -- `has = "inlayHint"` only maps this if clangd advertises textDocument/inlayHint.
            {
              "<leader>uH",
              function()
                inlay_toggle():toggle()
              end,
              desc = "Toggle Inlay Hints (clangd)",
              has = "inlayHint",
            },
            -- Toggle ALL diagnostics for the current C/C++ buffer. clangd is the only
            -- diagnostic source in these buffers, so this effectively shows/hides
            -- clangd's errors + warnings + hints.
            {
              "<leader>uD",
              function()
                diag_toggle():toggle()
              end,
              desc = "Toggle Diagnostics (clangd)",
            },
          },
        },
      },
    },
  },
}
