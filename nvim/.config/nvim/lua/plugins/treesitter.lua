-- Treesitter - improves highlighting + is a dependency of Telescope
-- Official recommendation from homebrew/neovim to install it
-- Check if it gets enabled: :TSModule
return {
    -- :TSUpdate updates the parsers which helps to be on the cutting edge
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-context", -- Adds a context line on top of editor window
        "nvim-treesitter/playground", -- Exposes Treesitter AST through :TSPlaygroundToggle
        "windwp/nvim-ts-autotag", -- Automatically close and rename HTML tags
        "JoosepAlviste/nvim-ts-context-commentstring", -- Sets commentstring based on the cursor location
    },
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "typescript",
                "javascript",
                "tsx",
                "lua",
                "org", -- for orgmode
                "vim",
                "vimdoc",
            },
            -- The list of parsers to ignore installing
            ignore_installed = {
                "latex", -- As suggested in h vimtex-faq-treesitter"
            },
            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,
            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
            auto_install = true,
            highlight = {
                enable = true, -- false will disable the whole extension
                disable = { "latex" }, -- as suggested in ":h vimtex-faq-treesitter"
                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
            context_commentstring = { enable = true },
            autotag = { enable = true },
            query_linter = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gnn", -- set to `false` to disable one of the mappings
                    node_incremental = "grn",
                    scope_incremental = "grc",
                    node_decremental = "grm",
                },
            },
        })
    end,
}
