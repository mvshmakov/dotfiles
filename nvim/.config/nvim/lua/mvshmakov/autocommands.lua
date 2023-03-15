-- Format file on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    callback = function()
        vim.lsp.buf.format()
    end,
})

-- Recognize DVC files as yaml
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "Dvcfile", "*.dvc", "dvc.lock" },
    callback = function()
        vim.opt.setfiletype = "yaml"
    end,
})

-- Make help appear on the horizontal split
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    callback = function()
        vim.cmd([[
			if &ft ==# 'help' | wincmd L | endif
		]])
    end,
})

-- Open PDF files in Zathura
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = { "*.pdf" },
    callback = function()
        vim.cmd([[
			execute "!zathura '%'" | bdelete %
		]])
    end,
})

-- TODO: skeleton
-- vim.api.nvim_create_autocmd({ "BufNewFile" }, {
--     pattern = { "*.sh" },
-- })
