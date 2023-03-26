local status_ok, mason = pcall(require, "mason")
if not status_ok then
    return
end

mason.setup()

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
    return
end

local opts = {
    on_attach = require("mvshmakov.lsp.handlers").on_attach,
    capabilities = require("mvshmakov.lsp.handlers").capabilities,
}
local servers_to_customize = {
    "lua_ls",
    "pyright",
}
for _, server in pairs(servers_to_customize) do
    local module = "mvshmakov.lsp.settings." .. server
    local custom_opts = vim.tbl_deep_extend("force", require(module), opts)
    lspconfig[server].setup(custom_opts)
end
lspconfig["bashls"].setup(opts)
lspconfig["jsonls"].setup(opts)

local ltex_opts = vim.tbl_deep_extend("force", {
    cmd = { "ltex-ls" },
    filetypes = { "markdown", "text" },
    flags = { debounce_text_changes = 300 },
}, opts)
lspconfig["ltex"].setup(ltex_opts)

-- require('mason-tool-installer').setup {
--     -- a list of all tools you want to ensure are installed upon
--     -- start; they should be the names Mason uses for each tool
--     ensure_installed = {
--         'lua-language-server',
--         'vim-language-server',
--         'gopls',
--         'stylua',
--         'shellcheck',
--         'editorconfig-checker',
--         'gofumpt',
--         'golines',
--         'gomodifytags',
--         'gotests',
--         'impl',
--         'json-to-struct',
--         'luacheck',
--         'misspell',
--         'revive',
--         'shellcheck',
--         'shfmt',
--         'staticcheck',
--         'vint',
--     },

--     -- automatically install / update on startup. If set to false nothing
--     -- will happen on startup. You can use :MasonToolsInstall or
--     -- :MasonToolsUpdate to install tools and check for updates.
--     -- Default: true
--     run_on_start = true,
-- }
