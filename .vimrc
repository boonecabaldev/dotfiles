" Global
source ~/.vim/set.vim
source ~/.vim/maps.vim

" Plugins

" Other
" I use the following third-party plugin
"source ~/.vim/plugin/auto-pairs.vim

" My plugins
" This is a plugin I wrote
source ~/.vim/plugin/run_command.vim
source ~/.vim/plugin/bc/active_buffer.vim
source ~/.vim/plugin/bc/buffers.vim
source ~/.vim/plugin/bc/shared.vim
source ~/.vim/plugin/bc/windows.vim

call plug#begin('~/.vim/plugged')
Plug 'girishji/vimcomplete'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
call plug#end()
