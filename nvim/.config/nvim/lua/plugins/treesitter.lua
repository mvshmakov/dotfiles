-- Treesitter - improves highlighting + is a dependency of Telescope
-- Official recommendation from homebrew/neovim to install it
-- Check if it gets enabled: :TSModule
-- nvim-treesitter/playground is obsolete since 0.9.0. :IspectTree now is :TSPlaygroundToggle
return {
    -- :TSUpdate updates the parsers which helps to be on the cutting edge
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "UIEnter",
    cmd = { "TSUpdate", "TSUpdateSync" }, -- Needed for headless runs such as: nvim --headless -c "TSUpdateSync" +qa
    dependencies = {
        { "nvim-treesitter/nvim-treesitter-context", opts = { separator = "-" } }, -- Adds a context line on top of editor window
        "nvim-treesitter/nvim-treesitter-refactor",
        "nvim-treesitter/nvim-treesitter-textobjects",
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
                "org", -- for orgmode files
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
            refactor = {
                -- "RRethy/vim-illuminate" alternative (highlights the word under the cursor; kind of as a *), but is LSP-aware
                highlight_definitions = { enable = true },
                -- highlight_current_scope = { enable = true }, -- Produces too much noize
                navigation = { enable = true },
                smart_rename = {
                    enable = true,
                    -- Assign keymaps to false to disable them, e.g. `smart_rename = false`.
                    keymaps = {
                        smart_rename = "grr",
                    },
                },
            },
            textobjects = {
                select = {
                    enable = true,
                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        -- You can optionally set descriptions to the mappings (used in the desc parameter of
                        -- nvim_buf_set_keymap) which plugins like which-key display
                        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                        -- You can also use captures from other query groups like `locals.scm`
                        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                    },
                    -- You can choose the select mode (default is charwise 'v')
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * method: eg 'v' or 'o'
                    -- and should return the mode ('v', 'V', or '<c-v>') or a table
                    -- mapping query_strings to modes.
                    selection_modes = {
                        ["@parameter.outer"] = "v", -- charwise
                        ["@function.outer"] = "V", -- linewise
                        ["@class.outer"] = "<c-v>", -- blockwise
                    },
                },
                swap = {
                    -- allows to swap found textobjects
                    enable = true,
                    swap_next = {
                        ["<leader>a"] = "@parameter.inner",
                    },
                    swap_previous = {
                        ["<leader>A"] = "@parameter.inner",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        ["]m"] = "@function.outer",
                        ["]]"] = { query = "@class.outer", desc = "Next class start" },
                        --
                        -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
                        ["]o"] = "@loop.*",
                        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
                        --
                        -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
                        -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
                        ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
                        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
                    },
                    goto_next_end = {
                        ["]M"] = "@function.outer",
                        ["]["] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[m"] = "@function.outer",
                        ["[["] = "@class.outer",
                    },
                    goto_previous_end = {
                        ["[M"] = "@function.outer",
                        ["[]"] = "@class.outer",
                    },
                    -- Below will go to either the start or the end, whichever is closer.
                    -- Use if you want more granular movements
                    -- Make it even more gradual by adding multiple queries and regex.
                    goto_next = {
                        ["]d"] = "@conditional.outer",
                    },
                    goto_previous = {
                        ["[d"] = "@conditional.outer",
                    },
                },
                lsp_interop = {
                    enable = true,
                    border = "none",
                    floating_preview_opts = {},
                    peek_definition_code = {
                        ["<leader>df"] = "@function.outer",
                        ["<leader>dF"] = "@class.outer",
                    },
                },
            },
        })
    end,
}
