" Buffers class
let s:Buffers = {}

function! s:Buffers.new() abort
  let l:new_obj = deepcopy(s:Buffers)

  function! new_obj.exists(num) abort
    return bufexists(a:num)
  endfunction

  function! new_obj.delete(number) abort
    execute 'bdelete!' . a:number
  endfunction

  function! new_obj.listed(number) abort
    return getbufvar(a:number, '&buflisted')
  endfunction

  function! new_obj.edit(filename) abort
    execute 'edit ' . fnameescape(a:filename)
  endfunction

  function! new_obj.editUnnamed() abort
    enew
  endfunction

  function! new_obj.addFile(filename) abort
    execute 'badd ' . fnameescape(a:filename)
  endfunction

  function! new_obj.allNumbers() abort
    return range(1, bufnr('$'))
  endfunction

  function! new_obj.list() abort
    ls
  endfunction

  function! new_obj.openAllInList() abort
    ball
  endfunction

  function! new_obj.infoItems() abort
    return getbufinfo()
  endfunction

  function! new_obj.closeAllBut(active_buffer_num) abort dict
    for buff_num in self.allNumbers()
      if self.exists(buff_num) && self.listed(buff_num) && buff_num != a:active_buffer_num
        call self.delete(buff_num)
      endif
    endfor
  endfunction

  return l:new_obj
endfunction

function! CreateBuffers() abort
  return s:Buffers.new()
endfunction

let buffs = CreateBuffers()
