" General Settings
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set nocompatible            " We're running Vim, not Vi!
set noswapfile              " No swap files
set visualbell t_vb=        " No visual bell
set ai                      " auto indenting
set history=100             " keep 100 lines of history
set ruler                   " show the cursor position
set hidden                  " hide buffer without notice
set hlsearch                " highlight the last searched term
set virtualedit=all         " let us walk in limbo
set showcmd                 " show number of lines selected
set relativenumber          " show line numbers relative to current
set ignorecase              " search by default case insensitive
set smartcase               " if there is any upper case character: sensitive search
set textwidth=80            " linebreak after 80 characters (C++ default)
set formatoptions=croqt     " Formatoptions: t/c: force linebreak r/o: continue comments in new line, q: format with gqq
syntax on                   " syntax highlighting
filetype plugin indent on   " use the file type plugins
au InsertEnter * :let @/="" " Disable highlighted search on insert mode
au InsertLeave * :let @/="" " Enable it back

set cino=g0,N-s

" Vim Addon Manager

fun! EnsureVamIsOnDisk(plugin_root_dir)
  let vam_autoload_dir = a:plugin_root_dir.'/vim-addon-manager/autoload'
  if isdirectory(vam_autoload_dir)
    return 1
  else
    if 1 == confirm("Clone VAM into ".a:plugin_root_dir."?","&Y\n&N")
      call mkdir(a:plugin_root_dir, 'p')
      execute '!git clone --depth=1 git@github.com:MarcWeber/vim-addon-manager.git '.
            \       shellescape(a:plugin_root_dir, 1).'/vim-addon-manager'
      exec 'helptags '.fnameescape(a:plugin_root_dir.'/vim-addon-manager/doc')
    endif
    return isdirectory(vam_autoload_dir)
  endif
endfun

let g:vim_addon_manager = {'scms': {'git': {}}}
     fun! MyGitCheckout(repository, targetDir)
         let a:repository.url = substitute(a:repository.url, '^git://github.com/', 'git@github.com:', '')
         let a:repository.url = substitute(a:repository.url, '$', '.git', '')
         return vam#utils#RunShell('git clone --depth=1 $.url $p', a:repository, a:targetDir)
     endfun
let g:vim_addon_manager.scms.git.clone=['MyGitCheckout']

fun! SetupVAM()
  let plugin_root_dir = expand('$HOME/.vim/vim-addons')
  if !EnsureVamIsOnDisk(plugin_root_dir)
    echohl ErrorMsg | echomsg "No VAM found!" | echohl NONE
    return
  endif
  let &rtp.=(empty(&rtp)?'':',').plugin_root_dir.'/vim-addon-manager'
  call vam#ActivateAddons(['The_NERD_tree'])
  call vam#ActivateAddons(['The_NERD_Commenter'])
  "call vam#ActivateAddons(['github:jistr/vim-nerdtree-tabs'])
  "call vam#ActivateAddons(['github:fholgado/minibufexpl.vim'])
  call vam#ActivateAddons(['Solarized'])
  call vam#ActivateAddons(['C11_Syntax_Support'])
  call vam#ActivateAddons(['clang_complete'])
  call vam#ActivateAddons(['UltiSnips'])
  call vam#ActivateAddons(['bufkill'])
  " call vam#ActivateAddons(['xptemplate'])
  call vam#ActivateAddons(['SuperTab%1643'])
  call vam#ActivateAddons(['a'])
  call vam#ActivateAddons(['SingleCompile'])
  call vam#ActivateAddons(['hg:http://hg.dfrank.ru/vim/bundle/dfrank_util'])
  call vam#ActivateAddons(['hg:http://hg.dfrank.ru/vim/bundle/vimprj'])
  call vam#ActivateAddons(['github:oblitum/rainbow'])
  call vam#ActivateAddons(['github:techlivezheng/vim-plugin-minibufexpl'])
  call vam#ActivateAddons(['bufexplorer.zip'])
  " (<c-x><c-p> complete plugin names):
endfun
call SetupVAM()


" File Types

" vimprj
au BufNewFile,BufRead *.vimprj set ft=vim

" C++
au FileType cpp,objcpp set syntax=cpp11
au BufNewFile,BufRead *
      \ if expand('%:e') =~ '^\(h\|hh\|hxx\|hpp\|ii\|ixx\|ipp\|inl\|txx\|tpp\|tpl\|cc\|cxx\|cpp\)$' |
      \   if &ft != 'cpp'                                                                           |
      \     set ft=cpp                                                                              |
      \   endif                                                                                     |
      \ endif                                                                                       |



" Change to current directory automatically
autocmd BufEnter * silent! lcd %:p:h
" nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>


" Nerd tree: don't autostart, and ignore some files..

