-- Disable unneeded host providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8" -- the encoding written to a file

vim.opt.spelllang = "en_us,ru"
vim.opt.spellsuggest = "best,9"

vim.opt.mouse = "a" -- allow the mouse to be used for selection and scroll in neovim, replaces tmux feature
vim.opt.mousefocus = true -- automatically focus the cursor in the terminal after entering insert mode

vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard

vim.opt.number = true -- show the line numbers
vim.opt.relativenumber = true -- show the relative line numbers
vim.opt.cursorline = true -- highlight the current line
vim.opt.showmatch = true -- colorize the brackets pair
vim.opt.linebreak = true -- soft wrap the long lines

vim.opt.foldenable = false -- Disable folding
vim.opt.foldmethod = "syntax" -- Allow folding of the code blocks

vim.opt.ignorecase = true -- ignore case in search patterns
vim.opt.hlsearch = true -- highlight all matches on previous search pattern
vim.opt.smartcase = true -- include the smart case search matching

vim.opt.tabstop = 4 -- define tab as 4 spaces
vim.opt.shiftwidth = 4 -- the number of spaces inserted for each indentation
vim.opt.softtabstop = 4 -- number of spaces in tab when editing
vim.opt.autoindent = true
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.smartindent = true -- make indenting smarter again

-- Netrw file explorer settings
vim.g.netrw_banner = 0 -- hide banner above files
vim.g.netrw_liststyle = 3 -- tree instead of plain view
vim.g.netrw_browse_split = 3 -- open new file in the right split
vim.g.netrw_preview = 1 -- preview file on the right split

vim.opt.scrolloff = 999 -- keeps cursor in the center of screen if possible
vim.opt.sidescrolloff = 8 -- keeps 8 chars from left/right of the screen when scrolling

vim.opt.backup = false -- do not create a backup file
vim.opt.undofile = true -- enable persistent undo

vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.splitright = true -- force all vertical splits to go to the right of current window

-- The following is from https://csswizardry.com/2017/03/configuring-git-and-vim/
-- Force the cursor onto a new line after 80 characters
vim.opt.textwidth = 80
vim.opt.colorcolumn = "+1" -- colour the 81st column so that we don't type over our limit

vim.opt.completeopt = { "menu", "menuone", "preview" }
vim.opt.showmode = false -- we don't need to see things like -- INSERT -- as we have lualine

vim.opt.conceallevel = 0 -- so that `` is visible in markdown files
vim.opt.pumheight = 10 -- completion pop up menu height (otherwise it is huge)
vim.opt.termguicolors = true -- set term gui colors

vim.opt.splitkeep = "screen"
-- Improves diff mode: https://github.com/neovim/neovim/pull/14537
vim.opt.diffopt:append("linematch:60")
