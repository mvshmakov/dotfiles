--[[ Modes:
-- * normal_mode = "n",
-- * insert_mode = "i",
-- * visual_mode = "v",
-- * visual_block_mode = "x",
-- * term_mode = "t",
-- * command_mode = "c"
--]]

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open netrw explorer" })

vim.keymap.set("n", "\\", ":noh<CR>", { desc = "Clear search highlights on pressing \\\\ (double backslash)" })
vim.keymap.set("n", "<cr>", "ciw", { desc = "Change inside the word" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv==kgvo<esc>=kgvo", { desc = "Move highlighted text down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv==jgvo<esc>=jgvo", { desc = "Move highlighted text up" })

-- TODO: set this up
-- vim.g.sessions_dir = "$XDG_STATE_HOME/nvim/sessions"
-- exec 'nnoremap <Leader>ss :Obsession ' . g:sessions_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'
-- nnoremap <Leader>sp :Obsession<CR>