let NERDTreeIgnore=['\env','\.vim$', '\~$', '\.pyc$', '\.swp$', '\.o$', 
      \'\.egg-info$', '\.DS_Store$', '^dist$', '^build$']

let g:nerdtree_tabs_open_on_console_startup=0

" If file already open, don't create a new buffer, but use existing.
" This helps to keep the cursor in position
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |
      \ exe "normal g'\"" | endif


" Complete options (disable preview scratch window)
set completeopt=menu,menuone,longest
" Limit popup menu height
set pumheight=15

let g:clang_user_options = '-std=c++11 -stdlib=libstdc++'
let g:clang_auto_user_options = ''
let g:clang_library_path="/usr/lib/"
 
" SuperTab option for context aware completion
let g:SuperTabDefaultCompletionType = "context"

" Disable auto popup, use <Tab> to autocomplete
let g:clang_complete_auto = 0
" Show clang errors in the quickfix window
let g:clang_complete_copen = 1

" Solarized settings
"set terminal colors to 16. needed to make solarized scheme work
se t_Co=16
syntax enable
set background=dark
colorscheme solarized
" if has('gui_running')
"    set background=light
" else
"    set background=dark
" endif

let g:rainbow_operators = 2 
au FileType c,cpp,objc,objcpp call rainbow#activate()

" Automatic templates for C++ files
autocmd bufnewfile *
      \ if &ft == 'cpp'                                                                       |
      \   so ~/.vim/cpp.header                                                                |
      \   exe "1," . 16 . "g/@file:.*/s//@file: " .expand("%")                                |
      \   exe "1," . 16 . "g/Created:.*/s//Created: " .strftime("%d-%m-%Y")                   |
      \   exe "1," . 18 . "g/BEGIN.*/s//"                                                     |

autocmd bufwritepre,filewritepre *
      \ if &ft == 'cpp'                                                                       |
      \   let g:winview = winsaveview()                                                       |
      \   exe "1," . 16 . "g/Last Update:.*/s/Last Update:.*/Last Update: " .strftime("%c")   |

autocmd bufwritepost,filewritepost *
      \ if &ft == 'cpp'                                                                       |
      \   call winrestview(g:winview)                                                         |

"      \   mkview |
"      \   silent loadview |

" Nerd Comment settings

"Documented, but doesn't work. Hack fix below.
"let g:NERD_cpp_alt_style=0
"let g:NERDCustomDelimiters = {
"\ 'cpp': { 'leftAlt': '//', 'left': '/*', 'right': '*/' }, 
"\ }

" REMAPPINGS

" Use , for the leader key as opposed to \
let mapleader = ","

" Ctrl-C and Ctrl-V systemwide
map  <C-V> "+gP
cmap <C-V> <C-R>+
vnoremap <C-C> "+y

" Use NERD Tree on \n and use Ctrl-l and Ctrl-h to navigate between tabs
map \n :NERDTreeToggle<cr>
" proper settings one day
"map  <C-l> :bn<CR>   
"map  <C-h> :bp<CR>   

map <C-left> :bp<CR>
map <C-right> :bn<CR>
nnoremap <Leader>b :bp<CR>
nnoremap <Leader>f :bn<CR>
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>
"
" Ctrl + Tab
"let g:miniBufExplMapCTabSwitchBufs = 1

" Use <leader><space> to clean highlights
nnoremap <leader><space> :noh<cr>

" Disabling arrow keys. Let's do it
"nnoremap <up> <nop>
"nnoremap <down> <nop>
"nnoremap <left> <nop>
"nnoremap <right> <nop>
"inoremap <up> <nop>
"inoremap <down> <nop>
"inoremap <left> <nop>
"inoremap <right> <nop>
"nnoremap j gj
"nnoremap k gk

" Make ; work same as :. No more shift :)
nnoremap ; :

" Use <tab> and <s-tab> for navigation in snippets
let g:UltiSnipsListSnippets="<c-tab>" 
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" SuperTab completion fall-back 
" let g:SuperTabDefaultCompletionType='<c-x><c-o><c-p>'
" let g:SuperTabDefaultCompletionType='<c-tab>'
" let g:SuperTabNoCompleteAfter=''

" Single Compile options
noremap  <silent> <F9> :SCCompile<cr>
noremap  <silent> <F10> :SCCompileRun<cr>
noremap! <silent> <F9> <c-o>:SCCompile<cr>
noremap! <silent> <F10> <c-o>:SCCompileRun<cr>

" Save and make current file.o on F7
function! Make()
  let curr_dir = expand('%:h')
  if curr_dir == ''
    let curr_dir = '.'
  endif
  echo curr_dir
  execute 'lcd ' . curr_dir
  execute 'make %:r.o'
  execute 'lcd -'
