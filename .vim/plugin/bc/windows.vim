let Windows = {}

function! Windows.new()
    let obj = {}

    function! obj.number() abort
      return winnr()
    endfunction

    function! obj.Id() abort
      return win_getid()
    endfunction

    function! obj.bufferNumber() abort dict
      return winbufnr(self.Id())
    endfunction

    function! obj.height() abort dict
      return winheight(self.number())
    endfunction

    function! obj.width() abort dict
      return winwidth(self.number())
    endfunction

    function! obj.allWindowInfoItems() abort
      return getwininfo()
    endfunction

    function! obj.lastAccessedWindowNumber() abort
      return winnr('#')
    endfunction

    function! obj.cursorLineNumber() abort
      return winline()
    endfunction

    function! obj.cursorColNumber() abort
      return wincol()
    endfunction

    function! obj.split() abort
      split
    endfunction

    function! obj.vsplit() abort
      vsplit
    endfunction

    function! obj.close() abort
      close
    endfunction

    function! obj.create() abort
      new
    endfunction

    function! obj.only() abort
      only
    endfunction

    function! obj.closeAllAndExit() abort
      qall
    endfunction

    function! obj.maxCurrentHor() abort
      wincmd _
    endfunction

    function! obj.left() abort
      wincmd h
    endfunction

    function! obj.down() abort
      wincmd j
    endfunction

    function! obj.up() abort
      wincmd k
    endfunction

    function! obj.right() abort
      wincmd l
    endfunction

    function! obj.cycleThroughOpen() abort
      wincmd w
    endfunction

    function! obj.swapCurrentForNext() abort
      wincmd r
    endfunction

    return obj
endfunction

" Usage:
let win = Windows.new()
