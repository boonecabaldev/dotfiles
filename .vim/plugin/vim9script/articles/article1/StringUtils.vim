vim9script

# Capitalizes the first letter of a word (helper function)
def CapitalizeWord(word: string): string
    if empty(word)
        return ''
    endif
    return toupper(word[0]) .. tolower(word[1 :])
enddef

# Capitalizes the word under the cursor
def CapitalizeCurrentWord()
    var word = expand("<cword>")       # Get the word under cursor
    var capitalized = CapitalizeWord(word)
    if word != capitalized             # Only change if modification is needed
        execute "normal! ciw" .. capitalized  # Replace the word
    endif
enddef

# Map <Leader>cw (or any key) to capitalize the word under cursor
nnoremap -cw <ScriptCmd>CapitalizeCurrentWord()<CR>
