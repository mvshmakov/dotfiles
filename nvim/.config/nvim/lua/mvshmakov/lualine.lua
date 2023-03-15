local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
    return
end

local hide_in_width = function()
    return vim.fn.winwidth(0) > 80
end

local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn" },
    symbols = { error = " ", warn = " " },
    always_visible = true,
}

local diff = {
    "diff",
    cond = hide_in_width,
}

lualine.setup({
    options = {
        globalstatus = true,
        refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
        },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { diagnostics },
        lualine_c = { diff, "branch" },
        lualine_x = { "encoding", "fileformat", "filetype" },
    },
})
