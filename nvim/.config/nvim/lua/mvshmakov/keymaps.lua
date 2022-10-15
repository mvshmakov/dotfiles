-- Shorten function name
local keymap = vim.keymap.set
-- Tells neovim to show no message when this key sequence is used.
local opts = { silent = true }

--[[
    Vim's <leader> key is a way of creating a namespace for commands
    you want to define. Vim already maps most keys and combinations
    of Ctrl + (some key), so <leader>(some key) should be used for
    custom stuff.
--]]
--Remap comma as leader key
keymap("", ",", "<Nop>", opts)
vim.g.mapleader = ","
--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Disable arrow keys completely
keymap("", "<Up>", "<Nop>", opts)
keymap("", "<Down>", "<Nop>", opts)
keymap("", "<Left>", "<Nop>", opts)
keymap("", "<Right>", "<Nop>", opts)

-- Find files using Telescope command-line sugar
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)
keymap("n", "<leader>fh", ":Telescope help_tags<CR>", opts)

-- Clear search highlights on pressing \ (backslash) twice
keymap("n", "\\", ":noh<CR>", opts)

-- TODO: set this up for lua
-- vim.g.sessions_dir = "$XDG_STATE_HOME/nvim/sessions"
-- exec 'nnoremap <Leader>ss :Obsession ' . g:sessions_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'
-- nnoremap <Leader>sp :Obsession<CR>
