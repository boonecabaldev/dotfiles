" Buffers class
let s:Buffers = {}

function! s:Buffers.new() abort
  let l:new_obj = deepcopy(s:Buffers)

  function! new_obj.toNext() abort
    bnext
  endfunction
  
  function! new_obj.toPrev() abort
    bprevious
  endfunction

  function! new_obj.toLast() abort
    blast
  endfunction

  function! new_obj.toFirst() abort
    bfirst
  endfunction

  function! new_obj.toNextModified(num) abort
    bmodified
  endfunction

  function! new_obj.getBufferWindowNumber(num) abort
    return bufwinnr(a:num)
  endfunction

  function! new_obj.getBufferName(num) abort
    return bufname(a:num)
  endfunction

  function! new_obj.getBufferNumber(name) abort
    return bufnr(a:name)
  endfunction

  function! new_obj.deleteBuffer(num) abort
    execute 'bdelete!' . a:num
  endfunction

  function! new_obj.bufferIsListed(num) abort
    return buflisted(a:num)
  endfunction

  function! new_obj.editFile(filename) abort
    execute 'edit ' . fnameescape(a:filename)
  endfunction

  function! new_obj.bufferExists(num) abort
    return bufexists(a:num)
  endfunction

  function! new_obj.editUnnamed() abort
    enew
  endfunction

  function! new_obj.addFile(filename) abort
    execute 'badd ' . fnameescape(a:filename)
  endfunction

  function! new_obj.numbers() abort
    return range(1, bufnr('$'))
  endfunction

  function! new_obj.list() abort
    ls
  endfunction

  function! new_obj.openBuffer(num) abort
    buffer a:num
  endfunction

  function! new_obj.openAllInList() abort
    ball
  endfunction

  function! new_obj.infoItems() abort
    return getbufinfo()
  endfunction

  function! new_obj.closeAllBut(active_buffer_num) abort dict
    for buff_num in self.numbers()
      if self.bufferExists(buff_num) && self.bufferIsListed(buff_num) && buff_num != a:active_buffer_num
        call self.deleteBuffer(buff_num)
      endif
    endfor
  endfunction

  return l:new_obj
endfunction

function! CreateBuffers() abort
  return s:Buffers.new()
endfunction

let buffs = CreateBuffers()