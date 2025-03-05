-- TODO: it is a nicer way to define the skeletons as it allows for more
-- granularity of the initial cursor pos
vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.go",
    command = "0r ~/.config/nvim/skeleton/skeleton.go | normal Gdd6G$bb",
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    desc = "Format file on save",
    callback = function()
        vim.lsp.buf.format()
    end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    desc = "Make help appear on the horizontal split",
    command = "if &ft ==# 'help' | wincmd L | endif",
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = { "*.pdf" },
    desc = "Open PDF files in Zathura",
    command = "execute \"!zathura '%'\" | bdelete %",
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    desc = "Disable <CR> remaps in the quickfix window",
    pattern = { "quickfix" },
    callback = function()
        vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "<CR>", { noremap = true })
    end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "gitcommit" },
    desc = "For git commit messages, making textwidth 72 characters and colouring the 51st column for the header",
    callback = function()
        vim.opt.textwidth = 72
        vim.opt.colorcolumn = "+1,51"
    end,
})

vim.api.nvim_create_autocmd("VimResized", {
    desc = "Auto resize window splits on terminal resize",
    group = vim.api.nvim_create_augroup("win_autoresize", { clear = true }),
    command = "wincmd =",
})

-- https://github.com/shaunsingh/nord.nvim/issues/143#issuecomment-1517044478
vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Disable semantic tokens while nord theme does not support them properly",
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        client.server_capabilities.semanticTokensProvider = nil
    end,
})
