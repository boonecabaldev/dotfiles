# Advanced Vim - Mastering Buffers and Windows

### Buffers and Windows

In Vim, a buffer is essentially an in-memory text of a file. When you open a file in Vim, it reads the file into a buffer and all changes you make are made to the buffer. When you save the file, the buffer is written back to the disk. Even if you're not editing a file, whatever you see in the Vim window is a buffer. Buffers are useful because they allow you to work with multiple files at the same time.

A window in Vim is a viewport onto a buffer. You can have multiple windows viewing the same buffer, or different buffers. Windows can be split vertically or horizontally and can be resized, moved, and closed. They provide a way to view and edit multiple buffers at the same time.

Buffers and windows work together in Vim to provide a powerful and flexible environment for text editing. You can have multiple buffers open at the same time, each containing a different file, and you can view and edit these buffers in one or more windows. This allows you to easily switch between files and view multiple files at once, making tasks like code navigation and multi-file editing much easier.

The buffer and window commands and VimL API functions mentioned in your notes are likely functions that allow you to manipulate buffers and windows programmatically. For example, the bufadd({name}) function adds a file to the buffer list, and the bufexists({expr}) function checks if a buffer exists. There would be similar functions for working with windows.

## Buffers

- here are the buffer commands and viml api functions

### Functions

- `bufadd({name})`: Add a file to the buffer list.
- `bufexists({expr})`: Check if a buffer exists.
- `buflisted({expr})`: Check if a buffer is listed.
- `bufload({expr})`: Load a buffer into memory.
- `bufloaded({expr})`: Check if a buffer is loaded.
- `bufname({expr})`: Get the name of a buffer.
- `bufnr({expr} [, {create}])`: Get the number of a buffer.
- `bufwinid({expr})`: Get the window ID for a buffer.
- `bufwinnr({expr})`: Get the window number for a buffer.
- `getbufinfo([{expr}])`: Get information about buffers.
- `getbufline({expr}, {lnum} [, {end}])`: Get lines from a buffer.
- `getbufvar({expr}, {varname} [, {def}])`: Get a buffer-local variable.
- `setbufline({expr}, {lnum}, {text})`: Set a line in a buffer.
- `setbufvar({expr}, {varname}, {val})`: Set a buffer-local variable.

### Commands

- `:badd {file}`: Add a file to the buffer list.
- `:bdelete {buf}`: Delete a buffer.
- `:bdo {cmd}`: Execute a command in each buffer.
- `:buffer {buf}`: Edit a buffer.
- `:buffers`: List all buffers.
- `:bnext`: Go to the next buffer.
- `:bprevious`: Go to the previous buffer.
- `:bfirst`: Go to the first buffer.
- `:blast`: Go to the last buffer.
- `:bmodified`: Go to the next modified buffer.

## Windows

- here are the window commands and viml api functions

### Functions

- `winbufnr({nr})`: Get the buffer number for a window.
- `wincol()`: Get the cursor column in the window.
- `winheight({nr})`: Get the height of a window.
- `win_id2tabwin({expr})`: Convert a window ID to a tab and window number.
- `win_id2win({expr})`: Convert a window ID to a window number.
- `winline()`: Get the cursor line number in the window.
- `winnr([{arg}])`: Get the number of the current window.
- `winrestcmd()`: Get the command to restore all windows.
- `winrestview({dict})`: Restore the view of a window.
- `winsaveview()`: Save the view of the current window.
- `winwidth({nr})`: Get the width of a window.
- `win_getid([{nr} [, {tabnr}]])`: Get the window ID.
- `win_gotoid({expr})`: Go to a window by its ID.
- `win_gettype([{nr}])`: Get the type of a window.
- `win_getwidth([{nr}])`: Get the width of a window.
- `win_getheight([{nr}])`: Get the height of a window.
- `win_setwidth({width})`: Set the width of a window.
- `win_setheight({height})`: Set the height of a window.

### Commands

- `:split`: Split the current window.
- `:vsplit`: Split the current window vertically.
- `:close`: Close the current window.
- `:only`: Close all windows except the current one.

