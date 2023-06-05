-- Language Server Protocol (LSP) support
return {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    dependencies = {
        "neovim/nvim-lspconfig", -- Contains default LSP configurations (required)
        {
            "williamboman/mason.nvim", -- 3rd party packages manager (DAP, LSP, etc.) (optional)
            build = ":MasonUpdate",
            dependencies = {
                "jayp0521/mason-nvim-dap.nvim", -- Mason <-> nvim-dap bridge (optional)
                "williamboman/mason-lspconfig.nvim", -- Mason <-> lspconfig bridge (optional)
                "RubixDev/mason-update-all", -- adds MasonUpdateAll command to update all mason deps
            },
        },
    },
    config = function()
        local lsp = require("lsp-zero")

        lsp.preset("recommended")

        lsp.on_attach(function(_, bufnr)
            lsp.default_keymaps({ buffer = bufnr })
        end)

        lsp.configure("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = {
                            "vim", -- Set globals for vim and neovim
                        },
                    },
                },
            },
        })

        lsp.setup()

        vim.keymap.set(
            "n",
            "gn",
            "<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
            { desc = "Navigate to the next diagnostic" }
        )
        vim.keymap.set(
            "n",
            "gp",
            "<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>",
            { desc = "Navigate to the previous diagnostic" }
        )
    end,
}
