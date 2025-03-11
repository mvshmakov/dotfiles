-- Telescope - file explorer
return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-telescope/telescope-github.nvim",
        "nvim-telescope/telescope-media-files.nvim",
        "jvgrootveld/telescope-zoxide",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- native C-based implementation of fzf for use inside Telescope
        -- Utils
        "nvim-lua/plenary.nvim", -- Required for the telescope-zoxide
        "nvim-lua/popup.nvim", -- Required for the telescope-zoxide
    },
    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")
        local actions = require("telescope.actions")

        telescope.setup({
            find_command = { "rg", "--files", "--hidden" },
            defaults = {
                prompt_prefix = " ",
                selection_caret = " ",
                path_display = { "smart" },
                file_ignore_patterns = { ".git", "node_modules" },
                use_less = true,
                picker = {
                    find_files = {
                        find_command = { "rg", "--files", "--hidden" },
                    },
                },
                -- Parameters for the live grep
                vimgrep_arguments = {
                    "rg",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--hidden",
                    -- To trim the indentation at the beginning of presented line in the result window
                    "--trim",
                },
                mappings = {
                    i = {
                        ["<Down>"] = actions.cycle_history_next,
                        ["<Up>"] = actions.cycle_history_prev,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                    },
                },
                -- TODO: setup telescope image preview, e.g., https://alpha2phi.medium.com/neovim-101-image-viewer-7f5d35db637a,
                -- or https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#use-terminal-image-viewer-to-preview-images
            },
        })

        -- Extensions must be loaded after the `setup` call
        telescope.load_extension("zoxide")
        telescope.load_extension("media_files")
        telescope.load_extension("gh")
        telescope.load_extension("fzf")
        telescope.load_extension("neoclip")
        -- TODO: replace default refactoring UI with telescope
        -- telescope.load_extension("refactoring")

        -- Setting up the keymaps after the plugin was loaded
        -- TODO: figure out how to pass `hidden` parameter into the `builtin.find_files`
        vim.keymap.set("n", "<leader>ff", ":Telescope find_files hidden=true<CR>", { desc = "Find files" })
        vim.keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Live grep" })
        vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
        vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Recently opened files" })
        vim.keymap.set("n", "<leader>fz", telescope.extensions.zoxide.list, { desc = "Zoxide" })

        vim.keymap.set("n", "<leader>fgf", builtin.git_files, { desc = "Git files" })
        vim.keymap.set("n", "<leader>fgc", builtin.git_commits, { desc = "Git commits" })
        vim.keymap.set("n", "<leader>fgb", builtin.git_branches, { desc = "Git branches" })
        vim.keymap.set("n", "<leader>fgs", builtin.git_stash, { desc = "Git list stashes" })
    end,
}
