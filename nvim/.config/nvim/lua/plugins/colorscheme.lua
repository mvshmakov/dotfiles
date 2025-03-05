-- Colorscheme
-- Using it instead of `nordtheme/vim` because of nicer errors and theme overall
return {
  "shaunsingh/nord.nvim",
  lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  init = function()
    vim.g.nord_disable_background = true
    vim.g.transparent_enabled = true         -- enable transparent.nvim
    vim.g.nord_borders = true                -- make borders more visible
    vim.g.nord_cursorline_transparent = true -- disable cursorline highlight
  end,
  dependencies = {
    "xiyaowong/transparent.nvim", -- Makes nvim background transparent
    opts = {
      extra_groups = {            -- Additional groups that should be cleared
        "Normal",
        "NormalFloat",            -- Plugins which have float panel such as Lazy, Mason, LspInfo
        "CursorLine",             -- Screen-line at the cursor, when 'cursorline' is set
        "WhichKeyFloat",          -- Which-key
        "FloatBorder",            -- Which-key border
        "Pmenu",                  -- For the cmp menu
      }
    }
  },
  config = function()
    require("nord").set()
    vim.cmd.colorscheme("nord")
  end,
}
