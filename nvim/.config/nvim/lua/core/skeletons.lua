-- ":h Skeletons"
local skeletons = {
    sh = "~/.config/nvim/skeletons/skeleton.sh",
    bash = "~/.config/nvim/skeletons/skeleton.bash",
}

vim.api.nvim_create_autocmd("BufNewFile", {
    group = vim.api.nvim_create_augroup("skeletons", {}),
    pattern = { "*.sh", "*.bash" },
    desc = "Load skeleton when creating new file",
    callback = function(args)
        local ft = vim.api.nvim_buf_get_option(args.buf, "filetype")
        vim.cmd("0r " .. skeletons[ft])
    end,
})
