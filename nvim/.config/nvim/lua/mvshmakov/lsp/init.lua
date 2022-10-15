local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    return
end

require('mason-update-all').setup()

require "mvshmakov.lsp.mason"
require("mvshmakov.lsp.handlers").setup()
-- TODO: pass ensure_installed = {'stylua', 'jq'} with servers list
require("mason-lspconfig").setup()

require "mvshmakov.lsp.null-ls"
-- TODO: pass ensure_installed = {'stylua', 'jq'} with servers list
require("mason-null-ls").setup()

