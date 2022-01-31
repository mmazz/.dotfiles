filetype off

let &runtimepath.=',~/.vim/bundle/neoterm'

filetype plugin on
let g:neoterm_bracketed_paste=1
let g:neoterm_repl_python = 'ipython --no-banner --no-autoindent'
let g:neoterm_size=70
let g:neoterm_default_mod = 'vertical'
let g:neoterm_autoscroll=1
let g:neoterm_direct_open_repl=1
" Calling :Tclose or :Ttoggle kills the terminal
let g:neoterm_keep_term_open=1
let g:neoterm_clear_cmd = ["\<c-l>"]
tnoremap <Esc> <C-\><C-n><C-w>j
tnoremap jk <C-\><C-n><C-w>j
tnoremap kj <C-\><C-n><C-w>j
tnoremap <C-c> <C-\><C-n><C-w>j

" only for python for now
augroup pyREPL
    autocmd!
    " send current line and move down
    autocmd BufNewFile,BufRead *.py nnoremap <silent><leader><cr> :TREPLSendLine<cr>j
    " send current selection
    " ('> goes to the last selected Visual area in the current buffer)
    autocmd BufNewFile,BufRead *.py vnoremap <silent><leader><cr> :TREPLSendSelection<cr>'>}j
    autocmd BufNewFile,BufRead *.py nnoremap <C-l> :Tclear<CR>
    autocmd BufNewFile,BufRead *.py nnoremap <leader>tt :Ttoggle<CR>
    autocmd BufNewFile,BufRead *.py inoremap <leader>tt <esc>:Ttoggle<CR>
    autocmd BufNewFile,BufRead *.py tnoremap <leader>tt :Ttoggle<CR>
    autocmd BufNewFile,BufRead *.py nnoremap <leader>tl :TREPLSendLine<CR>
    autocmd BufNewFile,BufRead *.py nnoremap <leader>ts :TREPLSendSelection<CR>
    autocmd BufNewFile,BufRead *.py vnoremap <leader>ts :TREPLSendSelection<CR>
augroup END
