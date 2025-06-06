" Miscellaneous
"
nnoremap <leader>O mpO<esc>`p
nnoremap <leader>o mpo<esc>`p

" Moving around
"
inoremap <leader><leader> <esc>A

" Buffers and windows
"
nnoremap <leader>wu :wincmd p<CR>
nnoremap <leader>wd :wincmd j<CR>

nnoremap Bd :bd!<cr>

" Saving Files
"
nnoremap <F4> :w<cr>:so %<cr>
inoremap <F4> <esc>:w<cr>:so %<cr>i

nnoremap <leader>s :w<cr>a
inoremap <leader>s <esc>:w<cr>a

" .vimrc
"
nnoremap <leader>vv :e $HOME/.vimrc<cr>
inoremap <leader>vv <esc>:e $HOME/.vimrc.vim<cr>
nnoremap <leader>vm :e $HOME/.vim/maps.vim<cr>
inoremap <leader>vm <esc>:e $HOME/.vim/maps.vim<cr>
nnoremap <leader>vs :e $HOME/.vim/set.vim<cr>
inoremap <leader>vs <esc>:e $HOME/.vim/set.vim<cr>
nnoremap <leader>vf :e $HOME/.vim/func.vim<cr>
inoremap <leader>vf <esc>:e $HOME/.vim/func.vim<cr>
