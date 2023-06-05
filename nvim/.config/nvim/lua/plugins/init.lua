return {
    "github/copilot.vim",

    {
        "akinsho/bufferline.nvim", -- Fancy way to view tabs + integrations
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
    },
    "RRethy/vim-illuminate", -- highlights the word under the cursor (kind of as a *)
    {
        "nvim-orgmode/orgmode", -- orgmode for neovim
        config = function()
            local orgmode = require("orgmode")

            orgmode.setup()
            orgmode.setup_ts_grammar()
        end,
    },
    { "petertriho/nvim-scrollbar", config = {} }, -- purely to faster see the diagnostics

    -- Replace the 'surroundings', e.g., parenthesis, XML, etc.
    -- Use cs"' to replace double quote by the single one. To replace something to a tag, use cst
    "tpope/vim-surround",
    "terryma/vim-multiple-cursors", -- make cursors available on several lines
    {
        "lukas-reineke/indent-blankline.nvim", -- show indentation lines
        config = {
            show_current_context = true,
            show_current_context_start = true,
        },
    },

    {
        "phaazon/hop.nvim", -- jump to any character in the line conveniently with fFtT
        config = function()
            local hop = require("hop")
            local directions = require("hop.hint").HintDirection

            hop.setup()

            vim.keymap.set("", "f", function()
                hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
            end, { remap = true, desc = "Hop to char as f" })

            vim.keymap.set("", "F", function()
                hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
            end, { remap = true, desc = "Hop to char as F" })

            vim.keymap.set("", "t", function()
                hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
            end, { remap = true, desc = "Hop to char as t" })

            vim.keymap.set("", "T", function()
                hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
            end, { remap = true, desc = "Hop to char as T" })
        end,
    },

    "tpope/vim-dadbod", -- database exploration tool
    "jamessan/vim-gnupg", -- open GPG-encrypted files and edit them natively without decryption

    "tpope/vim-obsession", -- save neovim sessions

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            plugins = {
                presets = {
                    operators = true, -- adds help for operators like d, y, ...
                    motions = true, -- adds help for motions
                    text_objects = true, -- help for text objects triggered after entering an operator
                    windows = true, -- default bindings on <c-w>
                    nav = true, -- misc bindings to work with windows
                    z = true, -- bindings for folds, spelling and others prefixed with z
                    g = true, -- bindings for prefixed with g
                },
            },
            motions = {
                count = true,
            },
            show_keys = true, -- show the currently pressed key and its label as a message in the command line
            triggers = "auto", -- automatically setup triggers
        },
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
    },

    -- Debug Adapter Protocol (DAP)
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",

    {
        "AckslD/nvim-neoclip.lua", -- clipboard manager
        dependencies = {
            { "kkharji/sqlite.lua", module = "sqlite" }, -- use persistent history between sessions
        },
    },

    -- Comments with `gc` + TODO lists
    { "numToStr/comment.nvim", config = { enable = true } },
    {
        "folke/todo-comments.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            local todo_comments = require("todo-comments")
            vim.keymap.set("n", "<leader>t]", todo_comments.jump_next, { desc = "Next todo comment" })
            vim.keymap.set("n", "<leader>t[", todo_comments.jump_prev, { desc = "Previous todo comment" })
        end,
    },

    -- Git
    {
        "airblade/vim-gitgutter",
        init = function()
            -- GitGutter update gap: https://github.com/airblade/vim-gitgutter#when-signs-take-a-few-seconds-to-appear
            vim.opt.updatetime = 100 -- faster completion (4000ms default)
        end,
    }, -- +- signs inside the files
    "kdheepak/lazygit.nvim", -- lazygit support
    {
        "tpope/vim-fugitive",
        init = function()
            vim.keymap.set("n", "<leader>gs", "<CMD>vertical Git<CR>", { desc = "Git status" })
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        dependencies = "petertriho/nvim-scrollbar",
        config = function()
            require("gitsigns").setup()
            require("scrollbar.handlers.gitsigns").setup()
        end,
    },
    "f-person/git-blame.nvim", -- git blame
    -- Generate GitHub shareable links
    {
        "ruifm/gitlinker.nvim",
        dependencies = "nvim-lua/plenary.nvim",
    },

    -- Direnv integration (proper hook execution + .envrc syntax)
    "direnv/direnv.vim",

    -- Markdown
    "godlygeek/tabular", -- Align tabular structures (as markdown tables or text)

    -- LaTex
    {
        "lervag/vimtex",
        init = function()
            vim.g.vimtex_view_method = "zathura"
        end,
    },

    -- CSS
    "ap/vim-css-color", -- preview CSS colors as bg of the same HEX

    -- Manpages
    "paretje/nvim-man", -- use man pages inside neovim

    -- Utils
    "smithbm2316/centerpad.nvim", -- Centers vim buffer
}
