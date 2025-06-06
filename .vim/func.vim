" You must specify 'normal' for all normal-mode commands to work.
function! ExeCmdLs(cmd)
  if a:cmd =~ '^normal'
    exe a:cmd
    ls
  elseif empty(a:cmd)
    ls
  else
    exe a:cmd .. ' | ls'
  endif
endfunction

nnoremap <space>c :call ExeCmdLs('')<left><left>
