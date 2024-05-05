for buffer in filter(buffs.openBufferNumbers(), 'v:val != ab.number()')
  call buffs.deleteBuffer(buffer)
endfor

"call win.create()
"call buffs.editUnnamed()
"call win.up()

function! Hi(b)
  echo a:b.numbers()
endfunction

call Hi(buffs)
