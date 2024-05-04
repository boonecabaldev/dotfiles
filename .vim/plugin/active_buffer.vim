" ActiveBuffer class
let s:ActiveBuffer = {}

function! s:ActiveBuffer.new() abort
  let l:new_obj = deepcopy(s:ActiveBuffer)

  function! new_obj.toNext() abort
    execute 'bnext'
  endfunction

  function! new_obj.toPrev() abort
    execute 'bprevious'
  endfunction

  function! new_obj.toLast() abort
    execute 'blast'
  endfunction

  function! new_obj.toFirst() abort
    execute 'bfirst'
  endfunction

  function! new_obj.unload() abort dict
    execute 'bunload' self.number()
  endfunction

  function! new_obj.delete() abort dict
    execute 'bdelete' self.number()
  endfunction

  function! new_obj.number() abort
    return bufnr('%')
  endfunction

  function! new_obj.name() abort
    return bufname('%')
  endfunction

  function! new_obj.setName(name) abort
    execute 'file ' . a:name
  endfunction

  function! new_obj.exists() abort
    return bufexists('%')
  endfunction

  function! new_obj.windowNumber() abort dict
    return bufwinnr(self.number())
  endfunction

  function! new_obj.listed() abort dict
    return buflisted(self.number())
  endfunction

  function! new_obj.loaded() abort dict
    return bufloaded(self.number())
  endfunction

  function! new_obj.type() abort dict
    return getbufvar(self.number(), '&buftype')
  endfunction

  function! new_obj.length() abort dict
    return line('$')
  endfunction

  function! l:new_obj.setVar(varname, val) abort dict
    call setbufvar(self.number(), a:varname, a:val)
  endfunction

  function! l:new_obj.getVar(varname) abort dict
    return getbufvar(self.number(), a:varname)
  endfunction

  function! l:new_obj.infoItem() abort dict
    return getbufinfo(self.number())
  endfunction

  return l:new_obj
endfunction

function! ActiveBufferFactory() abort
  return s:ActiveBuffer.new()
endfunction
