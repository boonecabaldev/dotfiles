"
" Closes all buffers and panes except current one
"
function! CloseAllButCurrent()
    let current_bufnr = bufnr('%')
    for bufnr in range(1, bufnr('$'))
        if bufexists(bufnr) && buflisted(bufnr) && bufnr != current_bufnr
            silent execute 'bdelete!' bufnr
        endif
    endfor
endfunction

"
" Clears all buffers, runs python3 on current file, and
" sends output to bottom pane.
"
function! RunCommand(command)
  " Save current python file.
  let temp_filename = @%

  call CloseAllButCurrent()

  " Create bottom pane for python output. This leaves
  " cursor in top pane. We want the cursor to be in
  " the bottom pane at this juncture.
  sp

  " Moves cursor back to top pane.
  wincmd j

  " Erases current buffer.  Current python file is
  " opened in both top and bottom pane.  We only want
  " the python file open in the top pane.
  enew

  " Run python file, sending output to bottom pane.
  silent execute "read !" . a:command . " " . temp_filename

  " After you open the file using :read, it will prepend
  " a blank line at the top.  We delete it here.
  normal kdd

  " Move cursor back up to top pane.
  wincmd p

endfunction

nnoremap <leader>r :call RunCommand('python3')<CR>
nnoremap <leader>b :call CloseAllButCurrent()<CR>

nnoremap <F3> :buffers<CR>

function! VimCommandToBuffer(target_buff, cmd)
    execute 'redir @' . a:target_buff
    silent execute a:cmd
    redir END
    
    return getreg(a:target_buff)
endfunction

function! StripEmptyLines(target_buff)
    " Remove empty lines
    new | execute 'put ' . a:target_buff
    "execute 'g/^$/d\|g/^' . bufnr('%') . '/d'
    g/^\s*$/d
    execute '%y ' . a:target_buff
    bd!

    return getreg(a:target_buff)
endfunction

function! MarkCurrentBuffer(target_buff)
    let current_buff = bufnr('%')

    " Remove empty lines
    new | execute 'put ' . a:target_buff
    execute '%s/^\s*' . current_buff . '.*/& <== CURRENT BUFFER/'
    execute '%y ' . a:target_buff
    bd!

    return getreg(a:target_buff)
endfunction

function! GetBufferNumbers(target_buff)
    let bfrs = VimCommandToBuffer(a:target_buff, 'buffers')

    " Split the output into lines
    let lines = split(bfrs, '\n')

    " Initialize an empty list to hold the buffer numbers
    let buffer_numbers = []

    " Iterate over the lines
    for line in lines
        " Split the line into words
        let words = split(line)

        " The buffer number is the first word on the line
        let buffer_number = words[0]

        " Add the buffer number to the list
        call add(buffer_numbers, buffer_number)
    endfor

    return buffer_numbers

endfunction

function! BuffersHub()
    let a = VimCommandToBuffer('a', 'buffers')
    let b = StripEmptyLines('a')
    let bfrs = MarkCurrentBuffer('a')
    echo bfrs

    let bfr_numbers = GetBufferNumbers('a')

    let user_input = input('> ')

    if str2nr(user_input) != 0 || user_input == '0'
        echo "\nYou entered a number.\n"

        if index(bfr_numbers, user_input) != -1
            echo "\nBuffer exists.\n"
            execute 'buffer ' . user_input
        else
            echo "\nBuffer does not exist.\n"
        endif
    else
        echo "\nYou did not enter a number.\n"
    endif
endfunction
