-- Autocompletion
-- TODO: Make sure you setup `cmp` after lsp-zero
return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        -- Completion sources
        "hrsh7th/cmp-nvim-lsp", -- LSP completions
        "hrsh7th/cmp-nvim-lua", -- Nvim Lua API completions
        "hrsh7th/cmp-buffer", -- buffer completions
        "hrsh7th/cmp-path", -- path completions
        "petertriho/cmp-git", -- git completions
        "hrsh7th/cmp-cmdline", -- command line completions

        "windwp/nvim-autopairs", -- autopairs

        -- Icons for the completion sources
        "onsails/lspkind.nvim",

        -- Snippets
        -- Composing frieldy-snippets inside the LuaSnip as in docs:
        -- https://github.com/rafamadriz/friendly-snippets#with-lazynvim
        {
            "L3MON4D3/LuaSnip", --snippet engine
            dependencies = { "rafamadriz/friendly-snippets" }, -- a bunch of snippets including VSCode-like
        },
        "saadparwaiz1/cmp_luasnip", -- snippet completions
    },
    config = function()
        local cmp = require("cmp")
        local lspkind = require("lspkind")
        local nvim_autopairs = require("nvim-autopairs")
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")

        local luasnip = require("luasnip")
        require("luasnip.loaders.from_vscode").load()

        cmp.setup({
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
            formatting = {
                format = lspkind.cmp_format({
                    -- defines how annotations are shown
                    -- default: symbol
                    -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
                    mode = "symbol_text",
                    -- Show the source of the completion item
                    menu = {
                        buffer = "[Buffer]",
                        nvim_lsp = "[LSP]",
                        luasnip = "[LuaSnip]",
                        nvim_lua = "[Lua]",
                        latex_symbols = "[Latex]",
                    },
                }),
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
            }),
            sources = cmp.config.sources({
                { name = "luasnip" },
                { name = "nvim_lsp" },
                { name = "nvim_lua" },
                { name = "buffer" },
                { name = "path" },
            }),
        })

        nvim_autopairs.setup({
            check_ts = true, -- consult with treesitter
        })
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

        -- Set configuration for specific filetype.
        cmp.setup.filetype("gitcommit", {
            sources = cmp.config.sources({
                { name = "git" },
            }, {
                { name = "buffer" },
            }),
        })

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                { name = "cmdline" },
            }),
        })
    end,
}
