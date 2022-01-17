set nocompatible
filetype on
filetype plugin indent on
syntax on
" Default nvim-cmp
set completeopt=menu,menuone,noselect
set directory^=$HOME/.config/nvim/swap//
set spelllang=en_us,es
set autoindent
""set bg=dark
""set background=dark
set clipboard^=unnamed,unnamedplus
set colorcolumn=80,120
set encoding=UTF-8
set expandtab
set guicursor=n-v-c-sm:block
set hidden
set incsearch
set mouse=a
set nu
set nowrap
""set noswapfile
set nobackup
""set nohlsearch
set noerrorbells
set relativenumber
set shiftwidth=4
set scrolloff=8
set sidescrolloff=8
set splitbelow                          " Horizontal splits will automatically be below
set splitright                          " Vertical splits will automatically be to the right
set signcolumn=yes
set smartindent
set title
set tabstop=4 softtabstop=4
""set undodir=~/.config/nvim/undodir
""set undofile
" set noshowmode
" set ls=0
"set nocompatible
" Give more space for displaying messages.
set cmdheight=1

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
"The Primeagen"
let g:netrw_browse_split = 0
let g:netrw_banner = 0
let g:netrw_winsize = 25
au! BufWritePost $MYVIMRC source %
