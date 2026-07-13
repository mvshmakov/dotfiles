-- Treesitter - improves highlighting + is a dependency of Telescope
--
-- Uses the `main` rewrite of nvim-treesitter (the old `master` is frozen and
-- does not support nvim 0.12+): the plugin now only manages parsers/queries,
-- while highlighting/indentation are enabled through core Neovim APIs
-- (:h treesitter-highlight). Notes on the migration from `master`:
-- * incremental_selection module is gone -> flash.nvim treesitter mode (S)
-- * refactor module (archived) is gone -> vim-illuminate + LSP rename
-- * query_linter module is gone -> nvim lints query files natively
-- * lsp_interop (peek definition) of textobjects is gone without replacement
return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        -- Parsers must match the plugin's pinned revisions, so keep them in
        -- sync on every plugin update
        build = ":TSUpdate",
        lazy = false, -- the main branch does not support lazy-loading
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-context", opts = { separator = "-" } }, -- Adds a context line on top of editor window
            { "windwp/nvim-ts-autotag", opts = {} }, -- Automatically close and rename HTML tags
            {
                "JoosepAlviste/nvim-ts-context-commentstring", -- Sets commentstring based on the cursor location
                init = function()
                    -- The nvim-treesitter module integration is deprecated; the
                    -- plugin is set up standalone (via opts) instead
                    vim.g.skip_ts_context_commentstring_module = true
                end,
                opts = {},
            },
        },
        config = function()
            local ts = require("nvim-treesitter")

            -- Languages to never handle through nvim-treesitter:
            -- * latex - as suggested in ":h vimtex-faq-treesitter"
            -- * org - orgmode.nvim installs and manages its own parser
            local ignore = { "latex", "org" }

            -- Parsers to always have around (async; a no-op once installed).
            -- Everything else is auto-installed on demand by the autocmd below.
            ts.install({
                "typescript",
                "javascript",
                "tsx",
                "lua",
                "vim",
                "vimdoc",
                "query",
            })

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("UserTreesitter", {}),
                callback = function(ev)
                    local lang = vim.treesitter.language.get_lang(ev.match)
                    if not lang or vim.list_contains(ignore, lang) then
                        return
                    end

                    local function enable()
                        -- The buffer may be gone by the time an async install finishes
                        if not vim.api.nvim_buf_is_valid(ev.buf) then
                            return
                        end
                        vim.treesitter.start(ev.buf, lang)
                        -- Treesitter-based indentation (still experimental upstream)
                        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end

                    if vim.list_contains(ts.get_installed("parsers"), lang) then
                        enable()
                    elseif vim.list_contains(ts.get_available(), lang) then
                        -- Auto-install missing parsers when entering a buffer
                        -- (requires the tree-sitter CLI - see the Brewfile)
                        ts.install(lang):await(function(err)
                            if not err then
                                enable()
                            end
                        end)
                    end
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        init = function()
            -- Built-in ftplugins define buffer-local ]]/[[/]m/... maps that
            -- would shadow the global textobject maps below (the old master
            -- module won by setting buffer-local maps itself)
            vim.g.no_python_maps = true
        end,
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = {
                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,
                    -- You can choose the select mode (default is charwise 'v')
                    selection_modes = {
                        ["@parameter.outer"] = "v", -- charwise
                        ["@function.outer"] = "V", -- linewise
                        ["@class.outer"] = "<c-v>", -- blockwise
                    },
                },
                move = {
                    set_jumps = true, -- whether to set jumps in the jumplist
                },
            })

            local map = vim.keymap.set

            -- Select textobjects (capture groups defined in textobjects.scm)
            local function select(query, group)
                return function()
                    require("nvim-treesitter-textobjects.select").select_textobject(query, group or "textobjects")
                end
            end
            map({ "x", "o" }, "af", select("@function.outer"), { desc = "Select outer function" })
            map({ "x", "o" }, "if", select("@function.inner"), { desc = "Select inner function" })
            map({ "x", "o" }, "ac", select("@class.outer"), { desc = "Select outer class" })
            map({ "x", "o" }, "ic", select("@class.inner"), { desc = "Select inner part of a class region" })
            -- Captures from other query groups, like `locals.scm`
            map({ "x", "o" }, "as", select("@local.scope", "locals"), { desc = "Select language scope" })

            -- Swap textobjects under the cursor
            map("n", "<leader>a", function()
                require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
            end, { desc = "Swap with next parameter" })
            map("n", "<leader>A", function()
                require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
            end, { desc = "Swap with previous parameter" })

            -- Move to the next/previous textobject
            local function move(fn, query, group)
                return function()
                    require("nvim-treesitter-textobjects.move")[fn](query, group or "textobjects")
                end
            end
            map({ "n", "x", "o" }, "]m", move("goto_next_start", "@function.outer"), { desc = "Next function start" })
            map({ "n", "x", "o" }, "]]", move("goto_next_start", "@class.outer"), { desc = "Next class start" })
            map({ "n", "x", "o" }, "]o", move("goto_next_start", { "@loop.inner", "@loop.outer" }), { desc = "Next loop start" })
            map({ "n", "x", "o" }, "]s", move("goto_next_start", "@local.scope", "locals"), { desc = "Next scope" })
            map({ "n", "x", "o" }, "]z", move("goto_next_start", "@fold", "folds"), { desc = "Next fold" })
            map({ "n", "x", "o" }, "]M", move("goto_next_end", "@function.outer"), { desc = "Next function end" })
            map({ "n", "x", "o" }, "][", move("goto_next_end", "@class.outer"), { desc = "Next class end" })
            map({ "n", "x", "o" }, "[m", move("goto_previous_start", "@function.outer"), { desc = "Previous function start" })
            map({ "n", "x", "o" }, "[[", move("goto_previous_start", "@class.outer"), { desc = "Previous class start" })
            map({ "n", "x", "o" }, "[M", move("goto_previous_end", "@function.outer"), { desc = "Previous function end" })
            map({ "n", "x", "o" }, "[]", move("goto_previous_end", "@class.outer"), { desc = "Previous class end" })
            -- Go to either the start or the end, whichever is closer
            map({ "n", "x", "o" }, "]d", move("goto_next", "@conditional.outer"), { desc = "Next conditional" })
            map({ "n", "x", "o" }, "[d", move("goto_previous", "@conditional.outer"), { desc = "Previous conditional" })

            -- Make the movements above (and f/F/t/T) repeatable with ; and ,
            local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
            map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, { desc = "Repeat last move forward" })
            map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous, { desc = "Repeat last move backward" })
            map({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
            map({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
            map({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
            map({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
        end,
    },
}
