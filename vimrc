" Remove trailing whitespaces automatically
autocmd BufRead * if ! &bin | silent! %s/\s\+$//ge | endif

" Drop VI compatibility
set nocompatible

" Shows commands you are typing
set showcmd

" Brightside settings! 
set nobackup
set nowritebackup
set noswapfile

set showmatch
set autoindent smartindent
set autochdir

set noerrorbells
set visualbell t_vb=
set lazyredraw
set scrolloff=5

" I use the tab character
set tabstop=2
set shiftwidth=2
set shiftround
set noexpandtab

" Make backspace work like most other apps
set backspace=2

" Do not keep buffers of closed tabs
set nohidden

"====[ Display line numbers ]======
set ruler
set number
set numberwidth=5

"====[ Highlight 81st column of a line ]======
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 100)

" Search settings
set ignorecase
set smartcase "do not ignore if pattern has an uppercase
set incsearch
set hlsearch

"====[ Make tabs, trailing whitespace, and non-breaking spaces visible ]======
exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
set list

"=== Disable arrow keys! ===
	noremap <Up> <NOP>
	noremap <Down> <NOP>
	noremap <Left> <NOP>
	noremap <Right> <NOP>

"====[ Swap : and ; to make colon commands easier to type ]======
	nnoremap  ;  :
	nnoremap  :  ;


"====[ Swap v and CTRL-V, because Block mode is more useful that Visual mode "]======
    nnoremap    v   <C-V>
    nnoremap <C-V>     v
    vnoremap    v   <C-V>
    vnoremap <C-V>     v

inoremap jk <Esc>

" Create Blank Newlines and stay in Normal mode
nnoremap <silent> zj o<Esc>
nnoremap <silent> zk O<Esc>

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
map N Nzz
map n nzz
