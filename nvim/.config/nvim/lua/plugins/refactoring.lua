-- Allows for things like "extract to a variable" or "inline a variable", etc.
-- TODO: fix some keymaps being overridden by another plugins
return {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
        { "lewis6991/async.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
    },
    config = function()
        require("refactoring").setup({})

        local map = vim.keymap.set

        -- The refactor functions are operators: they return "g@" (expr
        -- mapping), so they act on a visual selection or a pending motion
        map({ "n", "x" }, "<leader>re", function()
            return require("refactoring").extract_func()
        end, { desc = "Extract Function", expr = true })
        map({ "n", "x" }, "<leader>rf", function()
            return require("refactoring").extract_func_to_file()
        end, { desc = "Extract Function To File", expr = true })
        map({ "n", "x" }, "<leader>rv", function()
            return require("refactoring").extract_var()
        end, { desc = "Extract Variable", expr = true })
        map({ "n", "x" }, "<leader>ri", function()
            return require("refactoring").inline_var()
        end, { desc = "Inline Variable", expr = true })
        map({ "n", "x" }, "<leader>rI", function()
            return require("refactoring").inline_func()
        end, { desc = "Inline Function", expr = true })

        -- NOTE: "Extract Block" (<leader>rb / <leader>rbf) was removed
        -- upstream; use <leader>re with a selection/motion instead

        -- Prompt for a refactor to apply when the remap is triggered
        map({ "n", "x" }, "<leader>rbr", function()
            require("refactoring").select_refactor()
        end, { desc = "Select refactor" })

        -- Insert a debug print statement with the location under cursor
        map("n", "<leader>rp", function()
            return require("refactoring.debug").print_loc({ output_location = "above" })
        end, { desc = "Debug print location", expr = true })

        -- Cleanup the debug print statements; operator as well, so provide a
        -- textobject/motion for the range to clean up
        map({ "n", "x" }, "<leader>rc", function()
            return require("refactoring.debug").cleanup({ restore_view = true })
        end, { desc = "Debug print cleanup", expr = true })
    end,
}
