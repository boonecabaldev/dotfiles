" Buffers class
let s:Buffers = {}

function! s:Buffers.new() abort
  let l:new_obj = deepcopy(s:Buffers)

  function! l:new_obj.edit(filename) abort
    execute 'edit ' . fnameescape(a:filename)
  endfunction

  function! l:new_obj.addFile(filename) abort
    execute 'badd ' . fnameescape(a:filename)
  endfunction

  function! l:new_obj.list() abort
    execute 'ls'
  endfunction

  function! l:new_obj.openAllInList() abort
    execute 'ball'
  endfunction

  function! l:new_obj.infoItems() abort
    return getbufinfo()
  endfunction

  return l:new_obj
endfunction

function! CreateBuffers() abort
  return s:Buffers.new()
endfunction
