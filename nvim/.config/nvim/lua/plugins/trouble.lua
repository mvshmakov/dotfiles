return {
    "folke/trouble.nvim", -- better diagnostics list and others
    cmd = { "TroubleToggle", "Trouble" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        {
            "<leader>xx",
            "<cmd>TroubleToggle<cr>",
            "n",
            desc = "Toggle diagnostics",
        },
        {
            "<leader>xw",
            "<cmd>TroubleToggle workspace_diagnostics<cr>",
            "n",
            desc = "Toggle workspace diagnostics",
        },
        {
            "<leader>xd",
            "<cmd>TroubleToggle document_diagnostics<cr>",
            "n",
            desc = "Toggle document diagnostics",
        },
        {
            "<leader>xl",
            "<cmd>TroubleToggle loclist<cr>",
            "n",
            desc = "Toggle loclist",
        },
        {
            "<leader>xq",
            "<cmd>TroubleToggle quickfix<cr>",
            "n",
            desc = "Toggle quickfix",
        },
        {
            "gR",
            "<cmd>TroubleToggle lsp_references<cr>",
            "n",
            desc = "Toggle lsp references",
        },
        opts = {
            mode = "document_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
            auto_close = true, -- automatically close the list when you have no diagnostics
            use_lsp_diagnostic_signs = true, -- enabling this will use the signs defined in your lsp client
        },
    },
}
