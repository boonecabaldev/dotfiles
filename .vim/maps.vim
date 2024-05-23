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
