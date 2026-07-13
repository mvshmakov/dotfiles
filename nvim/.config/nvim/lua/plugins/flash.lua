-- Jump around the buffer with search labels. Its treesitter mode (S) is the
-- replacement for the incremental_selection module that was dropped in the
-- nvim-treesitter `main` rewrite: S shows labeled selections for every
-- treesitter node around the cursor, ; and , grow/shrink the selection.
return {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
        modes = {
            -- Keep the stock f/F/t/T motions: ; and , are owned by the
            -- repeatable moves of nvim-treesitter-textobjects instead
            char = { enabled = false },
        },
    },
    -- The upstream-recommended keymaps. NOTE: s/S shadow the rarely used
    -- built-in substitute motions (cl/cc are their exact equivalents)
    keys = {
        {
            "s",
            mode = { "n", "x", "o" },
            function()
                require("flash").jump()
            end,
            desc = "Flash",
        },
        {
            "S",
            mode = { "n", "x", "o" },
            function()
                require("flash").treesitter()
            end,
            desc = "Flash Treesitter (incremental selection)",
        },
        {
            "r",
            mode = "o",
            function()
                require("flash").remote()
            end,
            desc = "Remote Flash",
        },
        {
            "R",
            mode = { "o", "x" },
            function()
                require("flash").treesitter_search()
            end,
            desc = "Treesitter Search",
        },
        {
            "<c-s>",
            mode = "c",
            function()
                require("flash").toggle()
            end,
            desc = "Toggle Flash Search",
        },
    },
}
