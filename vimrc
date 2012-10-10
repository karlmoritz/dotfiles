set nocompatible	" ? be IMproved whatever this means
filetype off

set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" let Vundle manage Vundle (required)
Bundle 'gmarik/vundle'

" Other plugins
Bundle 'jistr/vim-nerdtree-tabs'
Bundle 'altercation/vim-colors-solarized'

filetype on

" Ctrl-C and Ctrl-V systemwide
map <C-V> "+gP
cmap <C-V> <C-R>+
vnoremap <C-C> "+y

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" If file already open, don't create a new buffer, but use existing.
" This helps to keep the cursor in position
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |
                     \ exe "normal g'\"" | endif

" Autoload NERDTree on start
" Autoload NERDTree in every Tab and move cursor to non-NERD split
" autocmd VimEnter * NERDTree
" autocmd BufEnter * NERDTreeMirror
" autocmd BufEnter * wincmd w

let NERDTreeIgnore=['\.o$', '\~$', '\.pyc']

map <Leader>n <plug>NERDTreeTabsToggle<CR>

" This should force files in the explorer to open in the previous window
let g:netrw_browse_split=4

" Set terminal colors to 16. needed to make solarized scheme work
se t_Co=16


syntax enable
set background=dark
colorscheme solarized
" if has('gui_running')
"    set background=light
"else
"    set background=dark
" endif
