function! BufferInfoItemToString(item)
  let l:buffs = CreateBuffers()
  let l:is_active = l:buffs.getBufferVar(a:item.bufnr, '&bufhidden') == '' ? 'a' : 'h'
  let l:name = fnamemodify(a:item.name, ':t')
  return printf("%s\t%s\t%s\t%s", a:item.bufnr, l:is_active, l:name, a:item.lnum)
endfunction
