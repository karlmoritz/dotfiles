" General Settings
set expandtab
" set tabstop=4
" set shiftwidth=4
" set softtabstop=4
set nocompatible            " We're running Vim, not Vi!
set noswapfile              " No swap files
set visualbell t_vb=        " No visual bell
set ai                      " auto indenting
set history=100             " keep 100 lines of history
set ruler                   " show the cursor position
set hidden                  " hide buffer without notice
set number 		    " always show the line number
set hlsearch                " highlight the last searched term
set virtualedit=all         " let us walk in limbo
set showcmd                 " show number of lines selected
syntax on                   " syntax highlighting
filetype plugin indent on   " use the file type plugins
au InsertEnter * :let @/="" " Disable highlighted search on insert mode
au InsertLeave * :let @/="" " Enable it back

" Vim Addon Manager

fun! EnsureVamIsOnDisk(plugin_root_dir)
  let vam_autoload_dir = a:plugin_root_dir.'/vim-addon-manager/autoload'
  if isdirectory(vam_autoload_dir)
    return 1
  else
    if 1 == confirm("Clone VAM into ".a:plugin_root_dir."?","&Y\n&N")
      call mkdir(a:plugin_root_dir, 'p')
      execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '.
		  \       shellescape(a:plugin_root_dir, 1).'/vim-addon-manager'
      exec 'helptags '.fnameescape(a:plugin_root_dir.'/vim-addon-manager/doc')
    endif
    return isdirectory(vam_autoload_dir)
  endif
endfun

fun! SetupVAM()
  let plugin_root_dir = expand('$HOME/.vim/vim-addons')
  if !EnsureVamIsOnDisk(plugin_root_dir)
    echohl ErrorMsg | echomsg "No VAM found!" | echohl NONE
    return
  endif
  let &rtp.=(empty(&rtp)?'':',').plugin_root_dir.'/vim-addon-manager'
    call vam#ActivateAddons(['The_NERD_tree'])
    call vam#ActivateAddons(['The_NERD_Commenter'])
    call vam#ActivateAddons(['github:jistr/vim-nerdtree-tabs'])
    call vam#ActivateAddons(['Solarized'])
    call vam#ActivateAddons(['C11_Syntax_Support'])
    " call vam#ActivateAddons(['lh-cpp'])
    " call vam#ActivateAddons(['UltiSnips'])
    call vam#ActivateAddons(['xptemplate'])
    call vam#ActivateAddons(['SuperTab%1643'])
    call vam#ActivateAddons(['a'])
    " call vam#ActivateAddons(['c%213'])
    " call vam#ActivateAddons(['Auto_Pairs'])
    " call vam#ActivateAddons(['github:Raimondi/delimitMate'])
    call vam#ActivateAddons(['SingleCompile'])
    call vam#ActivateAddons(['hg:http://hg.dfrank.ru/vim/bundle/dfrank_util'])
    call vam#ActivateAddons(['hg:http://hg.dfrank.ru/vim/bundle/vimprj'])
    call vam#ActivateAddons(['github:oblitum/rainbow'])
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

let g:rainbow_operators = 2 
au FileType c,cpp,objc,objcpp call rainbow#activate()


" Nerd tree: don't autostart, and ignore some files..

let NERDTreeIgnore=['\env','\.vim$', '\~$', '\.pyc$', '\.swp$', '\.egg-info$', '\.DS_Store$', '^dist$', '^build$']
let g:nerdtree_tabs_open_on_console_startup=0

" If file already open, don't create a new buffer, but use existing.
" This helps to keep the cursor in position
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |
                     \ exe "normal g'\"" | endif

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

" Automatic templates for C++ files
autocmd bufnewfile *.cpp so ~/.vim/cpp.header
autocmd bufnewfile *.cpp exe "1," . 16 . "g/@file:.*/s//@file: " .expand("%")
autocmd bufnewfile *.cpp exe "1," . 16 . "g/Created:.*/s//Created: " .strftime("%d-%m-%Y")
autocmd bufnewfile *.cpp exe "1," . 18 . "g/BEGIN.*/s//"
autocmd Bufwritepre,filewritepre *.cpp execute "normal ma"
autocmd Bufwritepre,filewritepre *.cpp exe "1," . 16 . "g/Last Update:.*/s/Last Update:.*/Last Update: " .strftime("%c")
autocmd bufwritepost,filewritepost *.cpp execute "normal `a" 



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

" REMAPPINGS

" Ctrl-C and Ctrl-V systemwide
map  <C-V> "+gP
cmap <C-V> <C-R>+
vnoremap <C-C> "+y

" Use NERD Tree on \n
map <Leader>n <plug>NERDTreeTabsToggle<cr>

" Syntastic options (syntax checking)
let g:syntastic_enable_signs=1
let g:syntastuc_check_on_open=1



" Use <tab> and <s-tab> for navigation in snippets
" let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsJumpForwardTrigger="<tab>"
" let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" avoid key conflict
let g:SuperTabMappingForward = '<Plug>supertabKey'

" if nothing matched in xpt, try supertab
let g:xptemplate_fallback = '<Plug>supertabKey'

" xpt uses <Tab> as trigger key
let g:xptemplate_key = '<Tab>'

" use <tab>/<S-tab> to navigate through pum. Optional
let g:xptemplate_pum_tab_nav = 1

" xpt triggers only when you typed whole name of a snippet. Optional
" let g:xptemplate_minimal_prefix = 'full'

" SuperTab completion fall-back 
let g:SuperTabDefaultCompletionType='<c-x><c-o><c-p>'

let g:xptemplate_vars="author=Karl Moritz Hermann&email=mail@kmhermann.com" 

" Single Compile options
noremap  <silent> <F9> :SCCompile<cr>
noremap  <silent> <F10> :SCCompileRun<cr>
noremap! <silent> <F9> <c-o>:SCCompile<cr>
noremap! <silent> <F10> <c-o>:SCCompileRun<cr>


let NERD_cpp_alt_style=1


" vimprj configuration
 
" Initialize vimprj plugin
call vimprj#init()
 
" vimprj hooks
 
" Called BEFORE sourcing .vimprj and when not sourcing
function! g:vimprj#dHooks['SetDefaultOptions']['main_options'](dParams)
    let g:vimprj_dir = substitute(a:dParams['sVimprjDirName'], '[/\\]\.vimprj$', '', '')
    
    if &ft == 'c' || &ft == 'cpp'  
        let g:sgcc_user_options = ''
        if &ft == 'cpp'
            let g:sgcc_user_options = '-std=c++0x'
        endif
        let g:single_compile_options = '-O3 ' . g:sgcc_user_options
    endif
endfunction
 
" Called AFTER sourcing .vimprj and when not sourcing
function! g:vimprj#dHooks['OnAfterSourcingVimprj']['main_options'](dParams)
    unlet g:vimprj_dir
    if &ft == 'c' || &ft == 'cpp'  
      call s:LoadSingleCompileOptions()
    endif                          
endfunction



