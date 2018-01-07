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
set smartindent
set autoindent

" Filetype based syntax enabled
filetype plugin indent on
syntax on

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
" CSCOPE settings for vim (from http://cscope.sourceforge.net/cscope_maps.vim)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" This file contains some boilerplate settings for vim's cscope interface,
" plus some keyboard mappings that I've found useful.
"
" USAGE:
" -- vim 6:     Stick this file in your ~/.vim/plugin directory (or in a
"               'plugin' directory in some other directory that is in your
"               'runtimepath'.
"
" -- vim 5:     Stick this file somewhere and 'source cscope.vim' it from
"               your ~/.vimrc file (or cut and paste it into your .vimrc).
"
" NOTE:
" These key maps use multiple keystrokes (2 or 3 keys).  If you find that vim
" keeps timing you out before you can complete them, try changing your timeout
" settings, as explained below.
"
" Happy cscoping,
"
" Jason Duell       jduell@alumni.princeton.edu     2002/3/7
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" This tests to see if vim was configured with the '--enable-cscope' option
" when it was compiled.  If it wasn't, time to recompile vim...
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
    "
    " Below are three sets of the maps: one set that just jumps to your
    " search result, one that splits the existing vim window horizontally and
    " diplays your search result in the new window, and one that does the same
    " thing, but does a vertical split instead (vim 6 only).
    "
    " I've used CTRL-\ and CTRL-@ as the starting keys for these maps, as it's
    " unlikely that you need their default mappings (CTRL-\'s default use is
    " as part of CTRL-\ CTRL-N typemap, which basically just does the same
    " thing as hitting 'escape': CTRL-@ doesn't seem to have any default use).
    " If you don't like using 'CTRL-@' or CTRL-\, , you can change some or all
    " of these maps to use other keys.  One likely candidate is 'CTRL-_'
    " (which also maps to CTRL-/, which is easier to type).  By default it is
    " used to switch between Hebrew and English keyboard mode.
    "
    " All of the maps involving the <cfile> macro use '^<cfile>$': this is so
    " that searches over '#include <time.h>" return only references to
    " 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
    " files that contain 'time.h' as part of their name).

    " To do the first type of search, hit 'CTRL-\', followed by one of the
    " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
    " search will be displayed in the current window.  You can use CTRL-T to
    " go back to where you were before the search.
    "

    noremap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    noremap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    noremap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    noremap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    noremap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    noremap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    noremap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    noremap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

    " Using 'CTRL-spacebar' (intepreted as CTRL-@ by vim) then a search type
    " makes the vim window split horizontally, with search result displayed in
    " the new window.
    "
    " (Note: earlier versions of vim may not have the :scs command, but it
    " can be simulated roughly via:
    "    nmap <C-@>s <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>

    noremap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
    noremap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>
    noremap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
    noremap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>
    noremap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>
    noremap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
    noremap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    noremap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>

    " Hitting CTRL-space *twice* before the search type does a vertical
    " split instead of a horizontal one (vim 6 and up only)
    "
    " (Note: you may wish to put a 'set splitright' in your .vimrc
    " if you prefer the new window on the right instead of the left

    noremap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    noremap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    noremap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
    noremap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    noremap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
    noremap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
    noremap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    noremap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>

    """"""""""""" key map timeouts
    "
    " By default Vim will only wait 1 second for each keystroke in a mapping.
    " You may find that too short with the above typemaps.  If so, you should
    " either turn off mapping timeouts via 'notimeout'.
    "
    "set notimeout
    "
    " Or, you can keep timeouts, by uncommenting the timeoutlen line below,
    " with your own personal favorite value (in milliseconds):
    "
    "set timeoutlen=4000
    "
    " Either way, since mapping timeout settings by default also set the
    " timeouts for multicharacter 'keys codes' (like <F1>), you should also
    " set ttimeout and ttimeoutlen: otherwise, you will experience strange
    " delays as vim waits for a keystroke after you hit ESC (it will be
    " waiting to see if the ESC is actually part of a key code like <F1>).
    "
    "set ttimeout
    "
    " personally, I find a tenth of a second to work well for key code
    " timeouts. If you experience problems and have a slow terminal or network
    " connection, set it higher.  If you don't set ttimeoutlen, the value for
    " timeoutlent (default: 1000 = 1 second, which is sluggish) is used.
    "
    "set ttimeoutlen=100
endif
