try
  execute pathogen#infect()
catch
endtry

" Drop VI compatibility
set nocompatible

" Brightside settings for backups and swaps!
set nobackup nowritebackup noswapfile

" Do not keep buffers of closed tabs
set nohidden

" Shows commands you are typing
set showcmd

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

set tabstop=4
set shiftwidth=4
set expandtab

" Tab configuration for specific filetypes (TODO: configure to good fits next
" time I do C dev)
autocmd Filetype c setlocal ts=4 sw=4 expandtab

" Make backspace work like most other apps
set backspace=2

" Remove trailing whitespaces automatically
autocmd BufRead * if ! &bin | silent! %s/\s\+$//ge | endif

" Highlight 81st column of a line
"highlight ColorColumn ctermbg=magenta
"autocmd BufNewFile,BufRead * call matchadd('ColorColumn', '\%81v', 100)

" Highlight column and line
set cursorcolumn
set cursorline

" Display current row, col and line numbers
set relativenumber ruler numberwidth=5

" Search settings
set ignorecase smartcase incsearch hlsearch

" Cancel matches highlights and redraw screen with C-C
nnoremap <C-C> :nohlsearch<CR><C-L>

" Searches will center on the line it's found in.
map N Nzz
map n nzz

" Allows to open files by name using (example): :find user_<TAB>
set path=$PWD/**

" Replace with less keystrokes
noremap ,, :%s:::g<Left><Left><Left>
noremap ,' :%s:::cg<Left><Left><Left><Left>

" Less annoying conflict solving
noremap ,ch :diffget LOCAL \| diffupdate<Enter>
noremap ,cl :diffget REMOTE \| diffupdate<Enter>
noremap ,ck :diffget //2 \| diffupdate<Enter>
noremap ,cj :diffget //3 \| diffupdate<Enter>

" Make tabs, trailing whitespace, and non-breaking spaces visible
set list
set listchars=tab:\ \ ,trail:·,nbsp:~

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

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

set splitbelow
set splitright

" Quickly open file in same directory as current buffer
noremap ;e :e <C-R>=expand("%:p:h") . "/" <CR>
noremap ;t :tabe <C-R>=expand("%:p:h") . "/" <CR>
noremap ;s :split <C-R>=expand("%:p:h") . "/" <CR>
noremap ;v :vsplit <C-R>=expand("%:p:h") . "/" <CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Show tab number (from http://vim.wikia.com/wiki/Show_tab_number_in_your_tab_line)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Originated from CSCOPE settings for vim
" (from http://cscope.sourceforge.net/cscope_maps.vim)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("cscope")
    """"""""""""" Standard cscope/vim boilerplate
    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0

    " add any cscope database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add the database pointed to by environment variable
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif

    " show msg when any other cscope db added
    set cscopeverbose

    " Quickly rebuild the database
    noremap ;c :!cscope -Rb<CR>:cs reset<CR><CR>

    """"""""""""" My cscope/vim key mappings
    "
    " The following maps all invoke one of the following cscope search types:
    "
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls

    " Open in the same window
    noremap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>zz
    noremap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>zz
    noremap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>zz
    noremap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>zz
    noremap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>zz
    noremap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>zz
    noremap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>zz
    noremap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>zz

    " Open in a tab
    noremap <C-\><C-\>s :tab cs find s <C-R>=expand("<cword>")<CR><CR>zz
    noremap <C-\><C-\>g :tab cs find g <C-R>=expand("<cword>")<CR><CR>zz
    noremap <C-\><C-\>c :tab cs find c <C-R>=expand("<cword>")<CR><CR>zz
    noremap <C-\><C-\>t :tab cs find t <C-R>=expand("<cword>")<CR><CR>zz
    noremap <C-\><C-\>e :tab cs find e <C-R>=expand("<cword>")<CR><CR>zz
    noremap <C-\><C-\>f :tab cs find f <C-R>=expand("<cfile>")<CR><CR>zz
    noremap <C-\><C-\>i :tab cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>zz
    noremap <C-\><C-\>d :tab cs find d <C-R>=expand("<cword>")<CR><CR>zz

    " Open in vertical split
    noremap <C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>zz
    noremap <C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>zz
    noremap <C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>zz
    noremap <C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>zz
    noremap <C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>zz
    noremap <C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>zz
    noremap <C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>zz
    noremap <C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>zz

    " Open in horizontal split
    noremap <C-@><C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>zz
    noremap <C-@><C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>zz
    noremap <C-@><C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>zz
    noremap <C-@><C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>zz
    noremap <C-@><C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>zz
    noremap <C-@><C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>zz
    noremap <C-@><C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>zz
    noremap <C-@><C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>zz
endif
