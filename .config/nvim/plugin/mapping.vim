 " To get use to exit insert mode with jk
inoremap <esc> <nop>


nnoremap <silent><leader>z <cmd>Centerpad<cr>


nnoremap ff :lua require('telescope.builtin').find_files()<CR>
nnoremap fg :lua require('telescope.builtin').git_files()<CR>
nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>
nnoremap fs :lua require('telescope.builtin').grep_string<CR>
nnoremap fb :lua require('telescope.builtin').buffers()<CR>
nnoremap fh :lua require('telescope.builtin').hel_tags()<CR>



nnoremap <C-s> :w<Esc>
nnoremap <C-q> :wq!<Esc>
inoremap <C-s> <Esc>:w<Esc>
inoremap <C-q> <Esc>:wq!<Esc>
vnoremap <C-s> <Esc>:w<Esc>
vnoremap <C-q> <Esc>:wq!<Esc>
nnoremap <Esc><Esc> :nohlsearch<Esc>

nnoremap <leader>u :UndotreeShow<CR>
cmap w!! w !sudo tee %
" Check file in shellcheck:
map <leader>s :!clear && shellcheck -x %<CR>

" Compile document, be it groff/LaTeX/markdown/etc."  \| es lo que antes era solo |
map <leader>c :w! \| !compiler "<c-r>%"<CR>

" Open corresponding .pdf/.html or preview
map <leader>p :!opout <c-r>%<CR><CR>

nmap <buffer> <leader>r <Esc>:w<CR>:!clear;python %<CR>
nmap <buffer> <leader>b oimport ipdb;ipdb.set_trace(context=4)<ESC>

" Tipo windows
map <C-F> /


map <leader>O :setlocal spell! spelllang=en_us<CR>
map <leader>o :setlocal spell! spelllang=es<CR>
" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
set splitbelow splitright


"Better nav for omnicomplete
""inoremap <expr> <c-j> ("\<C-n>")
""inoremap <expr> <c-k> ("\<C-p>")

" Use alt + hjkl to resize windows
nnoremap <M-j>    :resize -2<CR>
nnoremap <M-k>    :resize +2<CR>
nnoremap <M-h>    :vertical resize -2<CR>
nnoremap <M-l>    :vertical resize +2<CR>

" I hate escape more than anything else
inoremap jk <esc>
inoremap kj <esc>
vnoremap jk <esc>
vnoremap kj <esc>

inoremap JK <esc>
inoremap KJ <esc>


" TAB in general mode will move to text buffer
"nnoremap <TAB> :bnext<CR> " breaks C-i
" SHIFT-TAB will go back
"nnoremap <S-TAB> :bprevious<CR>
"
" <TAB>: completion.
" inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" Better tabbing
vnoremap < <gv
vnoremap > >gv

" Better window navigation
"nnoremap <C-h> <C-w>h
"nnoremap <C-j> <C-w>j
"nnoremap <C-k> <C-w>k
"nnoremap <C-l> <C-w>l

nnoremap <silent> <leader><leader> :source $MYVIMRC<cr>
" The Primeagen
nnoremap Y y$

nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'


vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
inoremap <C-j> <esc>:m .+1<CR>==
nnoremap <leader>j :m .+1<CR>==
inoremap <C-k> <esc>:m .-2<CR>==
nnoremap <leader>k :m .-2<CR>==

" For lsp references
nnoremap <C-k> :cnext<CR>
nnoremap <C-j> :cprev<CR>

" project view
nnoremap <leader>pv :Ex<CR>

au! BufWritePost $MYVIMRC sourcci\'on mayor?ce %
