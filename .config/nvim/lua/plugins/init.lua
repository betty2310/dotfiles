local ok, packer = pcall(require, "plugins.packerInit")
local setupFrom = require("utils").setupFrom

if ok then
    local use = packer.use

    return packer.startup(function()
        use { "wbthomason/packer.nvim" }
        -- UI (Color, statusline, dashboard...)
        use { "kyazdani42/nvim-web-devicons", config = setupFrom "icons" }
        use { "rmehri01/onenord.nvim" }
        use { "shaunsingh/nord.nvim" }
        use {
            "catppuccin/nvim",
            as = "catppuccin",
        }
        use { "easymotion/vim-easymotion" }
        use {
            "glepnir/galaxyline.nvim",
            branch = "main",
            config = setupFrom "galaxyline",
            requires = { "kyazdani42/nvim-web-devicons" },
        }
        use {
            "glepnir/dashboard-nvim",
            config = setupFrom "dashboard",
        }
        use {
            "akinsho/bufferline.nvim",
            requires = { "kyazdani42/nvim-web-devicons" },
            config = setupFrom "bufferline",
        }

        -- Coding utilities
        use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate", config = setupFrom "treesitter" }
        use {
            "kyazdani42/nvim-tree.lua",
            requires = { "kyazdani42/nvim-web-devicons" },
            config = setupFrom "nvimtree",
        }
        use {
            "nvim-telescope/telescope.nvim",
            requires = { "nvim-lua/plenary.nvim" },
            config = setupFrom "telescope",
        }
        use { "blackCauldron7/surround.nvim", config = setupFrom "surround" }
        use { "lukas-reineke/indent-blankline.nvim", config = setupFrom "indent" }
        use { "akinsho/toggleterm.nvim", config = setupFrom "toggleterm" }
        use { "windwp/nvim-autopairs", config = setupFrom "autopairs" }
        use { "norcalli/nvim-colorizer.lua" }
        use { "karb94/neoscroll.nvim", config = setupFrom "neoscroll" }
        use { "liuchengxu/vista.vim" }
        use { "simrat39/symbols-outline.nvim" }

        -- LSP
        use { "neovim/nvim-lspconfig" }
        use { "williamboman/nvim-lsp-installer" }

        -- -- Lint
        use { "folke/lsp-colors.nvim" }
        use { "glepnir/lspsaga.nvim" }
        use { "folke/trouble.nvim" }
        use { "ray-x/lsp_signature.nvim" }

        -- -- Comment
        use { "terrortylor/nvim-comment", config = setupFrom "commenter" }

        -- -- Completion
        use { "hrsh7th/nvim-cmp" }
        use { "hrsh7th/cmp-nvim-lsp" }
        use { "hrsh7th/cmp-buffer" }
        use { "hrsh7th/cmp-path" }
        use { "hrsh7th/cmp-cmdline" }
        use { "L3MON4D3/LuaSnip" }
        use { "saadparwaiz1/cmp_luasnip" }

        -- -- Formatter
        use { "mhartington/formatter.nvim" }

        -- -- Debugger
        use { "puremourning/vimspector" }

        -- Tmux
        use { "christoomey/vim-tmux-navigator" }

        -- Git
        use {
            "lewis6991/gitsigns.nvim",
            requires = {
                "nvim-lua/plenary.nvim",
            },
            config = setupFrom "gitsigns",
        }
    end)
end
