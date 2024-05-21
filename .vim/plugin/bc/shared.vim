function! ExeCmdLs(cmd)
    exe a:cmd .. '!'
    ls!
endfunction

nnoremap <space>c :call ExeCmdLs('')<left><left>
