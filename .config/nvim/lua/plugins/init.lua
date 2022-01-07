local packer = require "plugins.packerInit"
local use = packer.use

return packer.startup(function()
    use { "wbthomason/packer.nvim" }
    use { "lewis6991/impatient.nvim" }

    -- UI (Color, statusline, dashboard...)
    use { "rmehri01/onenord.nvim" }
    use { "L3MON4D3/LuaSnip" }
    use { "kyazdani42/nvim-web-devicons", config = require "plugins.config.icons" }
    use {
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
        config = require "plugins.config.lualine",
    }
    use {
        "goolord/alpha-nvim",
        config = require "plugins.config.alpha",
    }
    use {
        "akinsho/bufferline.nvim",
        requires = { "kyazdani42/nvim-web-devicons" },
        config = require "plugins.config.bufferline",
    }
    use { "folke/which-key.nvim" }

    -- Coding utilities
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate", config = require "plugins.config.treesitter" }
    use { "windwp/nvim-ts-autotag" }
    use { "p00f/nvim-ts-rainbow" }
    use {
        "kyazdani42/nvim-tree.lua",
        requires = {
            "kyazdani42/nvim-web-devicons",
        },
        config = require "plugins.config.nvimtree",
    }
    use {
        "nvim-telescope/telescope.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = require "plugins.config.telescope",
    }
    use { "blackCauldron7/surround.nvim", config = require "plugins.config.surround" }
    use { "lukas-reineke/indent-blankline.nvim", config = require "plugins.config.indent" }
    use { "akinsho/toggleterm.nvim", config = require "plugins.config.toggleterm" }
    use { "windwp/nvim-autopairs", config = require "plugins.config.autopairs" }
    use { "norcalli/nvim-colorizer.lua" }
    use { "karb94/neoscroll.nvim", config = require "plugins.config.neoscroll" }
    use { "liuchengxu/vista.vim" }
    use { "simrat39/symbols-outline.nvim" }
    use {
        "max397574/better-escape.nvim",
        config = require "plugins.config.escape",
    }
    use { "ggandor/lightspeed.nvim" }
    use { "iamcco/markdown-preview.nvim" }

    -- LSP
    use { "neovim/nvim-lspconfig" }
    use { "williamboman/nvim-lsp-installer" }

    -- -- Lint
    use { "folke/lsp-colors.nvim" }
    --use { "jasonrhansen/lspsaga.nvim", branch = "finder-preview-fixes" }
    use { "tami5/lspsaga.nvim" }
    use { "folke/trouble.nvim" }
    use { "ray-x/lsp_signature.nvim", branch = "neovim-0.6" }

    -- -- Comment
    use { "numToStr/Comment.nvim", config = require "plugins.config.comment" }

    -- -- Completion
    use { "hrsh7th/nvim-cmp" }
    use { "hrsh7th/cmp-nvim-lsp" }
    use { "hrsh7th/cmp-nvim-lua" }
    use { "hrsh7th/cmp-buffer" }
    use { "hrsh7th/cmp-path" }
    use { "hrsh7th/cmp-cmdline" }
    use { "hrsh7th/cmp-nvim-lsp-document-symbol" }
    use { "saadparwaiz1/cmp_luasnip" }
    use { "hrsh7th/cmp-calc" }

    -- -- Formatter and Linting
    use {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            require("null-ls").setup()
        end,
        requires = { "nvim-lua/plenary.nvim" },
    }

    -- Tmux
    use { "aserowy/tmux.nvim", config = require "plugins.config.tmux" }

    -- Git
    use {
        "lewis6991/gitsigns.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
        },
        config = require "plugins.config.gitsigns",
    }
end)
