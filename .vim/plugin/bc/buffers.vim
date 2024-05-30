" Buffers class
let g:Buffers = {}

function! Buffers.new() abort
  let l:new_obj = deepcopy(g:Buffers)

  function! new_obj.getBufferWindowNumber(num) abort
    return bufwinnr(a:num)
  endfunction

  function! new_obj.getBufferName(num) abort
    return bufname(a:num)
  endfunction

  function! new_obj.unloadBuffer(num) abort
    return bunload(a:num)
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

  function! new_obj.getBufferVar(number, mod) abort
    return getbufvar(a:number, a:mod)
  endfunction

  function! new_obj.numbers() abort
    return copy(range(1, bufnr('$')))
  endfunction

  function! new_obj.echoBufferList() abort
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

  function! PrintBufferInfo()
    let l:str = ''
    for buf in getbufinfo()
      if buf.loaded && buf.listed
        let l:str = l:str . 'Buffer number: ' . buf.bufnr
        let l:str = l:str . 'Buffer name: ' . buf.name
        let l:str = l:str . 'Last used: ' . strftime('%Y-%m-%d %H:%M:%S', buf.lastused)
        let l:str = l:str . 'Line count: ' . buf.linecount
        let l:str = l:str . 'Current line: ' . buf.lnum
        let l:str = l:str . 'Changed: ' . (buf.changed ? 'yes' : 'no')
        let l:str = l:str . '---'
      endif
    endfor
    return l:str
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
  return g:Buffers.new()
endfunction

let buffs = CreateBuffers()
