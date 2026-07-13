-- Status line. Alternatives:
-- { "vim-airline/vim-airline", dependencies = "vim-airline/vim-airline-themes" }
return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
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
                        -- Shows LSP progress (native replacement for the
                        -- archived lualine-lsp-progress.nvim)
                        function()
                            return vim.lsp.status()
                        end,
                        -- Extracted from nord color pallette
                        color = { fg = "#81A1C1" },
                    },
                },
                lualine_x = { "encoding", "fileformat", "filetype" },
            },
        })
    end,
}
