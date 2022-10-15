local status_ok, mason = pcall(require, "mason")
if not status_ok then
    return
end

local servers = {
    "sumneko_lua",
    "cssls",
    "html",
    "tsserver",
    "pyright",
    "bashls",
    "jsonls",
    "yamlls",
}

mason.setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
    return
end

local opts = {}

for _, server in pairs(servers) do
    opts = {
        on_attach = require("mvshmakov.lsp.handlers").on_attach,
        capabilities = require("mvshmakov.lsp.handlers").capabilities,
    }

    if server == "sumneko_lua" then
        local sumneko_opts = require "mvshmakov.lsp.settings.sumneko_lua"
        opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
    end

    if server == "pyright" then
        local pyright_opts = require "mvshmakov.lsp.settings.pyright"
        opts = vim.tbl_deep_extend("force", pyright_opts, opts)
    end

    lspconfig[server].setup(opts)
end

-- require('mason-tool-installer').setup {

--     -- a list of all tools you want to ensure are installed upon
--     -- start; they should be the names Mason uses for each tool
--     ensure_installed = {

--         -- you can pin a tool to a particular version
--         { 'golangci-lint', version = 'v1.47.0' },

--         -- you can turn off/on auto_update per tool
--         { 'bash-language-server', auto_update = true },

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

--     -- if set to true this will check each tool for updates. If updates
--     -- are available the tool will be updated. This setting does not
--     -- affect :MasonToolsUpdate or :MasonToolsInstall.
--     -- Default: false
--     auto_update = false,

--     -- automatically install / update on startup. If set to false nothing
--     -- will happen on startup. You can use :MasonToolsInstall or
--     -- :MasonToolsUpdate to install tools and check for updates.
--     -- Default: true
--     run_on_start = true,

--     -- set a delay (in ms) before the installation starts. This is only
--     -- effective if run_on_start is set to true.
--     -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
--     -- Default: 0
--     start_delay = 3000, -- 3 second delay
-- }
