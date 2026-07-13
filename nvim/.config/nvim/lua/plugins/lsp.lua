-- Language Server Protocol (LSP) support
return {
    -- Provides the default server configurations consumed by the native
    -- vim.lsp.config()/vim.lsp.enable() API (Neovim 0.11+)
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp", -- advertises nvim-cmp completion capabilities to the servers
        "nvimtools/none-ls.nvim", -- maintained fork of null-ls (keeps the require("null-ls") API)
        {
            "williamboman/mason.nvim", -- 3rd party packages manager (DAP, LSP, etc.) (optional)
            build = ":MasonUpdate",
        },
        "williamboman/mason-lspconfig.nvim", -- Mason <-> lspconfig bridge (optional)
        "jayp0521/mason-null-ls.nvim", -- mason <> null-ls bridge (allows to specify formatters to install)
        "jayp0521/mason-nvim-dap.nvim", -- Mason <-> nvim-dap bridge (optional)
        -- At least adds the MasonUpdateAllComplete event to hook into
        { "RubixDev/mason-update-all", opts = {} }, -- adds MasonUpdateAll command to update all mason deps
    },
    config = function()
        -- Must run before the servers launch: prepends the mason bin dir to
        -- $PATH (lua-language-server & co. are installed through mason)
        require("mason").setup({ ui = { border = "rounded" } })

        -- Buffer-local keymaps, equivalent to the default_keymaps() of the
        -- since-removed lsp-zero
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspKeymaps", {}),
            callback = function(event)
                local map = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
                end

                map("n", "K", vim.lsp.buf.hover, "Hover documentation")
                map("n", "gd", vim.lsp.buf.definition, "Go to definition")
                map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
                map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
                map("n", "go", vim.lsp.buf.type_definition, "Go to type definition")
                map("n", "gr", vim.lsp.buf.references, "List references")
                map("n", "gs", vim.lsp.buf.signature_help, "Signature help")
                map("n", "gl", vim.diagnostic.open_float, "Show diagnostic")
                map("n", "<F2>", vim.lsp.buf.rename, "Rename symbol")
                map({ "n", "x" }, "<F3>", function()
                    vim.lsp.buf.format({ async = true })
                end, "Format buffer")
                map("n", "<F4>", vim.lsp.buf.code_action, "Code action")
            end,
        })

        -- Completion capabilities for every server
        local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        if ok then
            vim.lsp.config("*", { capabilities = cmp_nvim_lsp.default_capabilities() })
        end

        -- Tell neovim explicitly where to lookup lua 3rd party packages
        local library = vim.api.nvim_get_runtime_file("", true)
        table.insert(library, "${3rd}/luassert/library")
        table.insert(library, "${3rd}/luv/library")

        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    runtime = {
                        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                        version = "LuaJIT",
                    },
                    diagnostics = {
                        globals = {
                            "vim", -- Set globals for vim and neovim
                        },
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = library,
                    },
                    -- Do not send telemetry data containing a randomized but unique identifier
                    telemetry = {
                        enable = false,
                    },
                },
            },
        })

        -- vim.lsp.config("eslint", {
        --   settings = {
        --     enable = true,
        --     format = { enable = true }, -- this will enable formatting
        --     autoFixOnSave = true,
        --     codeActionsOnSave = {
        --       mode = "all",
        --       rules = { "!debugger", "!no-only-tests/*" },
        --     },
        --     lintTask = {
        --       enable = true,
        --     },
        --   }
        -- })

        vim.lsp.enable({
            "lua_ls",
            -- "eslint",
        })

        require("mason-null-ls").setup({
            automatic_setup = true,
            automatic_installation = true,
            -- TODO: here goes all formatters/linters
            -- https://github.com/jay-babu/mason-null-ls.nvim#primary-source-of-truth-is-mason-null-ls
            ensure_installed = {
                "lua_ls",
            },
        })

        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                -- null_ls.builtins.formatting.prettierd,
                -- null_ls.builtins.formatting.eslint_d,
                -- null_ls.builtins.formatting.prettier_eslint,
            },
            on_attach = function(client, bufnr)
                if client:supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({
                                bufnr = bufnr,
                                filter = function(cl)
                                    return cl.name == "null-ls"
                                end,
                            })
                        end,
                    })
                end
            end,
        })

        vim.keymap.set("n", "gn", function()
            vim.diagnostic.jump({ count = 1, float = true })
        end, { desc = "Navigate to the next diagnostic" })
        vim.keymap.set("n", "gp", function()
            vim.diagnostic.jump({ count = -1, float = true })
        end, { desc = "Navigate to the previous diagnostic" })
    end,
}
