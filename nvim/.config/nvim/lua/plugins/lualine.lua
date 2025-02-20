-- Status line. Alternatives:
-- { "vim-airline/vim-airline", dependencies = "vim-airline/vim-airline-themes" }
return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "WhoIsSethDaniel/lualine-lsp-progress.nvim", -- Shows LSP progress
    },
    config = function()
        local lualine = require("lualine")

        lualine.setup({
            theme = "nord",
            options = {
                globalstatus = true,
                refresh = {
                    statusline = 100,
                    tabline = 100,
                    winbar = 100,
                },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                        sections = { "error", "warn" },
                        always_visible = true,
                    },
                },
                lualine_c = {
                    "diff",
                    "branch",
                    "filename",
                    {
                        "lsp_progress",
                        -- Extracted from nord color pallette
                        colors = {
                            percentage = "#81A1C1",
                            title = "#D8DEE9",
                            message = "#b48ead",
                            spinner = "#a3be8c",
                            lsp_client_name = "#81A1C1",
                            use = true,
                        },
                    },
                },
                lualine_x = { "encoding", "fileformat", "filetype" },
            },
        })
    end,
}