### `getbufinfo([bufnr])`

This function returns a list of dictionaries containing information about the specified buffer(s). If no argument is given, information about all buffers is returned.

Each dictionary in the returned list represents a buffer and contains the following keys:

- `bufnr` - The buffer number

- `changed` - 1 if the buffer is modified, 0 if not

- `listed` - 1 if the buffer is listed, 0 if not

- `lnum` - The last accessed line number

- `name` - The full path of the buffer

- `signs` - A list of signs placed in the buffer

- `windows` - A list of window numbers this buffer is open in

So you can use `getbufinfo()` to retrieve detailed information about buffers, such as their modification status, listing status, path, line numbers, signs, and associated windows.

Here's an example usage:

```vim
" Get info for all buffers
let buf_info = getbufinfo()

" Get info for a specific buffer
let buf_info = getbufinfo(123)
```

`setbufvar()` and `getbufvar()` are Vim script functions that allow you to set and get buffer-local options and variables.

### `setbufvar(bufnr, varname, val)`

- `bufnr` is the buffer number, or `0` for current buffer
- `varname` is the name of the variable
- `val` is the new value to assign to the variable

This function sets a buffer-local variable `varname` to the given `val` for the specified buffer `bufnr`. Buffer-local variables are scoped to a particular buffer and can be used to store data or options specific to that buffer.

### `getbufvar(bufnr, varname)`

- `bufnr` is the buffer number, or `0` for current buffer
- `varname` is the name of the variable

This function retrieves the value of the buffer-local variable `varname` for the specified buffer `bufnr`.

Some example usages:

```vim
" Set a buffer-local variable 'myvar' to 1 for the current buffer
call setbufvar('%', 'myvar', 1)

" Get the value of 'myvar' for buffer 123
let val = getbufvar(123, 'myvar')

" Set the 'makeprg' option for buffer 456
call setbufvar(456, '&makeprg', 'make -j4')
```

Buffer-local variables are useful for storing data or settings that are specific to a particular buffer, such as compiler options, folding settings, syntax highlighting options, and more. They allow you to customize the behavior of Vim on a per-buffer basis, and are commonly used in Vim plugins and scripts.

Note that you can also use the shorter `b:varname` notation to access buffer-local variables directly, but `setbufvar()` and `getbufvar()` provide a more explicit and programmable way to work with them.

## `abort`

The `abort` keyword is used in Vim script function definitions to indicate that the function should abort (fail) when an error occurs, instead of continuing execution after the error.

By default, if an error occurs in a Vim script function, the function will continue executing after the error, which can lead to unexpected behavior or further errors. The `abort` keyword causes the function to immediately terminate when an error occurs, making it easier to handle errors and prevent further issues.

When you define a function with `abort`, Vim will automatically catch any errors that occur within the function and handle them appropriately. If an error occurs, the function will terminate, and the error message will be displayed to the user.

Using `abort` is considered a best practice for Vim script functions, as it helps to make your code more robust and easier to debug. It's particularly useful in larger or more complex functions, where an error in one part of the function could lead to unexpected behavior in other parts if the function continues executing.

In the examples I provided for the `ActiveBuffer` and `Buffers` classes, the `abort` keyword is used on all the method definitions, like this:

```vim
function! l:new_obj.toNext() abort
  " ...
endfunction
```

This ensures that if an error occurs within any of these methods (e.g., an invalid buffer number, a file not found, etc.), the method will immediately abort, preventing further execution and potential issues.

It's a good practice to use `abort` on all Vim script function definitions, unless you have a specific reason to allow the function to continue executing after an error occurs.

## Object-Oriented API

- made object-oriented wrapper for three classes

## `Buffers`

```vim
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
```

## `ActiveBuffer`

```vim
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
```
## `Windows`

```vim
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
```

### Setting Up

- show .vimrc sourcing
- show global declarations in each file

## Examples Using APIs

### Functional Programming

- map
- filter
- lambda

## Run Command Example

- make run command functionality
