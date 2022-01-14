augroup latex_au
    autocmd!
    autocmd BufNewFile,BufRead *.tex setlocal shiftwidth=2 tabstop=2
    autocmd BufNewFile,BufRead *.tex  nnoremap <leader>tr :-1read $HOME/.config/templates/resumen.tex<CR>   autocmd BufNewFile,BufRead *.tex nnoremap <leader>tr
    autocmd BufWinLeave *.tex !texclear %
augroup END



