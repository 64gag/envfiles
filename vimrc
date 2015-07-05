" Drop VI compatibility
set nocompatible

" Brightside settings for backups and swaps!
set nobackup nowritebackup noswapfile

" Do not keep buffers of closed tabs
set nohidden

" Shows commands you are typing
set showcmd

" Change to file's directory
set autochdir

" Less actions trigger a redraw of the screen
set lazyredraw

" Disable unwelcomed beeps
set noerrorbells visualbell t_vb=

" Start next line with current indentation
set autoindent

" Tab configuration for specific filetypes
autocmd Filetype ruby setlocal ts=2 sw=2 expandtab

" Make backspace work like most other apps
set backspace=2

" Remove trailing whitespaces automatically
autocmd BufRead * if ! &bin | silent! %s/\s\+$//ge | endif

" Highlight 81st column of a line
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 100)

" Display current row, col and line numbers
set number ruler numberwidth=5

" Search settings
set ignorecase smartcase incsearch hlsearch

" Cancel matches highlights and redraw screen with C-L
nnoremap <C-L> :nohlsearch<CR><C-L>

" Searches will center on the line it's found in.
map N Nzz
map n nzz

" Make tabs, trailing whitespace, and non-breaking spaces visible
exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
set list

" Disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Swap ; and :
nnoremap  ;  :
nnoremap  :  ;

" Swap v and CTRL-V, because block mode is more useful that visual mode
nnoremap    v   <C-V>
nnoremap <C-V>     v
vnoremap    v   <C-V>
vnoremap <C-V>     v

" Exit insert mode with jk!
inoremap jk <Esc>

" Create blank newlines and stay in normal mode
nnoremap <silent> zj o<Esc>
nnoremap <silent> zk O<Esc>
