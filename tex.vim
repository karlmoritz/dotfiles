" this is mostly a matter of taste. but LaTeX looks good with just a bit
" of indentation.
set sw=2
set ts=2

" TIP: if you write your \label's as \label{fig:something}, then if you
" type in \ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!
set iskeyword+=:

imap <buffer> [[     \begin{
imap <buffer> ]]     <Plug>LatexCloseCurEnv
nmap <buffer> <F5>   <Plug>LatexChangeEnv
vmap <buffer> <F7>   <Plug>LatexWrapSelection
vmap <buffer> <S-F7> <Plug>LatexEnvWrapSelection
imap <buffer> ((     \eqref{

map  <silent> <buffer> <C-J> :call LatexBox_JumpToNextBraces(0)<CR>
map  <silent> <buffer> <C-K> :call LatexBox_JumpToNextBraces(1)<CR>
imap <silent> <buffer> <C-J> <C-R>=LatexBox_JumpToNextBraces(0)<CR>
imap <silent> <buffer> <C-K> <C-R>=LatexBox_JumpToNextBraces(1)<CR>
