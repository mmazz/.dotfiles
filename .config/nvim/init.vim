set termguicolors

call plug#begin('~/.vim/plugged')
    Plug 'morhetz/gruvbox'
    Plug 'navarasu/onedark.nvim'
    Plug 'norcalli/nvim-colorizer.lua' " Hexa color inline

    Plug 'williamboman/nvim-lsp-installer' " Easy install client servers
    Plug 'neovim/nvim-lspconfig'
    Plug 'glepnir/lspsaga.nvim'            " Window with info
    Plug 'hrsh7th/nvim-cmp'                " Complete engine
    Plug 'hrsh7th/cmp-buffer'              " Complete with stuff in buffer
    Plug 'hrsh7th/cmp-path'                " Complete file names
    Plug 'hrsh7th/cmp-nvim-lsp'
    "Plug 'hrsh7th/cmp-nvim-lua'           " Not for now
    "Plug 'wbthomason/lsp-status.nvim'     " Not for now
    Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
    Plug 'onsails/lspkind-nvim'
    "
    "" Snippets
    Plug 'L3MON4D3/LuaSnip'
    Plug 'rafamadriz/friendly-snippets'


    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    Plug 'christianchiarulli/nvcode-color-schemes.vim' " color for treesitter"
    "Plug 'nvim-treesitter/playground' " Why this?

    Plug 'nvim-lualine/lualine.nvim'
    Plug 'kyazdani42/nvim-web-devicons'    " needed for lualine
    Plug 'simrat39/symbols-outline.nvim'

    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzy-native.nvim'

    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-rhubarb'
    Plug 'junegunn/gv.vim'
    ""Plug 'dinhhuy258/git.nvim'   "fugitive in lua
    ""Plug 'lewis6991/gitsigns.nvim'

    Plug 'kassio/neoterm'
    Plug 'julienr/vim-cellmode'
    Plug 'jose-elias-alvarez/null-ls.nvim'
    Plug 'ojroques/vim-oscyank' " Copy from ssh remote
    Plug 'bfredl/nvim-ipy'
    Plug 'vim-utils/vim-man'
 " Undo Tree
    Plug 'mbbill/undotree'
    Plug 'smithbm2316/centerpad.nvim'
    Plug 'lewis6991/spellsitter.nvim'
    ""Plug 'joelbeedle/pseudo-syntax'
call plug#end()

let mapleader = " "
" cada vez que hago resource re hace la funcion.
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup mati
    " Borra el autocmd que pudo haberse corrido previamente. Si no se acumulan
    autocmd!
    " When a write in buffer (save) apply function trim
    autocmd BufWritePre * :call TrimWhitespace()
augroup END

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 40})
augroup END

let g:vimtex_compiler_latexmk = {'build_dir' : 'build'}

autocmd TermOpen * setlocal nonu
let g:python3_host_prog = '/usr/bin/python'
lua require("mati")

au! BufWritePost $MYVIMRC source %      " auto source when writing to init.vm alternatively you can run :source $MYVIMRC

