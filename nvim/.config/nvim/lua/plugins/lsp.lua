-- Language Server Protocol (LSP) support
return {
  "VonHeikemen/lsp-zero.nvim",
  branch = "v2.x",
  dependencies = {
    "neovim/nvim-lspconfig", -- Contains default LSP configurations (required)
    "jose-elias-alvarez/null-ls.nvim",
    {
      "williamboman/mason.nvim", -- 3rd party packages manager (DAP, LSP, etc.) (optional)
      build = ":MasonUpdate",
    },
    "williamboman/mason-lspconfig.nvim",        -- Mason <-> lspconfig bridge (optional)
    "jayp0521/mason-null-ls.nvim",              -- mason <> null-ls bridge (allows to specify formatters to install)
    "jayp0521/mason-nvim-dap.nvim",             -- Mason <-> nvim-dap bridge (optional)
    -- At least adds the MasonUpdateAllComplete event to hook into
    { "RubixDev/mason-update-all", opts = {} }, -- adds MasonUpdateAll command to update all mason deps
  },
  config = function()
    local lsp = require("lsp-zero")
    lsp.preset("recommended")

    lsp.on_attach(function(_, bufnr)
      lsp.default_keymaps({ buffer = bufnr })
    end)

    lsp.ensure_installed({
      -- TODO: setup this correctly
      -- 'tsserver',
      -- 'eslint',
      "lua_ls",
    })

    -- Tell neovim explicitly where to lookup lua 3rd party packages
    local library = vim.api.nvim_get_runtime_file("", true)
    table.insert(library, "${3rd}/luassert/library")
    table.insert(library, "${3rd}/luv/library")

    -- To setup the LSP servers, it is possible to use lspconfig directly:
    -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/lsp.md#configure-language-servers
    local lspconfig = require('lspconfig')
    lspconfig.lua_ls.setup({
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
          library = library
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    })


    -- lspconfig.eslint.setup({
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

    require("lspconfig.ui.windows").default_options.border = 'single'

    lsp.setup()

    require('mason').setup({ ui = { border = "rounded" } })
    require("mason-null-ls").setup({
      automatic_setup = true,
      -- TODO: here goes all formatters/linters
      -- https://github.com/jay-babu/mason-null-ls.nvim#primary-source-of-truth-is-mason-null-ls
      ensure_installed = {}
    })

    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    local null_ls = require('null-ls')

    null_ls.setup({
      sources = {
        -- null_ls.builtins.formatting.prettierd,
        -- null_ls.builtins.formatting.eslint_d,
        -- null_ls.builtins.formatting.prettier_eslint,
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
  end
}
