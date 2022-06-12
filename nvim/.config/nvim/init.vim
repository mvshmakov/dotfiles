" `:options` will give the description of the options

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
" Make sure you use single quotes

" Plugins {{{
call plug#begin('$XDG_DATA_HOME/nvim/plugged')
" Replace the 'surroundings', e.g., parenthesis, XML, etc.
" Use cs"' to replace double quote by the single one.
" To replace something to a tag, use cst
Plug 'tpope/vim-surround'
" Comment stuff out (V + gc to toggle)
Plug 'tpope/vim-commentary'
" Align tabular structures (as markdown tables or text)
Plug 'godlygeek/tabular'
" Make cursors available on several lines
Plug 'terryma/vim-multiple-cursors'

" Mainly because it is required for the telescope
Plug 'nvim-lua/plenary.nvim'
" File explorer
Plug 'nvim-telescope/telescope.nvim'
" Improves highlighting + is a dependency of telescope
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Autocompletion {{{
Plug 'github/copilot.vim'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'
"}}}

" VIM IDE stuff {{{
" NERD tree will be loaded on the first invocation of NERDTreeToggle command
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
" Plugin outside ~/.nvim/plugged with post-update hook
" TODO: use ths thing or fzf.vim?
Plug 'junegunn/fzf', { 'do': './install --all', 'on': 'FZF' }
" Database exploration tool
Plug 'tpope/vim-dadbod'
" For git commands inside VIM
Plug 'tpope/vim-fugitive'
" Allows to open GPG-encrypted files and edit them natively without decryption
Plug 'jamessan/vim-gnupg'
" For the +- inside the files
Plug 'airblade/vim-gitgutter'
" For saving vim sessions
Plug 'tpope/vim-obsession'
" Shows which key was pressed and what is available further
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

" Preview CSS colors as bg of the same HEX
Plug 'ap/vim-css-color'
" post install (yarn install | npm install) then load plugin only for editing supported files
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install --frozen-lockfile --production',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }
" }}}

" Appearance
" Nord theme
Plug 'arcticicestudio/nord-vim'
" TODO: how to speedup the loading process of Airline?
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Requires nerd-fonts to be installed
Plug 'ryanoasis/vim-devicons'

" Initialize plugin system
call plug#end()
" }}}

" Bypass true colours https://github.com/tmux/tmux/issues/1246
if exists('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Embedding LUA as the config will be migrated to it in the future
" lua << EOF
" require'lspinstall'.setup()
" local servers = require'lspinstall'.installed_servers()
" for _, server in pairs(servers) do
"   require'lspconfig'[server].setup{}
" end
" EOF

syntax on
" Does nothing related to the vim-plug, enables ftplugins
" https://vi.stackexchange.com/questions/4541/vundle-filetype-plugin-indent-on-messes-with-tabwidth
filetype plugin indent on

colorscheme nord
" Enable underline font support https://www.nordtheme.com/docs/ports/vim/configuration#underline-style
let g:nord_underline = 1

" Enable auto-formatting despite the '// @format' option at the top of the
" file. In addition, if the config is not present, just abort formatting.
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
let g:prettier#autoformat_config_present = 1

" For the corner-like separators
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

let NERDTreeShowHidden=1

" Providers executables {{{
set pyxversion=3
" Disabling python runtime checks as very slow
let g:python_host_skip_check=1
let g:python3_host_skip_check=1

if executable('python3')
    let g:python3_host_prog = exepath('python3')
else
    let g:loaded_python3_provider=0
endif

if executable('neovim-node-host')
    let g:node_host_prog = exepath('neovim-node-host')
else
    let g:loaded_node_provider=0
end

" Disabling unused providers
let g:loaded_python_provider=0
let g:loaded_perl_provider=0
let g:loaded_ruby_provider=0
"}}}
"
let mapleader = ","
let maplocalleader = " "

" Basic configuration {{{
" Enable all features of VIM
set nocompatible
set encoding=UTF-8

set spelllang=en_us,ru
set spellsuggest=best,9
set number relativenumber
set cursorline
" Colorize the brackets pair
set showmatch
" Soft wrap the long lines
set linebreak
" Allow folding of the code blocks
set foldenable
set foldmethod=marker
" Make search case insensitive
set ignorecase
" Include the smart case search matching
set smartcase
" Use system clipboard
set clipboard+=unnamedplus
" Use mouse selection and scroll, replaces tmux feature
set mouse=a
" Define tab as 4 spaces
set tabstop=4
"}}}
" Suggestions in command mode
set wildmenu
set wildmode=full
" TextEdit might fail if hidden is not set (coc.nvim)
set hidden

" The following is from https://csswizardry.com/2017/03/configuring-git-and-vim/
" Force the cursor onto a new line after 80 characters
set textwidth=80
" However, in Git commit messages, let's make it 72 characters
autocmd FileType gitcommit set textwidth=72
" Colour the 81st (or 73rd) column so that we don't type over our limit
set colorcolumn=+1
" In Git commit messages, also colour the 51st column (for titles)
autocmd FileType gitcommit set colorcolumn+=51

" Recognize DVC files as yaml
autocmd! BufNewFile,BufRead Dvcfile,*.dvc,dvc.lock setfiletype yaml

" Center cursor always
autocmd CursorMoved,CursorMovedI * call CentreCursor()
function! CentreCursor()
    let pos = getpos(".")
    normal! zz
    call setpos(".", pos)
endfunction

" Mappings{{{
" Disable arrow keys completely
noremap <Up>    <Nop>
noremap <Down>  <Nop>
noremap <Left>  <Nop>
noremap <Right> <Nop>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files hidden=true<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

let g:sessions_dir = '$XDG_STATE_HOME/nvim/sessions'
exec 'nnoremap <Leader>ss :Obsession ' . g:sessions_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'
nnoremap <Leader>sp :Obsession<CR>

" Clear search highlights on pressing \ (backslash) twice
nnoremap \\ :noh<return>
"}}}
