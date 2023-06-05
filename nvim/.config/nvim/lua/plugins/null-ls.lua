-- Formatters support
return {
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = "jayp0521/mason-null-ls.nvim", -- mason <> null-ls bridge (allows to specify formatters to install)
        config = function()
            local null_ls = require("null-ls")
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.eslint_d.with({
                        filetypes = {
                            "typescript",
                            "javascript",
                            "typescriptreact",
                            "javascriptreact",
                        },
                    }),
                    null_ls.builtins.formatting.lua_format,
                    null_ls.builtins.diagnostics.eslint_d,
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.prettierd.with({
                        filetypes = {
                            "css",
                            "scss",
                            "less",
                            "html",
                            "json",
                            "jsonc",
                            "yaml",
                            "markdown",
                            "markdown.mdx",
                            "graphql",
                            "handlebars",
                        },
                    }),
                },
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
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
        end,
    },
}
