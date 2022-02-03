require "theme"
require "settings"
require "plugins"
require "lsp"
require "mappings"
require "impatient"

local dap_install = require "dap-install"

dap_install.setup {
    installation_path = vim.fn.stdpath "data" .. "/dapinstall/",
}
