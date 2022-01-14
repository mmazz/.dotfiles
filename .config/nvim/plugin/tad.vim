augroup tads
    autocmd!
    autocmd BufNewFile,BufRead *.tad setlocal shiftwidth=2 tabstop=2
    autocmd BufNewFile,BufRead *.tad set filetype=tad
    autocmd BufNewFile,BufRead *.tad setlocal notermguicolors

    autocmd BufNewFile,BufRead *.tad  nnoremap <leader>pt :-1read $HOME/.config/templates/tadTemplate.tad<CR>

    "nnoremap <c-l> :w<Return>:!python ~/Documents/Materias/Algo2/algo2tad.py %<Return>:source %:r.vim<Return> :set notermguicolors<Return>
    autocmd BufNewFile,BufRead *.tad nnoremap <c-l> :w<Return>:!python ~/.config/nvim/extras/algo2tad.py %<Return>:source %:r.vim<Return><Esc>
    autocmd BufNewFile,BufRead *.tad inoremap <c-l> <esc>:w<Return>:!python ~/.config/nvim/extras/algo2tad.py %<Return>:source %:r.vim<Return>i
augroup END
