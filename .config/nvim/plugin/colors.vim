""foreground:    #3B4252
""background:    #4C566A
syntax on

" configure nvcode-color-schemes
let g:nvcode_termcolors=256

set background=dark
augroup my_colours
  autocmd!
  autocmd ColorScheme onedark hi SpellBad cterm=reverse
augroup END
colorscheme onedark
if (has("termguicolors"))
    set termguicolors
    hi LineNr ctermbg=NONE guibg=NONE guifg=#5eacd3
endif

highlight Cursor               guibg=#A6E22E       guifg=#A6E22E     gui=underline
highlight ColorColumn ctermbg=0 guibg=grey


highlight TelescopeBorder guifg=#5eacd

au! BufWritePost $MYVIMRC source $MYVIMRC
