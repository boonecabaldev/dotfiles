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

nnoremap <leader>b :call CloseAllButCurrent()<CR>