endfunction
nnoremap <F7> :update<CR>:call Make()<CR>

" Compile makefile on F6
noremap <F6> :make<cr>
noremap! <F6> <c-o>:make<cr>

" Try to run current file (without extension) on F8
noremap <F8> :!./%:r<cr>
noremap! <F8> <c-o>:!./%:r<cr>

" vimprj configuration

" Initialize vimprj plugin
call vimprj#init()

" vimprj hooks
let g:my_includes = ''
let g:my_libraries = ''

" Called BEFORE sourcing .vimprj and when not sourcing
function! g:vimprj#dHooks['SetDefaultOptions']['main_options'](dParams)
  let g:vimprj_dir = substitute(a:dParams['sVimprjDirName'], '[/\\]\.vimprj$', '', '')

  if &ft == 'c' || &ft == 'cpp'  
    let g:sgcc_user_options = ''
    if &ft == 'cpp' 
      let g:sgcc_user_options = '-std=c++0x -stdlib=libstdc++ '
    endif
    let g:single_compile_options = '-O3 ' . g:sgcc_user_options
  endif
endfunction

" Called AFTER sourcing .vimprj and when not sourcing
function! g:vimprj#dHooks['OnAfterSourcingVimprj']['main_options'](dParams)
  unlet g:vimprj_dir
  if &ft == 'c' || &ft == 'cpp'  
    let g:clang_user_options = '-std=c++0x -stdlib=libstdc++ ' . g:my_includes
    let g:single_compile_options = "-O3 -std=c++0x " . g:my_includes . ' ' . g:my_libraries
    call s:LoadSingleCompileOptions()
  endif                          
endfunction

" SingleCompile for C++

let g:common_run_command='./$(FILE_TITLE)$'

function! s:LoadSingleCompileOptions()
  call SingleCompile#SetCompilerTemplate('c', 
        \'sgcc', 
        \'GNU project C and C++ compiler', 
        \'gcc', 
        \'-o $(FILE_TITLE)$ ' . g:single_compile_options, 
        \g:common_run_command)
  call SingleCompile#ChooseCompiler('c', 'sgcc')

  call SingleCompile#SetCompilerTemplate('cpp', 
        \'sgcc', 
        \'GNU project C and C++ compiler', 
        \'g++', 
        \'-o $(FILE_TITLE)$ ' . g:single_compile_options, 
        \g:common_run_command)
  call SingleCompile#ChooseCompiler('cpp', 'sgcc')
endfunction

"here is a more exotic version of my original Kwbd script
"delete the buffer; keep windows; create a scratch buffer if no buffers left
function s:Kwbd(kwbdStage)
  if(a:kwbdStage == 1)
    if(!buflisted(winbufnr(0)))
      bd!
      return
    endif
    let s:kwbdBufNum = bufnr("%")
    let s:kwbdWinNum = winnr()
    windo call s:Kwbd(2)
    execute s:kwbdWinNum . 'wincmd w'
    let s:buflistedLeft = 0
    let s:bufFinalJump = 0
    let l:nBufs = bufnr("$")
    let l:i = 1
    while(l:i <= l:nBufs)
      if(l:i != s:kwbdBufNum)
        if(buflisted(l:i))
          let s:buflistedLeft = s:buflistedLeft + 1
        else
          if(bufexists(l:i) && !strlen(bufname(l:i)) && !s:bufFinalJump)
            let s:bufFinalJump = l:i
          endif
        endif
      endif
      let l:i = l:i + 1
    endwhile
    if(!s:buflistedLeft)
      if(s:bufFinalJump)
        windo if(buflisted(winbufnr(0))) | execute "b! " . s:bufFinalJump | endif
      else
        enew
        let l:newBuf = bufnr("%")
        windo if(buflisted(winbufnr(0))) | execute "b! " . l:newBuf | endif
      endif
      execute s:kwbdWinNum . 'wincmd w'
    endif
    if(buflisted(s:kwbdBufNum) || s:kwbdBufNum == bufnr("%"))
      execute "bd! " . s:kwbdBufNum
    endif
    if(!s:buflistedLeft)
      set buflisted
      set bufhidden=delete
      set buftype=
      setlocal noswapfile
    endif
  else
    if(bufnr("%") == s:kwbdBufNum)
      let prevbufvar = bufnr("#")
      if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != s:kwbdBufNum)
        b #
      else
        bn
      endif
    endif
  endif
endfunction

command! Kwbd call s:Kwbd(1)
nnoremap <silent> <Plug>Kwbd :<C-u>Kwbd<CR>

" Create a mapping (e.g. in your .vimrc) like this:
nmap <leader>q <Plug>Kwbd
