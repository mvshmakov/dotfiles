local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    print("Installing packer close and reopen Neovim...")
    vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
    },
})

-- Install your plugins here
-- TODO: add harpoon
return packer.startup(function(use)
    use("wbthomason/packer.nvim") -- have Packer manage itself
    -- use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter
    -- use "kyazdani42/nvim-tree.lua"
    -- use "akinsho/bufferline.nvim"
    -- use "moll/vim-bbye"
    use("akinsho/toggleterm.nvim")
    -- use "ahmedkhalf/project.nvim"
    -- use "lewis6991/impatient.nvim"
    -- use "lukas-reineke/indent-blankline.nvim"
    -- use "goolord/alpha-nvim"
    -- use "SmiteshP/nvim-navic"
    use("github/copilot.vim")
    --[[
    Replace the 'surroundings', e.g., parenthesis, XML, etc.
    Use cs"' to replace double quote by the single one.
    To replace something to a tag, use cst
    --]]
    use("tpope/vim-surround")
    use("terryma/vim-multiple-cursors") -- make cursors available on several lines
    use("tpope/vim-dadbod") -- database exploration tool
    use("jamessan/vim-gnupg") -- open GPG-encrypted files and edit them natively without decryption
    use("tpope/vim-obsession") -- save vim sessions
    -- TODO: 'on': ['WhichKey', 'WhichKey!']
    use("liuchengxu/vim-which-key") -- Shows which key was pressed and what is available further
    use("RRethy/vim-illuminate") -- highlights the word under the cursor (kind of as a *)

    -- Colorschemes
    use("arcticicestudio/nord-vim")
    -- use "folke/tokyonight.nvim"
    -- use "lunarvim/darkplus.nvim"

    -- Status line
    use("kyazdani42/nvim-web-devicons")
    use("nvim-lualine/lualine.nvim")
    -- use { "vim-airline/vim-airline" }
    -- use { "vim-airline/vim-airline-themes" }

    -- Visual appearance
    use({
        "xiyaowong/nvim-transparent", -- Makes nvim background transparent
        config = function()
            require("transparent").setup()
        end,
    })

    -- Completion plugins
    use({
        "hrsh7th/nvim-cmp",
        requires = {
            use("hrsh7th/cmp-buffer"), -- buffer completions
            use("hrsh7th/cmp-path"), -- path completions
            use("saadparwaiz1/cmp_luasnip"), -- snippet completions
            use("hrsh7th/cmp-nvim-lsp"),
            use("hrsh7th/cmp-nvim-lua"),
        },
    })

    -- Snippets
    use("L3MON4D3/LuaSnip") --snippet engine
    use("rafamadriz/friendly-snippets") -- a bunch of snippets to use including VSCode-like

    -- 3rd party packages manager (DAP, LSP, etc.)
    use("williamboman/mason.nvim")
    use("WhoIsSethDaniel/mason-tool-installer.nvim") -- auto-installs mason tools from hardcoded list
    use("RubixDev/mason-update-all") -- adds MasonUpdateAll command to update all mason deps

    -- Language Server Protocol (LSP)
    use("neovim/nvim-lspconfig") -- contains default LSP configurations
    use("williamboman/mason-lspconfig.nvim") -- mason <> lspconfig bridge

    -- Formatters and linters
    use("jose-elias-alvarez/null-ls.nvim")
    use("jayp0521/mason-null-ls.nvim") -- mason <> null-ls bridge

    -- Debug Adapter Protocol (DAP)
    use("mfussenegger/nvim-dap")
    use("rcarriga/nvim-dap-ui")
    use("jayp0521/mason-nvim-dap.nvim")

    -- Telescope - file explorer
    use("nvim-telescope/telescope.nvim")
    use("nvim-telescope/telescope-media-files.nvim")
    use("nvim-telescope/telescope-github.nvim")
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- native C-based implementation of fzf for use inside Telescope
    use("nvim-telescope/telescope-z.nvim") -- z integration with Telescope
    use({
        "AckslD/nvim-neoclip.lua", -- clipboard manager
        requires = {
            { "kkharji/sqlite.lua", module = "sqlite" }, -- use persistent history between sessions
        },
    })

    -- Treesitter - improves highlighting + is a dependency of Telescope
    -- Official recommendation from homebrew/neovim to install it
    -- :TSUpdate updates the parsers which helps to be on the cutting edge
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    use("nvim-treesitter/nvim-treesitter-context") -- Adds a context line on top of editor window

    -- Comments with `gc` + TODO lists
    use({
        "numToStr/comment.nvim",
        config = function()
            require("comment").setup({ enable = true })
        end,
    })
    use("JoosepAlviste/nvim-ts-context-commentstring")
    use({
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup()
        end,
    })

    -- Git
    use("airblade/vim-gitgutter") -- +- signs inside the files
    use("tpope/vim-fugitive") -- git commands inside nvim
    use("kdheepak/lazygit.nvim") -- lazygit support
    -- use("lewis6991/gitsigns.nvim")

    -- Direnv integration (proper hook execution + .envrc syntax)
    use("direnv/direnv.vim")

    -- Markdown
    use("godlygeek/tabular") -- Align tabular structures (as markdown tables or text)

    -- LaTex
    use("lervag/vimtex")

    -- CSS
    use("ap/vim-css-color") -- preview CSS colors as bg of the same HEX

    -- Manpages
    use("paretje/nvim-man") -- use man pages inside neovim

    -- Utils
    use("nvim-lua/plenary.nvim") -- Useful lua functions used by lots of plugins (Telescope, etc.)
    use("nvim-lua/popup.nvim") -- Required for the telescope-z
    use("smithbm2316/centerpad.nvim") -- Centers vim buffer
    use("mbbill/undotree") -- Visualize undo tree

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
