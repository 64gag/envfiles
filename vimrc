if hostname() == 'paguiar-lap'
  execute pathogen#infect()
endif

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

" Write changes before running make
set autowrite

" Less actions trigger a redraw of the screen
set lazyredraw

" Disable unwelcomed beeps
set noerrorbells visualbell t_vb=

" Start next line with current indentation
set autoindent

" Filetype based syntax enabled
filetype plugin on
syntax on

set tabstop=2
set shiftwidth=2
set expandtab

" Tab configuration for specific filetypes (TODO: configure to good fits next
" time I do C dev)
autocmd Filetype c setlocal ts=2 sw=2 expandtab

" Make backspace work like most other apps
set backspace=2

" Remove trailing whitespaces automatically
autocmd BufRead * if ! &bin | silent! %s/\s\+$//ge | endif

" Highlight 81st column of a line
"highlight ColorColumn ctermbg=magenta
"autocmd BufNewFile,BufRead * call matchadd('ColorColumn', '\%81v', 100)

" Display current row, col and line numbers
set relativenumber ruler numberwidth=5

" Search settings
set ignorecase smartcase incsearch hlsearch

" Cancel matches highlights and redraw screen with C-C
nnoremap <C-C> :nohlsearch<CR><C-L>

" Searches will center on the line it's found in.
map N Nzz
map n nzz

" Search with less keystrokes
noremap ,, :%s:::g<Left><Left><Left>
noremap ,' :%s:::cg<Left><Left><Left><Left>

" Make tabs, trailing whitespace, and non-breaking spaces visible
exec "set listchars=tab:\uBB\uB7,trail:\uB7,nbsp:~"
set list

" Disable arrow keys
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Map , to :
noremap  , :
noremap  : ,

" Exit insert mode with jk!
inoremap jk <Esc>

" Create blank newlines and stay in normal mode
nnoremap <silent> zj o<Esc>
nnoremap <silent> zk O<Esc>

" Untab using shift + tab
inoremap <S-Tab> <C-D>

" Split related settings
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright

set tabline=%!MyTabLine()  " custom tab pages line
function MyTabLine()
        let s = '' " complete tabline goes here
        " loop through each tab page
        for t in range(tabpagenr('$'))
                " set highlight
                if t + 1 == tabpagenr()
                        let s .= '%#TabLineSel#'
                else
                        let s .= '%#TabLine#'
                endif
                " set the tab page number (for mouse clicks)
                let s .= '%' . (t + 1) . 'T'
                let s .= ' '
                " set page number string
                let s .= t + 1 . ' '
                " get buffer names and statuses
                let n = ''      "temp string for buffer names while we loop and check buftype
                let m = 0       " &modified counter
                let bc = len(tabpagebuflist(t + 1))     "counter to avoid last ' '
                " loop through each buffer in a tab
                for b in tabpagebuflist(t + 1)
                        " buffer types: quickfix gets a [Q], help gets [H]{base fname}
                        " others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
                        if getbufvar( b, "&buftype" ) == 'help'
                                let n .= '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//' )
                        elseif getbufvar( b, "&buftype" ) == 'quickfix'
                                let n .= '[Q]'
                        else
                                let n .= pathshorten(bufname(b))
                        endif
                        " check and ++ tab's &modified count
                        if getbufvar( b, "&modified" )
                                let m += 1
                        endif
                        " no final ' ' added...formatting looks better done later
                        if bc > 1
                                let n .= ' '
                        endif
                        let bc -= 1
                endfor
                " add modified label [n+] where n pages in tab are modified
                if m > 0
                        let s .= '[' . m . '+]'
                endif
                " select the highlighting for the buffer names
                " my default highlighting only underlines the active tab
                " buffer names.
                if t + 1 == tabpagenr()
                        let s .= '%#TabLineSel#'
                else
                        let s .= '%#TabLine#'
                endif
                " add buffer names
                if n == ''
                        let s.= '[New]'
                else
                        let s .= n
                endif
                " switch to no underlining and add final space to buffer list
                let s .= ' '
        endfor
        " after the last tab fill with TabLineFill and reset tab page nr
        let s .= '%#TabLineFill#%T'
        " right-align the label to close the current tab page
        if tabpagenr('$') > 1
                let s .= '%=%#TabLineFill#%999Xclose'
        endif
        return s
endfunction
