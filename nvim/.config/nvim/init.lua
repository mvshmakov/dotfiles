-- Adds byte-compilcation and caching of lua, added in 0.9.0
-- https://github.com/neovim/neovim/blob/release-0.9/runtime/doc/news.txt
vim.loader.enable()

require("core.plugins")
require("core.keymaps")
require("core.autocommands")
require("core.options")
