-- Colorscheme
-- Using it instead of `arcticicestudio/nord-vim` because of nicer errors and theme overall
return {
    "shaunsingh/nord.nvim",
    dependencies = "xiyaowong/nvim-transparent", -- Makes nvim background transparent
    init = function()
        vim.g.nord_disable_background = true
        vim.g.transparent_enabled = true -- enable transparent.nvim
    end,
    config = function()
        require("nord").set()
        vim.cmd.colorscheme("nord")
    end,
}
