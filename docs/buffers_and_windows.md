# Advanced Vim - Mastering Buffers and Windows


## Buffer Commands:

- `:e[dit] {file}` - Open a file in a new buffer

- `:bn[ext]` - Go to the next buffer

- `:bp[revious]` - Go to the previous buffer

- `:bl[ast]` - Go to the last buffer in the buffer list

- `:bf[irst]` - Go to the first buffer in the buffer list

- `:b[uffer] {bufname|bufnr}` - Open the specified buffer

- `:sbuffer` - Split window and edit the current buffer

- `:badd {file}` - Add a file to the buffer list

- `:bunload[!] {bufname|bufnr}` - Unload a buffer from memory

- `:bdelete[!] {bufname|bufnr}` - Delete a buffer from the buffer list

- `:ls` - List all buffers

- `:ball` - Open all buffers in the buffer list


## Buffer APIs:

- `bufnr('%')` - Get the number of the current buffer

- `bufname('%')` - Get the name of the current buffer

- `bufexists(expr)` - Check if a buffer exists

- `bufwinnr(bufnr)` - Get the window number of a specific buffer

- `bufload(bufnr)` - Load a specific buffer into memory

- `bufnr(expr)` - Get the buffer number for a specific buffer name or file

- `buflisted(bufnr)` - Check if a buffer is listed in the buffer list

- `bufloaded(bufnr)` - Check if a buffer is loaded into memory

- `bufnr('$')` - Get the number of the alternate buffer

- `buftype(bufnr)` - Get the type of a buffer (e.g., 'help', 'quickfix')

- `buflen(bufnr)` - Get the length (number of lines) of a buffer

Additionally, you can access and modify buffer-specific options using the `:set` command or the `setbufvar()` and `getbufvar()` functions.

These commands and APIs allow you to programmatically open, close, switch, and manage buffers in Vim/Neovim. You can use them in Vimscript or through external plugins and tools that interact with Vim's APIs.


## Window Commands:

- `:split [file]` - Split the current window horizontally

- `:vsplit [file]` - Split the current window vertically

- `:new [file]` - Create a new horizontal window and edit a new file

- `:vnew [file]` - Create a new vertical window and edit a new file

- `:close` - Close the current window

- `:only` - Close all windows except the current one

- `:qall` - Close all windows and exit Vim

- `:resize [+/-]n` - Resize the current window horizontally

- `:vertical resize [+/-]n` - Resize the current window vertically

- `:wincmd =` - Make all windows equal in size

- `:wincmd _` - Maximize the current window horizontally

- `:wincmd |` - Maximize the current window vertically

- `:wincmd h` - Move cursor to the window on the left

- `:wincmd j` - Move cursor to the window below

- `:wincmd k` - Move cursor to the window above

- `:wincmd l` - Move cursor to the window on the right

- `:wincmd w` - Cycle through open windows

- `:wincmd r` - Swap the current window with the next one

- `:wincmd T` - Move the current window to a new tab


## Window APIs:

- `winnr()` - Get the number of the current window

- `win_getid()` - Get the window ID of the current window

- `win_gotoid(win_id)` - Go to the window with the specified ID

- `win_findbuf(bufnr)` - Find the window containing the specified buffer

- `getwininfo()` - Get a list of dictionaries representing window info

- `gettabwininfo()` - Get a list of window info for the current tab

- `win_gettype()` - Get the type of the current window

- `win_getwidth()` - Get the width of the current window

- `win_getHeight()` - Get the height of the current window

- `win_setwidth(n)` - Set the width of the current window

- `win_setHeight(n)` - Set the height of the current window

- `winline()` - Get the line number at the top of the current window

- `winrestcmd()` - Get the window restore command for the current window

Yes, you're correct. There is a `getbufinfo()` API in Vim/Neovim for getting information about buffers. Here's the details:

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

## `ActiveBuffer`

Sure, here's an example of how you can create a `ActiveBuffer` class using a closure in Vim script, with methods that implement the buffer commands and APIs you mentioned:

```vim
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

  return l:new_obj
endfunction

function! ActiveBufferFactory() abort
  return s:ActiveBuffer.new()
endfunction
```

To create an instance of the `ActiveBuffer` class, you can call the `new` method:

```vim
let active_buffer = s:ActiveBuffer.new()
```

Now you can call the methods on the `active_buffer` instance:

```vim
" Switch to the next buffer
call active_buffer.toNext()

" Get the current buffer number
echo active_buffer.number()

" Check if buffer 123 is loaded
echo active_buffer.loaded(123)

" Unload buffer 456
call active_buffer.unload(456)
```


This implementation uses a closure to create the `ActiveBuffer` class, with methods that wrap the corresponding buffer commands and APIs. The `new` method creates a new instance of the class and returns it, with all the methods bound to the instance.

Note that some methods accept arguments (like `bunload` and `bdelete`), while others don't (like `bnext` and `bprevious`). The methods that accept arguments use the `...` syntax to handle variable arguments, and default to the current buffer if no argument is provided.

## `Buffers`

Sure, here's an example of how you can create a `Buffers` class using a closure in Vim script, with methods that implement the buffer commands `edit`, `badd`, `ls`, `ball`, and the `getbufinfo` API:


```vim
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

  function! l:new_obj.infoItems(...) abort
    let l:number = a:0 ? a:1 : 0
    return getbufinfo(l:number)
  endfunction

  function! l:new_obj.setVar(number, varname, val) abort
    call setbufvar(a:number, a:varname, a:val)
  endfunction

  function! l:new_obj.getVar(number, varname) abort
    return getbufvar(a:number, a:varname)
  endfunction

  return l:new_obj
endfunction
```


To create an instance of the `Buffers` class, you can call the `new` method:


```vim
let buffers = s:Buffers.new()
```


Now you can call the methods on the `buffers` instance:


```vim
" Open a new file
call buffers.edit('path/to/file.txt')

" Add a file to the buffer list
call buffers.addFile('path/to/another.py')

" List all buffers
call buffers.list()

" Open all buffers in the buffer list
call buffers.outputAll()

" Get information about all buffers
let buf_info = buffers.infoItems()
```


This implementation uses a closure to create the `Buffers` class, with methods that wrap the corresponding buffer commands and APIs. The `new` method creates a new instance of the class and returns it, with all the methods bound to the instance.

The `edit` and `badd` methods use the `fnameescape` function to properly escape the filename before executing the command. The `getbufinfo` method accepts an optional argument to get information about a specific buffer, or all buffers if no argument is provided.

1. `setbufvar(bufnr, varname, val)`:

   - `bufnr` is the buffer number, or `0` for the current buffer

   - `varname` is the name of the buffer-local variable

   - `val` is the new value to assign to the variable

   This method sets the buffer-local variable `varname` to the given `val` for the specified buffer `bufnr`.

2. `getbufvar(bufnr, varname)`:

   - `bufnr` is the buffer number, or `0` for the current buffer

   - `varname` is the name of the buffer-local variable

   This method retrieves the value of the buffer-local variable `varname` for the specified buffer `bufnr`.

You can use these methods like this:


```vim
let buffers = s:Buffers.new()

" Set a buffer-local variable 'myvar' to 1 for the current buffer
call buffers.setVar(0, 'myvar', 1)

" Get the value of 'myvar' for buffer 123
let val = buffers.getVar(123, 'myvar')

" Set the 'makeprg' option for buffer 456
call buffers.setVar(456, '&makeprg', 'make -j4')
```