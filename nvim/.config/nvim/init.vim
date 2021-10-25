" `:options` will give the description of the options

set nocompatible

if has('nvim')
    " Neovim specific commands
else
    " Standard vim specific commands
endif

" Bypass true colours https://github.com/tmux/tmux/issues/1246
if exists('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif


noremap <Up>    <Nop>
noremap <Down>  <Nop>
noremap <Left>  <Nop>
noremap <Right> <Nop>
