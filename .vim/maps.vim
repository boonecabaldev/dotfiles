" Misc.
"
nnoremap Bs :'a,'bs/

" Creating space
"
nnoremap <leader>O mpO<esc>`p
nnoremap <leader>o mpo<esc>`p
nnoremap <leader>2o mpo<esc>O<esc>`p
nnoremap <leader>2O mpO<esc>o<esc>`p

" Moving around
"
inoremap -- <esc>A
inoremap _- <esc>2li
inoremap -_ <esc>i


" Buffers and windows
"
nnoremap <leader>wu :wincmd p<CR>
nnoremap <leader>wd :wincmd j<CR>

nnoremap Bd :bd!<cr>

" Saving Files
"
nnoremap <F4> :w<cr>:so %<cr>
inoremap <F4> <esc>:w<cr>:so %<cr>i

" .vimrc
"
nnoremap ;vv :e $HOME/.vimrc<cr>
inoremap ;vv <esc>:e $HOME/.vimrc.vim<cr>
nnoremap ;vm :e $HOME/.vim/maps.vim<cr>
inoremap ;vm <esc>:e $HOME/.vim/maps.vim<cr>
nnoremap ;vs :e $HOME/.vim/set.vim<cr>
inoremap ;vs <esc>:e $HOME/.vim/set.vim<cr>
nnoremap ;vf :e $HOME/.vim/func.vim<cr>
inoremap ;vf <esc>:e $HOME/.vim/func.vim<cr>
