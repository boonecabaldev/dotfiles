let s:ActiveBuffer = {} 

function! s:ActiveBuffer.new() abort
  let l:new_obj = deepcopy(s:ActiveBuffer)

  function! new_obj.exists(num) abort
    return bufexists(a:num)
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

  function! new_obj.name(...) abort
    if a:0
      execute 'file ' . a:1
    else
      return bufname('%')
    endif
  endfunction

  function! new_obj.exists() abort dict
    return bufexists(self.number())
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

  function! new_obj.line(start, end) abort dict
    return getbufline(self.number(), a:start, a:end)
  endfunction

  function! new_obj.lines() abort dict
    return getbufline(self.number(), 1, "$")
  endfunction

  function! new_obj.lineBy(line_num) abort dict
    return self.lines()[a:line_num]
  endfunction

  function! l:new_obj.var(...) abort dict
    if a:0 == 2
      call setbufvar(self.number(), a:1, a:2)
    else
      return getbufvar(self.number(), a:1)
    endif
  endfunction

  function! l:new_obj.infoItem() abort dict
    return getbufinfo(self.number())
  endfunction

  return l:new_obj
endfunction

function! CreateActiveBuffer() abort
  return s:ActiveBuffer.new()
endfunction

let ab = CreateActiveBuffer()
