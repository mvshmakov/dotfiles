vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8" -- the encoding written to a file

vim.opt.spelllang = "en_us,ru"
vim.opt.spellsuggest = "best,9"
vim.opt.smartcase = true -- include the smart case search matching

vim.opt.mouse = "a" -- allow the mouse to be used for selection and scroll in neovim, replaces tmux feature
vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard

vim.opt.relativenumber = true
vim.opt.cursorline = true -- highlight the current line
vim.opt.showmatch = true -- colorize the brackets pair
vim.opt.linebreak = true -- soft wrap the long lines

-- Allow folding of the code blocks
vim.opt.foldmethod = "syntax"

vim.opt.ignorecase = true -- ignore case in search patterns

vim.opt.tabstop = 4 -- define tab as 4 spaces
vim.opt.shiftwidth = 4 -- the number of spaces inserted for each indentation

-- GitGutter update gap: https://github.com/airblade/vim-gitgutter#when-signs-take-a-few-seconds-to-appear
vim.opt.updatetime = 100 -- faster completion (4000ms default)

-- --[[
--     The following is from https://csswizardry.com/2017/03/configuring-git-and-vim/
--     Force the cursor onto a new line after 80 characters
-- --]]
-- vim.opt.textwidth = 80
-- -- However, in Git commit messages, let's make it 72 characters
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--     pattern = { "gitcommit" },
--     callback = function()
--         vim.opt.textwidth = 72
--     end,
-- })
-- vim.opt.colorcolumn = vim.opt.colorcolumn + 1 -- colour the 81st (or 73rd) column so that we don't type over our limit
-- -- In Git commit messages, also colour the 51st column (for titles)
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--     pattern = { "gitcommit" },
--     callback = function()
--         vim.opt.colorcolumn = vim.opt.colorcolumn + 51
--     end,
-- })

-- Enable underline font support https://www.nordtheme.com/docs/ports/vim/configuration#underline-style
-- vim.g.nord_underline = 1

-- -- Corner-like separators
-- vim.g.airline_powerline_fonts = 1
-- vim.g.airline.extensions.tabline.enabled = 1
-- vim.g.airline.extensions.tabline.formatter = "unique_tail_improved"

-- -- Netrw file explorer settings
vim.g.netrw_banner = 0 -- hide banner above files
vim.g.netrw_liststyle = 3 -- tree instead of plain view
vim.g.netrw_browse_split = 3 -- open new file in the right split
-- vim.g.netrw_winsize = 15 -- width of the netrw window in percentages
vim.g.netrw_preview = 1 -- preview file on the right split

vim.g.vimtex_view_method = "zathura"
vim.g.transparent_enabled = true -- enable transparent.nvim

vim.opt.scrolloff = 999 -- keeps cursor in the center of screen if possible
vim.opt.sidescrolloff = 8 -- keeps 8 chars from left/right of the screen when scrolling

vim.opt.swapfile = false -- creates a swapfile
vim.opt.backup = false -- creates a backup file

-- TODO: validate the following
vim.opt.cmdheight = 1 -- more space in the neovim command line for displaying messages
vim.opt.completeopt = { "menu", "menuone", "noselect" } -- mostly just for cmp
vim.opt.conceallevel = 0 -- so that `` is visible in markdown files
vim.opt.hlsearch = true -- highlight all matches on previous search pattern
vim.opt.pumheight = 10 -- pop up menu height
vim.opt.showmode = false -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 0 -- always show tabs
vim.opt.smartindent = true -- make indenting smarter again
vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.splitright = true -- force all vertical splits to go to the right of current window
vim.opt.termguicolors = true -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 1000 -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true -- enable persistent undo
vim.opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.number = true -- set numbered lines
vim.opt.laststatus = 3
vim.opt.showcmd = false
vim.opt.ruler = false
vim.opt.numberwidth = 4 -- set number column width to 2 {default 4}
vim.opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false -- display lines as one long line
vim.opt.guifont = "monospace:h17" -- the font used in graphical neovim applications
vim.opt.fillchars.eob = " "
vim.opt.shortmess:append("c")
vim.opt.whichwrap:append("<,>,[,],h,l")
vim.opt.iskeyword:append("-")
