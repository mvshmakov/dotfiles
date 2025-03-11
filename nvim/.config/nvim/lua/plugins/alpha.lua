-- Starting screen dashboard
return {
    "goolord/alpha-nvim",
    requires = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local alpha = require("alpha")
        local theme = require("alpha.themes.theta")
        local dashboard = require("alpha.themes.dashboard")

        -- "neovim" in Armenian language
        -- theme.header.val = {
        --     [[⠀⣶⡖⠒⠒⠒⠒⣶⠀⠀⠀⠀⠀⢠⣶⠒⠒⠒⠒⢲⡆⠀⠀⠀⠀⠀⣰⣶⠒⠒⠒⠒⠒⠒⠒⠲⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⣶⠶⠶⠶⠶⢶⣶⠒⠒⠒⠒⢲⣶⠀⠀⠀⠀⠀⣰⣶⠒⠒⠒⠒⢲⣶⠒⠒⠒⠒⠒⠒⣶⠀]],
        --     [[⢸⣿⣇⡀⠀⠀⠀⣿⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠘⠛⠛⠛⠛⠛⠛⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢷⣦⣀⣀⣀⣀⣀⣀⣿⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⢸⣿⣀⣀⠀⠀⠀⣿⣿⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⣀⣿⠀]],
        --     [[⢸⣿⡿⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⣿⣿⠀⠀⠀⠀⢰⣶⡆⠀⠀⠀⠀⣿⡏⠉⠉⠉⠉⣿⣿⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠈⠉⠉⠉⠻⢦⣄⣿⣿⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⣿⠋⠀]],
        --     [[⢸⣿⡇⠀⠀⠀⠀⣿⣿⠛⠛⠛⠛⢻⣿⠀⠀⠀⠀⢸⣿⡟⠛⠛⠛⠛⣿⣿⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⣿⠀⠀]],
        --     [[⢸⣿⡇⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⣿⣷⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⣿⠀⠀]],
        --     [[⢸⣿⣧⡀⠀⠀⠀⣿⣿⠀⠀⠀⠀⢸⣿⣦⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⣿⣿⣿⣿⣦⣀⣀⣀⠀⠀⠀⠀⢸⣿⡀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⣿⠀⠀]],
        --     [[⠈⢻⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⣿⠈⠻⣿⣿⣿⣿⣿⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⡿⠀⠀]],
        --     [[⠀⠀⠙⣿⣿⣷⣤⣤⣤⣤⣤⣤⣤⣼⡏⠻⣿⣿⣦⣤⣤⣤⣤⣤⣤⣤⣿⣿⣤⣤⣤⣤⣼⣿⡇⠀⠀⠀⠀⣿⠀⠀⠀⠉⣿⣿⣿⣤⣤⣤⣤⣼⣿⣧⣤⣤⣤⣤⣿⠉⠉⠉⠉⠉⣿⣿⣤⣤⣤⣤⣤⣤⣤⣴⣿⡿⠛⠁⠀⠀]],
        --     [[⠀⠀⠀⠈⠻⠿⠿⠿⠿⠿⠿⠿⠿⠿⠁⠀⠙⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⢿⣿⣷⣶⣶⣶⣶⣿⠀⠀⠀⠀⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠇⠀⠀⠀⠀⠀⠿⠿⠿⠿⠿⠿⠿⠿⠿⠟⠋⠀⠀⠀⠀⠀]],
        --     [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠿⠿⠿⠿⠿⠿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
        -- }

        -- "neovim" in Armenian language with a different font
        theme.header.val = {
            [[⠀⠀⠀⢠⣤⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⠀⠀⠀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⠀⠀⠀⠀⠀]],
            [[⠀⠀⠀⢸⣿⣿⣤⣤⡄⡀⠀⠀⠀⠀⠀⠀⠀⠀⢛⢻⣿⣇⣃⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡛⣿⣿⢸⠀⠀⢛⢻⣿⣿⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⢛⣛⣸⠀⠀⠀⠀]],
            [[⠀⠀⠀⠐⢭⣍⣿⣿⡇⡇⠀⠀⠀⠀⠀⠀⠀⠀⠈⢸⣿⡟⣛⣛⣛⣛⣛⣸⡆⢠⣤⣤⣤⣄⣤⣶⣶⣄⢀⠀⠀⢠⣤⣤⣤⢀⠀⠀⣿⣿⢸⡆⠀⠀⢸⣿⣿⣨⣴⣶⣦⡄⡀⠀⠀⣤⣤⣤⡄⡀⠀⢻⣿⡎⣇⠀⠀⠀⠀⠀]],
            [[⠀⠀⠀⠀⠀⠀⣿⣿⡇⡇⠀⢰⣶⣶⣶⣶⡆⡄⠀⢸⣿⡇⣿⢰⣶⣶⡆⣄⠀⠈⠍⣿⣿⡟⣩⡍⣿⣿⡏⡆⠀⠈⠍⣿⣿⢸⡆⠀⣿⣿⢸⡇⠀⠀⠸⣿⣿⢋⣭⡹⣿⣿⢰⠀⠀⠩⢹⣿⡇⣿⠀⢸⣿⡇⣿⠀⠀⠀⠀⠀]],
            [[⠀⠀⠀⠀⠀⠀⢻⣿⡇⣧⠀⢰⢸⣿⣿⢰⠶⠇⠀⢸⣿⡇⣿⠰⣸⣿⡇⣿⠀⠀⠀⣿⣿⡇⡏⠀⢿⣿⡇⡇⠀⠀⠀⣿⣿⢸⡇⢀⣿⣿⢸⡇⠀⠀⠀⣿⣿⢸⡅⠀⣿⣿⢸⡇⠀⠀⢸⣿⡇⣿⠀⣸⣿⡇⣿⠀⠀⠀⠀⠀]],
            [[⠀⠀⠀⠀⠀⠀⠘⢿⣿⣮⣤⣼⣾⡿⢃⡟⠀⠀⠀⠘⣿⣿⣶⡾⢻⣿⣷⣶⢠⡀⣶⣿⣿⣷⡆⣤⢸⣿⣷⣶⢠⠀⠀⢿⣿⣷⣶⠟⣿⣿⢸⡇⠀⠀⠀⣿⣿⢸⡇⠀⣿⣿⣶⡆⡄⠀⠘⣿⣿⣶⡾⢻⣿⣷⣶⢠⡀⠀⠀⠀]],
            [[⠀⠀⠀⠀⠀⠀⠀⠀⠂⠭⣭⣭⣴⠶⠛⠀⠀⠀⠀⠀⠐⠩⣥⡶⠔⠲⠶⠶⠾⠇⠒⠶⠶⠶⠶⠿⠐⠶⠶⠶⠾⠀⠀⠀⠊⢭⣴⠆⣿⣿⠸⠇⠀⠀⠀⣿⣿⠸⠇⠀⠲⠶⠶⠶⠿⠀⠀⠐⠩⣥⡶⠔⠲⠶⠶⠾⠇⠀⠀⠀]],
            [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠿⠿⠿⠿⠿⢸⡿⠿⠿⠿⢸⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
            [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
        }

        theme.buttons.val = {
            { type = "text", val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
            { type = "padding", val = 1 },
            dashboard.button("e", "  New file", "<cmd>ene<CR>"),
            dashboard.button("SPC f f", "󰈞  Find file"),
            dashboard.button("SPC f s", "󰊄  Live grep"),
            -- TODO: do not work due to keymap conflicts
            -- dashboard.button("o", "  Git status", "<leader>gs"),
            -- dashboard.button("c", "  Configuration", "<cmd>cd ~/.config/nvim/ <CR>"),
            dashboard.button("u", "  Update plugins", "<cmd>Lazy sync<CR>"),
            dashboard.button("q", "󰅚  Quit", "<cmd>qa<CR>"),
        }

        alpha.setup(theme.config)

        vim.keymap.set("n", "<leader>pd", "<CMD>Alpha<CR>", { desc = "Open alpha dashboard" })
    end,
}
