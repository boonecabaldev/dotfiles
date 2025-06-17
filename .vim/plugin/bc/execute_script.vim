" output_pane.vim - Final corrected version

" Only load once
if exists('g:loaded_output_pane')
    finish
endif
let g:loaded_output_pane = 1

" Delete functions if they exist (safe reload)
silent! delfunction CloseOutputPane
silent! delfunction ExecuteToOutputPane

" 1. Close function (now global)
function! CloseOutputPane() abort
    if exists('s:output_bufnr') && bufexists(s:output_bufnr)
        let winid = bufwinid(s:output_bufnr)
        if winid != -1 && win_id2win(winid) > 0
            silent! execute win_id2win(winid) . 'wincmd c'
        endif
    endif
endfunction

" 2. Execute function (global)
function! ExecuteToOutputPane() abort
    " Save state
    let orig_win = win_getid()
    let orig_pos = getpos('.')
    let total_lines = winheight(0)

    " Calculate 25% height (minimum 5 lines)
    let output_height = max([5, float2nr(round(total_lines * 0.25))])

    " Create or reuse bottom pane
    if !exists('s:output_bufnr') || !bufexists(s:output_bufnr)
        botright new
        let s:output_bufnr = bufnr('%')
        setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
        setlocal nomodifiable nowrap nonumber norelativenumber
        setlocal signcolumn=no colorcolumn=0
        nnoremap <buffer> <silent> q :call CloseOutputPane()<CR>
        silent file "[Script Output]"
        execute 'resize ' . output_height
    else
        let output_win = bufwinid(s:output_bufnr)
        if output_win == -1
            botright split
            execute 'buffer' s:output_bufnr
            execute 'resize ' . output_height
        else
            call win_gotoid(output_win)
            execute 'resize ' . output_height
        endif
    endif

    " Prepare output buffer
    setlocal modifiable
    %delete _

    " Execute current script
    call win_gotoid(orig_win)
    redir => output
    try
        silent execute "source " . expand('%')
    catch /.*/
        let output = "ERROR: " . v:exception
    endtry
    redir END

    " Display output
    call win_gotoid(bufwinid(s:output_bufnr))
    call setline(1, split(output, "\n"))
    setlocal nomodifiable

    " Auto-resize if needed
    let content_lines = line('$')
    if content_lines > output_height
        execute 'resize ' . min([content_lines + 2, float2nr(round(total_lines * 0.5))])
    endif

    " Restore original window
    call win_gotoid(orig_win)
    call setpos('.', orig_pos)
endfunction

" Define commands (no need to redefine as they call global functions)
command! -nargs=0 CloseOutputPane call CloseOutputPane()
command! -nargs=0 ExecuteToPane call ExecuteToOutputPane()

" Define mappings
nnoremap <silent> <leader>ee :ExecuteToPane<CR>
nnoremap <silent> <leader>ec :CloseOutputPane<CR>
