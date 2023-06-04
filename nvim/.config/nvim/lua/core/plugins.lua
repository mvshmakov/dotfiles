-- Official guide: https://github.com/folke/lazy.nvim#-installation
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

-- Vim's <leader> key is a way of creating a namespace for commands
-- you want to define. Vim already maps most keys and combinations
-- of Ctrl + (some key), so <leader>(some key) should be used for
-- custom stuff.
-- Required to setup before the lazy call, otherwise the wrong leader will be used
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Lua will concatenate all the files within the plugins directory
return require("lazy").setup("plugins")
